using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public class LevelSpawner : MonoBehaviour
{
    enum Direction { Up, Down, Left, Right };
    [SerializeField] private GameObject _currentLevel;
    [SerializeField] private GameObject _door;
    [SerializeField] private Direction _direction;
    private GameObject _newLevelPrefab;
    private GameObject _heldObject;
    private GameObject _player;
    private GameObject _paint;
    private Clone _playerC;


    public GameObject newLevelPrefab { get => _newLevelPrefab; set => _newLevelPrefab = value; }
    
    public bool isInRange = false;
    public bool isAlreadySpawned = false;
    private GameObject newLevel;
    

    void OnTriggerEnter(Collider other)
    {
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
        if (other.tag == "Player")
        {
            _playerC.IsInSocleRange = false;
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

    public void SpawnNewLevel()
    {
        _door.SetActive(false);
        if (newLevel == null) newLevel = Instantiate(_heldObject.GetComponent<PaintingController>().newLevelPrefab, Vector3.zero, Quaternion.identity, CameraManager.Instance.CompositeParent.transform);
        newLevel.SetActive(true);
        _heldObject.transform.SetParent(transform);
        _heldObject.transform.localPosition = Vector3.zero;
        _paint = _playerC.heldObject;
        _playerC.heldObject = null;

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
        _door.SetActive(true);
        isAlreadySpawned = false;
        _paint.transform.SetParent(_player.transform);
        _playerC.heldObject = _paint;
        _paint = null;
        newLevel.SetActive(false);
        CameraManager.Instance.RemoveLevel(newLevel);
    }
}
