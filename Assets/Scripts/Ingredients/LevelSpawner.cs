using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using UnityEngine.Events;

public class LevelSpawner : MonoBehaviour
{
    enum Direction { Up, Down, Left, Right };
    [SerializeField] private GameObject _currentLevel;
    [SerializeField] private Direction _direction;
    [SerializeField] private Sprite[] _sprites;
    private GameObject _newLevelPrefab;
    private GameObject _heldObject;
    private GameObject _player;
    private GameObject _paint;
    private Clone _playerC;
    [SerializeField] private UnityEvent OnRemovePainting;
    public GameObject newLevelPrefab { get => _newLevelPrefab; set => _newLevelPrefab = value; }
    
    public bool isInRange = false;
    public bool isAlreadySpawned = false;

    public bool isSoawnOnStart;
    public bool isFixed;
    [SerializeField] private UnityEvent SFX_ApparitionToile;
    [SerializeField] private UnityEvent SFX_DisparitionToile;
    [SerializeField] private UnityEvent SFX_DécalageToile;

    private GameObject _newlevel;
    public bool isSpawnOnStart;
    [SerializeField] private GameObject levelToSpawn;
    

    void OnTriggerEnter(Collider other)
    {
        if (isSoawnOnStart && isFixed) return;
        if (other.tag == "Player")
        {
            _playerC = other.GetComponent<Clone>();
            _playerC.IsInSocleRange = true;
            _heldObject = _playerC.heldObject;
            _player = other.gameObject;
            isInRange = true;
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (isSoawnOnStart && isFixed) return;
        if (other.tag == "Player")
        {
            _playerC.IsInSocleRange = false;
            _heldObject = null;
            _player = null;
            isInRange = false;
        }
    }

    private void Start()
    {
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
        if (isInRange)
        {
            if (_playerC.IsInteracting && _playerC.heldObject != null)
            {
                Debug.Log($"_playerC.heldObject : {_playerC.heldObject}");
            }

            if (!isAlreadySpawned)
            {
                if (_playerC.IsInteracting&&_playerC.heldObject!=null)
                {
                    SpawnNewLevel();
                    CameraManager.Instance.ShowNewLevel();
                    _playerC.IsInteracting = false;
                    SFX_ApparitionToile.Invoke();
                }
            }
            else if (isAlreadySpawned)
            {
                if (_playerC.IsInteracting)
                {
                    CameraManager.Instance.CameraShake();
                    RemoveNewLevel();
                    _playerC.IsInteracting = false;
                    SFX_DisparitionToile.Invoke();
                }
            }
        }
    }

    public void SpawnLevelOnStart()
    {
        _paint = transform.GetChild(0).gameObject;
        _newlevel = Instantiate(levelToSpawn, Vector3.zero, Quaternion.identity, CameraManager.Instance.CompositeParent.transform);
        _newlevel.name = levelToSpawn.name;
        CameraManager.Instance.AddNewLevel(_newlevel);

        var newLevelBounds = _newlevel.GetComponent<SpriteRenderer>().bounds.size;
        var currentLevelBounds = _currentLevel.GetComponent<SpriteRenderer>().bounds.size;
        SetDirection(newLevelBounds, currentLevelBounds);
    }

    public void SpawnNewLevel()
    {
        if (_heldObject == null) return;

        var paintingController = _heldObject.GetComponent<PaintingController>();
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
        _paint = _playerC.heldObject;
        _player.GetComponent<Clone>().heldObject = null;

        var newLevelBounds = _newlevel.GetComponent<SpriteRenderer>().bounds.size;
        var currentLevelBounds = _currentLevel.GetComponent<SpriteRenderer>().bounds.size;

        SetDirection(newLevelBounds, currentLevelBounds);

        if (CanBePlaced(_newlevel))
        {
            SetDirection(newLevelBounds, currentLevelBounds);
        }
        else
        {
            SetDirection(newLevelBounds, currentLevelBounds);
            SetNewPosition();
        }

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

                    if (newLevelBounds.Intersects(existingBounds))
                    {
                        Vector2 offset = GetCollisionOffset(newLevelBounds, existingBounds);

                        _newlevel.transform.position -= new Vector3(offset.x, offset.y, 0);
                    }
                }
            }
            attempts++;
        }

        SFX_DécalageToile.Invoke();

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

        Vector2 offset = Vector2.zero;

        if (minOverlap == leftOverlap)
            offset.x = -leftOverlap; // Collision à gauche
        else if (minOverlap == rightOverlap)
            offset.x = rightOverlap; // Collision à droite
        else if (minOverlap == bottomOverlap)
            offset.y = -bottomOverlap; // Collision en bas
        else if (minOverlap == topOverlap)
            offset.y = topOverlap; // Collision en haut

        Debug.Log($"Décalage : {offset}");
        return offset;
    }

    private void SetDirection(Vector3 newLevelBounds, Vector3 currentLevelBounds)
    {
        switch (_direction)
        {
            case Direction.Up:
                _newlevel.transform.position = new Vector3(_currentLevel.transform.position.x, _currentLevel.transform.position.y + currentLevelBounds.y / 2 + newLevelBounds.y / 2, 0);
                break;
            case Direction.Down:
                _newlevel.transform.position = new Vector3(_currentLevel.transform.position.x, _currentLevel.transform.position.y - currentLevelBounds.y / 2 - newLevelBounds.y / 2, 0);
                break;
            case Direction.Left:
                _newlevel.transform.position = new Vector3(_currentLevel.transform.position.x - currentLevelBounds.x / 2 - newLevelBounds.x / 2, _currentLevel.transform.position.y, 0);
                break;
            case Direction.Right:
                _newlevel.transform.position = new Vector3(_currentLevel.transform.position.x + currentLevelBounds.x / 2 + newLevelBounds.x / 2, _currentLevel.transform.position.y, 0);
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
                    newLevelBounds.Expand(-0.1f);

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
                    newLevelBounds.Expand(-0.1f);

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
        _paint.transform.SetParent(_player.transform);
        _playerC.heldObject = _paint;
        _paint = null;
        _newlevel.SetActive(false);
        CameraManager.Instance?.RemoveLevel(_newlevel);
    }
}
