using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public class LevelSpawner : MonoBehaviour
{
    enum Direction { Up, Down, Left, Right };
    [SerializeField] private GameObject _currentLevel;
    [SerializeField] private Direction _direction;
    private GameObject _newLevelPrefab;
    private GameObject _heldObject;
    private GameObject _player;

    public GameObject newLevelPrefab { get => _newLevelPrefab; set => _newLevelPrefab = value; }
    
    public bool isInRange = false;
    public bool isAlreadySpawned = false;
    private GameObject newLevel;

    public bool isSpawnOnStart;
    public bool isFixed;
    [SerializeField] private GameObject levelToSpawn;
    

    void OnTriggerEnter(Collider other)
    {
        if (isSpawnOnStart && isFixed) return;
        if (other.tag == "Player")
        {
            _heldObject = other.GetComponent<PlayerControllerTest>().heldObject;
            _player = other.gameObject;
            isInRange = true;
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (isSpawnOnStart && isFixed) return;
        if (other.tag == "Player")
        {
            _heldObject = null;
            _player = null;
            isInRange = false;
        }
    }

    void Start()
    {
        if (isSpawnOnStart)
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
                if (Input.GetKeyDown(KeyCode.E))
                {
                    SpawnNewLevel();
                }
            }
            else if (isAlreadySpawned)
            {
                if (Input.GetKeyDown(KeyCode.E))
                {
                    RemoveNewLevel();
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
        _player.GetComponent<PlayerControllerTest>().heldObject = null;

        var newLevelBounds = newLevel.GetComponent<SpriteRenderer>().bounds.size;
        var currentLevelBounds = _currentLevel.GetComponent<SpriteRenderer>().bounds.size;
        SetDirection(newLevelBounds, currentLevelBounds);

        if (CanBePlaced(newLevel))
        {
            //SetDirection(newLevelBounds, currentLevelBounds);
        }
        else
        {
            //Debug.Log($"Non");
        }

        isAlreadySpawned = true;
    }

    private void SetDirection(Vector3 newLevelBounds, Vector3 currentLevelBounds)
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
        isAlreadySpawned = false;
        _player.GetComponent<PlayerControllerTest>().heldObject = _heldObject;
        newLevel.SetActive(false);
    }
}
