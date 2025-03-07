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
    private GameObject _newLevelPrefab;
    private GameObject _heldObject;
    private GameObject _player;
    private GameObject _paint;
    private Clone _playerC;

    [SerializeField] private UnityEvent OnRemovePainting;
    public GameObject newLevelPrefab { get => _newLevelPrefab; set => _newLevelPrefab = value; }
    
    public bool isInRange = false;
    public bool isAlreadySpawned = false;
    private GameObject newLevel;

    public bool isSoawnOnStart;
    public bool isFixed;
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
    }

    void Update()
    {
        if (isInRange)
        {
            
            if (!isAlreadySpawned)
            {
                if (_playerC.IsInteracting&&_playerC.heldObject!=null)
                {
                    SpawnNewLevel();
                    _playerC.IsInteracting = false;
                }
            }
            else if (isAlreadySpawned)
            {
                if (_playerC.IsInteracting)
                {
                    RemoveNewLevel();
                    _playerC.IsInteracting = false;
                }
            }
        }
    }

    public void SpawnLevelOnStart()
    {
        newLevel = Instantiate(levelToSpawn, Vector3.zero, Quaternion.identity, CameraManager.Instance.CompositeParent.transform);
        newLevel.name = levelToSpawn.name;
        CameraManager.Instance.AddNewLevel(newLevel);

        var newLevelBounds = newLevel.GetComponent<SpriteRenderer>().bounds.size;
        var currentLevelBounds = _currentLevel.GetComponent<SpriteRenderer>().bounds.size;

        SetDirection(newLevelBounds, currentLevelBounds);
    }

    public void SetDirection(Vector3 newLevelBounds, Vector3 currentLevelBounds)
    {
        switch (_direction)
        {
            case Direction.Up:
                newLevel.transform.position = new Vector3(_currentLevel.transform.position.x, _currentLevel.transform.position.y + currentLevelBounds.y / 2 + newLevelBounds.y / 2, 0);
                break;
            case Direction.Down:
                newLevel.transform.position = new Vector3(_currentLevel.transform.position.x, _currentLevel.transform.position.y - currentLevelBounds.y / 2 - newLevelBounds.y / 2, 0);
                break;
            case Direction.Left:
                newLevel.transform.position = new Vector3(_currentLevel.transform.position.x - currentLevelBounds.x / 2 - newLevelBounds.x / 2, _currentLevel.transform.position.y, 0);
                break;
            case Direction.Right:
                newLevel.transform.position = new Vector3(_currentLevel.transform.position.x + currentLevelBounds.x / 2 + newLevelBounds.x / 2, _currentLevel.transform.position.y, 0);
                break;
        }
    }

    public void SpawnNewLevel()
    {
        if (_heldObject == null) return;

        var paintingController = _heldObject.GetComponent<PaintingController>();
        var newLevelPrefab = paintingController.newLevelPrefab;

        if (!CameraManager.Instance.Levels.Exists(level => level.name == newLevelPrefab.name))
        {
            newLevel = Instantiate(newLevelPrefab, Vector3.zero, Quaternion.identity, CameraManager.Instance.CompositeParent.transform);
            newLevel.name = newLevelPrefab.name;
            CameraManager.Instance.AddNewLevel(newLevel);
        }
        else
        {
            newLevel = CameraManager.Instance.Levels.Find(level => level.name == newLevelPrefab.name);
            Debug.Log($"Level {newLevel.name} already exists");
            newLevel.SetActive(true);
        }

        _heldObject.transform.SetParent(transform);
        _heldObject.transform.localPosition = Vector3.zero;
        _paint = _playerC.heldObject;
        _player.GetComponent<Clone>().heldObject = null;

        var newLevelBounds = newLevel.GetComponent<SpriteRenderer>().bounds.size;
        var currentLevelBounds = _currentLevel.GetComponent<SpriteRenderer>().bounds.size;

        SetDirection(newLevelBounds, currentLevelBounds);

        if (CanBePlaced(newLevel))
        {
            Debug.Log($"Oui");
        }
        else
        {
            Debug.Log($"Non");
        }

        isAlreadySpawned = true;
    }

    private bool CanBePlaced(GameObject newLevel)
    {
        foreach (var level in CameraManager.Instance.Levels)
        {
            if (level == newLevel) continue;

            if (level.TryGetComponent(out SpriteRenderer sr))
            {
                if (newLevel.TryGetComponent(out SpriteRenderer newSr))
                {
                    if (newSr.bounds.Intersects(sr.bounds))
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
        newLevel.SetActive(false);
        CameraManager.Instance?.RemoveLevel(newLevel);
    }
}
