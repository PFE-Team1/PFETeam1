using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using UnityEngine.Events;

public class LevelSpawner : Interactable
{
    enum Direction { Up, Down, Left, Right };
    [SerializeField] private GameObject _currentLevel;
    [SerializeField] private Direction _direction;
    [SerializeField] private Sprite[] _sprites;
    [SerializeField] private GameObject levelToSpawnOnStart;
    [SerializeField] private bool isSpawnOnStart = false;
    [SerializeField] private bool isAlreadySpawned = false;
    [SerializeField] private bool isFixed = false;
    private GameObject _heldObject;
    private GameObject _paint;    
    float appliedOffset;
    private GameObject _newlevel;
    

    private void Start()
    {
        appliedOffset = GetComponentInParent<Level>().Offset;
        if (isAlreadySpawned)
        {
            SpawnLevelOnStart();
        }

        switch (_direction)
        {
            case Direction.Up:
                this.gameObject.GetComponent<SpriteRenderer>().sprite = _sprites[0];
                break;
            case Direction.Down:
                this.gameObject.GetComponent<SpriteRenderer>().sprite = _sprites[1];
                break;
            case Direction.Left:
                this.gameObject.GetComponent<SpriteRenderer>().sprite = _sprites[2];
                break;
            case Direction.Right:
                this.gameObject.GetComponent<SpriteRenderer>().sprite = _sprites[3];
                break;
        }
    }

    void Update()
    {
        if (PlayerC != null)
        {
            _heldObject = PlayerC.heldObject;
        }
        if (IsInRange)
        {
            PlayerC.IsInSocleRange = true;
            if (isSpawnOnStart && isFixed) return;
            if (!isAlreadySpawned)
            {
                if (!PlayerC.HasInteracted && PlayerC.heldObject != null && PlayerC.IsInteracting)
                {
                    SpawnNewLevel();
                    PlayerC.HasInteracted = true;
                    AudioManager.Instance.SFX_ApparitionToile.Post(gameObject);
                    CameraManager.Instance.ShowNewLevel();
                }
            }
            else if (isAlreadySpawned)
            {
                if (!PlayerC.HasInteracted && PlayerC.IsInteracting)
                {
                    CameraManager.Instance.CameraShake(1,1);
                    RemoveNewLevel();
                    PlayerC.HasInteracted = true;
                    AudioManager.Instance.SFX_DisparitionToile.Post(gameObject);
                }
            }
        }
    }

    public void SpawnLevelOnStart()
    {
        _paint = transform.GetChild(0).gameObject;
        _newlevel = Instantiate(levelToSpawnOnStart, Vector3.zero, Quaternion.identity, CameraManager.Instance.CompositeParent.transform);
        _newlevel.name = levelToSpawnOnStart.name;
        _paint.GetComponent<Collider>().enabled = false;
        _paint.GetComponent<PaintingController>().IsInRange = false;
        var newLevelBounds = _newlevel.GetComponent<SpriteRenderer>().bounds.size;
        var currentLevelBounds = _currentLevel.GetComponent<SpriteRenderer>().bounds.size;
        SetDirection(newLevelBounds + Vector3.one * appliedOffset, currentLevelBounds + Vector3.one * appliedOffset);
        CameraManager.Instance.AddNewLevel(_newlevel);
        CameraManager.Instance.SetNewLevel(_newlevel);
    }

    public void SpawnNewLevel()
    {
        if (_heldObject == null) return;

        var paintingController = _heldObject.GetComponent<PaintingController>();
        _heldObject.GetComponent<Collider>().enabled = false;
        _heldObject.GetComponent<PaintingController>().IsInRange = false;
        var newLevelPrefab = paintingController.newLevelPrefab;

        if (!CameraManager.Instance.Levels.Exists(level => level.name == newLevelPrefab.name))
        {
            _newlevel = Instantiate(newLevelPrefab, Vector3.zero, Quaternion.identity, CameraManager.Instance.CompositeParent.transform);
            _newlevel.name = newLevelPrefab.name;
            CameraManager.Instance.AddNewLevel(_newlevel);
        }
        else
        {
            _newlevel = CameraManager.Instance.Levels.Find(level => level.name == newLevelPrefab.name);
            _newlevel.SetActive(true);
        }

        _heldObject.transform.SetParent(transform);
        _heldObject.transform.localPosition = Vector3.zero;
        _paint = PlayerC.heldObject;
        PlayerC.heldObject = null;

        var newLevelBounds = _newlevel.GetComponent<SpriteRenderer>().bounds.size;
        var currentLevelBounds = _currentLevel.GetComponent<SpriteRenderer>().bounds.size;

        SetDirection(newLevelBounds, currentLevelBounds);

        if (CanBePlaced(_newlevel))
        {
            SetDirection(newLevelBounds + Vector3.one * appliedOffset, currentLevelBounds + Vector3.one * appliedOffset);
        }
        else
        {
            SetDirection(newLevelBounds + Vector3.one * appliedOffset, currentLevelBounds + Vector3.one * appliedOffset);
            SetNewPosition();
        }

        CameraManager.Instance.SetNewLevel(_newlevel);

        isAlreadySpawned = true;
    }

    private void SetNewPosition()
    {
        int maxAttempts = 50; // On limite à 50 essais pour éviter une boucle infinie
        int attempts = 0;

        while (!CanBePlaced(_newlevel) && attempts < maxAttempts)
        {
            foreach (var level in CameraManager.Instance.Levels)
            {
                if (level == _newlevel) continue;

                if (level.TryGetComponent(out SpriteRenderer sr) && _newlevel.TryGetComponent(out SpriteRenderer newSr))
                {
                    Bounds newLevelBounds = newSr.bounds;
                    Bounds existingBounds = sr.bounds;

                    newLevelBounds.Expand(appliedOffset * 2);
                    existingBounds.Expand(appliedOffset * 2);

                    if (newLevelBounds.Intersects(existingBounds))
                    {
                        Vector2 offset = GetCollisionOffset(newLevelBounds, existingBounds);

                        _newlevel.transform.position -= new Vector3(offset.x, offset.y, 0);
                    }
                }
            }
            attempts++;
        }

        AudioManager.Instance.SFX_DécalageToile.Post(gameObject);

        if (attempts >= maxAttempts)
        {
            Debug.LogWarning("Impossible de placer l'objet sans collision après plusieurs essais !");
        }
    }

    private Vector2 GetCollisionOffset(Bounds newBounds, Bounds existingBounds)
    {
        float leftOverlap = Mathf.Abs(newBounds.min.x - existingBounds.max.x);
        float rightOverlap = Mathf.Abs(newBounds.max.x - existingBounds.min.x);
        float bottomOverlap = Mathf.Abs(newBounds.min.y - existingBounds.max.y);
        float topOverlap = Mathf.Abs(newBounds.max.y - existingBounds.min.y);

        float minOverlap = Mathf.Min(leftOverlap, rightOverlap, bottomOverlap, topOverlap);

        Vector2 offsetLocal = Vector2.zero;

        if (minOverlap == leftOverlap)
            offsetLocal.x = -leftOverlap; // Collision à gauche
        else if (minOverlap == rightOverlap)
            offsetLocal.x = rightOverlap; // Collision à droite
        else if (minOverlap == bottomOverlap)
            offsetLocal.y = -bottomOverlap; // Collision en bas
        else if (minOverlap == topOverlap)
            offsetLocal.y = topOverlap; // Collision en haut

        return offsetLocal;
    }

    private void SetDirection(Vector3 newLevelBounds, Vector3 currentLevelBounds)
    {
        switch (_direction)
        {
            case Direction.Up:
                _newlevel.transform.position = new Vector3(_currentLevel.transform.position.x, _currentLevel.transform.position.y + currentLevelBounds.y / 2 + newLevelBounds.y / 2 + appliedOffset, 0);
                break;
            case Direction.Down:
                _newlevel.transform.position = new Vector3(_currentLevel.transform.position.x, _currentLevel.transform.position.y - currentLevelBounds.y / 2 - newLevelBounds.y / 2 - appliedOffset, 0);
                break;
            case Direction.Left:
                _newlevel.transform.position = new Vector3(_currentLevel.transform.position.x - currentLevelBounds.x / 2 - newLevelBounds.x / 2 - appliedOffset, _currentLevel.transform.position.y, 0);
                break;
            case Direction.Right:
                _newlevel.transform.position = new Vector3(_currentLevel.transform.position.x + currentLevelBounds.x / 2 + newLevelBounds.x / 2 + appliedOffset, _currentLevel.transform.position.y, 0);
                break;
        }
    }

    private Vector2? TouchingBounds(GameObject _newlevel)
    {
        foreach (var level in CameraManager.Instance.Levels)
        {
            if (level == _newlevel) continue;

            if (level.TryGetComponent(out SpriteRenderer sr))
            {
                if (_newlevel.TryGetComponent(out SpriteRenderer newSr))
                {
                    Bounds newLevelBounds = newSr.bounds;
                    newLevelBounds.Expand(appliedOffset * 2);

                    return GetTouchingBounds(newLevelBounds, sr.bounds);
                }
            }
        }
        return null;
    }

    public Vector2 GetTouchingBounds(Bounds newLevelBounds, Bounds srBounds)
    {
        Vector2 touchingBounds = new Vector2();
        if (newLevelBounds.Intersects(srBounds))
        {
            if (newLevelBounds.min.x < srBounds.min.x)
            {
                touchingBounds.x = newLevelBounds.min.x - srBounds.min.x;
            }
            else if (newLevelBounds.max.x > srBounds.max.x)
            {
                touchingBounds.x = newLevelBounds.max.x - srBounds.max.x;
            }

            if (newLevelBounds.min.y < srBounds.min.y)
            {
                touchingBounds.y = newLevelBounds.min.y - srBounds.min.y;
            }
            else if (newLevelBounds.max.y > srBounds.max.y)
            {
                touchingBounds.y = newLevelBounds.max.y - srBounds.max.y;
            }
        }
        return touchingBounds;
    }

    private bool CanBePlaced(GameObject _newlevel)
    {
        foreach (var level in CameraManager.Instance.Levels)
        {
            if (level == _newlevel) continue;

            if (level.TryGetComponent(out SpriteRenderer sr))
            {
                if (_newlevel.TryGetComponent(out SpriteRenderer newSr))
                {
                    Bounds newLevelBounds = newSr.bounds;
                    newLevelBounds.Expand(appliedOffset * 2);

                    if (newLevelBounds.Intersects(sr.bounds))
                    {
                        return false;
                    }
                }
            }
        }
        return true;
    }

    public void RemoveNewLevel()
    {
        //OnRemovePainting.Invoke();
        isAlreadySpawned = false;
        _paint.transform.SetParent(Player.transform);
        _paint.GetComponent<Collider>().enabled = true ;
        PlayerC.heldObject = _paint;
        _paint = null;
        CameraManager.Instance?.RemoveLevel(_newlevel);
    }

    void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            IsInRange = false;
            PlayerC.IsInSocleRange = false;
        }
    }
}
