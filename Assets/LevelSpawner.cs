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
    

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            _heldObject = other.GetComponent<PlayerControllerTest>().heldObject;
            _player = other.gameObject;
            isInRange = true;
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            _heldObject = null;
            _player = null;
            isInRange = false;
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

    public void SpawnNewLevel()
    {
        if (newLevel == null) newLevel = Instantiate(_heldObject.GetComponent<PaintingController>().newLevelPrefab, Vector3.zero, Quaternion.identity, CameraManager.Instance.CompositeParent.transform);
        newLevel.SetActive(true);
        _heldObject.transform.SetParent(transform);
        _heldObject.transform.localPosition = Vector3.zero;

        _player.GetComponent<PlayerControllerTest>().heldObject = null;

        switch (_direction)
        {
            case Direction.Up:
                newLevel.transform.position = new Vector3(_currentLevel.transform.position.x, _currentLevel.transform.position.y + _currentLevel.GetComponent<SpriteRenderer>().bounds.size.y, 0);
                break;
            case Direction.Down:
                newLevel.transform.position = new Vector3(_currentLevel.transform.position.x, _currentLevel.transform.position.y - _currentLevel.GetComponent<SpriteRenderer>().bounds.size.y, 0);
                break;
            case Direction.Left:
                newLevel.transform.position = new Vector3(_currentLevel.transform.position.x - _currentLevel.GetComponent<SpriteRenderer>().bounds.size.x, _currentLevel.transform.position.y, 0);
                break;
            case Direction.Right:
                newLevel.transform.position = new Vector3(_currentLevel.transform.position.x + _currentLevel.GetComponent<SpriteRenderer>().bounds.size.x, _currentLevel.transform.position.y, 0);
                break;
        }
        isAlreadySpawned = true;
        CameraManager.Instance.AddNewLevel(newLevel);
    }

    public void RemoveNewLevel()
    {
        isAlreadySpawned = false;
        _player.GetComponent<PlayerControllerTest>().heldObject = _heldObject;
        newLevel.SetActive(false);
        CameraManager.Instance.RemoveLevel(newLevel);
    }
}
