using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
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


    protected override void Start()
    {
        base.Start();
        isSocle = true;
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

        //_heldObject.GetComponent<Collider>().enabled = false;
        _heldObject.GetComponent<PaintingController>().IsInRange = false;
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
        _paint = PlayerC.heldObject;

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
        foreach (OpenButton openButton in _newlevel.GetComponentsInChildren<OpenButton>(true))
        {
            openButton.ReStart();
        }
        CameraManager.Instance.SetNewLevel(_newlevel);

        //FindPlayer(true);
        isAlreadySpawned = true;
        paintingController.FreezePos();
        paintingController.AnimateDropPainting(transform);
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
            offsetLocal.x += -leftOverlap; // Collision à gauche

        if (minOverlap == rightOverlap)
            offsetLocal.x += rightOverlap; // Collision à droite

        if (minOverlap == bottomOverlap)
            offsetLocal.y += -bottomOverlap; // Collision en bas

        if (minOverlap == topOverlap)
            offsetLocal.y += topOverlap; // Collision en haut

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

    private bool CanBePlaced(GameObject _newlevel)
    {
        foreach (var level in CameraManager.Instance.Levels)
        {
            if (level == _newlevel) continue;
            if (!level.activeInHierarchy) return true;
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

        var paintingController = _paint.GetComponent<PaintingController>();
        paintingController.AnimateGrabPainting();
        _paint = null;
        CameraManager.Instance?.RemoveLevel(_newlevel);

    }



    protected override void Interact()
    { 
  
        if (PlayerC != null)
        {
            _heldObject = PlayerC.heldObject;
        }
        if (IsInRange)
        {
            if (isSpawnOnStart && isFixed) return;
            if (!isAlreadySpawned&&_heldObject!=null)
            {
                Buffer = 5;
                SpawnNewLevel();
                    PlayerStateMachine.ChangeState(PlayerStateMachine.PaintingDropState);
                    AudioManager.Instance.SFX_ApparitionToile.Post(gameObject);
                    //CameraManager.Instance.ShowNewLevel();
            }
            else if (isAlreadySpawned)
            {
                Buffer = 5;
                CameraManager.Instance.CameraShake(1, 1);
                    RemoveNewLevel();
                    PlayerStateMachine.ChangeState(PlayerStateMachine.PaintingGrabState);
                    AudioManager.Instance.SFX_DisparitionToile.Post(gameObject);
            }
        }
    }
    private List<GameObject> AllChilds(GameObject root)
    {
        List<GameObject> result = new List<GameObject>();
        if (root.transform.childCount > 0)
        {
            foreach (Transform VARIABLE in root.transform)
            {
                Searcher(result, VARIABLE.gameObject);
            }
        }
        return result;
    }
    private void Searcher(List<GameObject> list, GameObject root)
    {
        list.Add(root);
        if (root.transform.childCount > 0)
        {
            foreach (Transform VARIABLE in root.transform)
            {
                if (VARIABLE.gameObject.layer != 3)
                    Searcher(list, VARIABLE.gameObject);
            }
        }
    }
}
