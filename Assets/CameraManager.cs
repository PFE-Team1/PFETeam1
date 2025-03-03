using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Cinemachine;

public class CameraManager : MonoBehaviour
{
    public static CameraManager Instance { get; private set; }
    [SerializeField] private GameObject[] _levels;
    [SerializeField] private GameObject _currentLevel;
    [SerializeField] private CinemachineVirtualCamera _mainCamera;
    public CinemachineVirtualCamera mainCamera { get => _mainCamera; set => _mainCamera = value; }

    void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
        }
        else
        {
            Destroy(gameObject);
        }
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F1))
        {
            SeeAllLevels();
        }
        else if (Input.GetKeyDown(KeyCode.F2))
        {
            SeeCurrentLevel();
        }
    }

    public void SeeAllLevels()
    {
        Bounds bounds = new Bounds(_levels[0].transform.position, Vector3.zero);
        foreach (GameObject level in _levels)
        {
            bounds.Encapsulate(level.GetComponent<Renderer>().bounds);
        }

        _mainCamera.transform.position = bounds.center - _mainCamera.transform.forward * bounds.size.magnitude;
    }

    public void SeeCurrentLevel()
    {
        //permet au joueur de voir le niveau actuel
    }

    public void AddNewLevel(GameObject newLevel)
    {
        List<GameObject> levelsList = new List<GameObject>(_levels);
        levelsList.Add(newLevel);
        _levels = levelsList.ToArray();
    }

    public void RemoveLevel(GameObject level)
    {
        for (int i = 0; i < _levels.Length; i++)
        {
            if (_levels[i] == level)
            {
                _levels[i] = null;
            }
        }
    }
}
