using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public class CameraManager : MonoBehaviour
{
    public static CameraManager Instance { get; private set; }
    
    [SerializeField] private GameObject[] _levels; 
    [SerializeField] private CinemachineVirtualCamera _mainCamera;
    public CinemachineVirtualCamera MainCamera { get => _mainCamera; set => _mainCamera = value; }

    private Bounds _cameraBounds;
    private Camera _globalCamera;


    void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
        }
        else
        {
            Destroy(gameObject);
            return;
        }

        CalculateWorldBounds();
    }

    void Start()
    {
        CalculateCameraBounds();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F1))
        {
            SeeAllLevels();
        }
    }

    private void CalculateWorldBounds()
    {
        if (_levels.Length == 0) return;

        Bounds worldBounds = _levels[0].GetComponent<SpriteRenderer>().bounds;
        
        foreach (var level in _levels)
        {
            if (level.TryGetComponent(out SpriteRenderer sr))
            {
                worldBounds.Encapsulate(sr.bounds);
            }
        }

        GlobalsCamera.WorldBounds = worldBounds;
    }

    private void CalculateCameraBounds()
    {
        float height = _mainCamera.m_Lens.OrthographicSize;
        float width = height * _mainCamera.m_Lens.Aspect;

        float minX = GlobalsCamera.WorldBounds.min.x + width;
        float maxX = GlobalsCamera.WorldBounds.max.x - width;
        float minY = GlobalsCamera.WorldBounds.min.y + height;
        float maxY = GlobalsCamera.WorldBounds.max.y - height;

        _cameraBounds = new Bounds();
        _cameraBounds.SetMinMax(
            new Vector3(minX, minY, 0),
            new Vector3(maxX, maxY, 0)
        );
    }

    public void SeeAllLevels()
    {
        Camera _globalCamera = Instantiate(Camera.main);

        float worldWidth = GlobalsCamera.WorldBounds.size.x;
        float worldHeight = GlobalsCamera.WorldBounds.size.y;

        float aspectRatio = _globalCamera.aspect;

        _globalCamera.transform.position = new Vector3(GlobalsCamera.WorldBounds.center.x, GlobalsCamera.WorldBounds.center.y, -20);
        _globalCamera.transform.LookAt(GlobalsCamera.WorldBounds.center);
    }

    public void AddNewLevel(GameObject newLevel)
    {
        List<GameObject> levelsList = new List<GameObject>(_levels);
        levelsList.Add(newLevel);
        _levels = levelsList.ToArray();

        newLevel.GetComponentInChildren<CinemachineVirtualCamera>().Follow = _mainCamera.Follow;

        CalculateWorldBounds();
        CalculateCameraBounds();
    }

    public void RemoveLevel(GameObject level)
    {
        List<GameObject> levelsList = new List<GameObject>(_levels);
        levelsList.Remove(level);
        _levels = levelsList.ToArray();

        CalculateWorldBounds();
        CalculateCameraBounds();
    }
}
