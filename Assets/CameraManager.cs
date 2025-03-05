using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using Unity.VisualScripting;

public class CameraManager : MonoBehaviour
{
    public static CameraManager Instance { get; private set; }
    [SerializeField] private List<GameObject> _levels; 
    [SerializeField] private CinemachineVirtualCamera _mainCamera;
    private List<CinemachineVirtualCamera> _allCameras = new List<CinemachineVirtualCamera>();

    private Bounds _cameraBounds;
    private Camera _globalCamera;

    public float _cameraZoomSpeed = 1f;
    public float _cameraMoveSpeed = 1f;

    private Coroutine _zoomCoroutine;
    private Coroutine _dezoomCoroutine;

    public CinemachineVirtualCamera MainCamera { get => _mainCamera; set => _mainCamera = value; }
    public List<CinemachineVirtualCamera> AllCameras { get => _allCameras; set => _allCameras = value; }

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

        _allCameras.AddRange(_mainCamera.GetComponentsInChildren<CinemachineVirtualCamera>());
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F1))
        {
            SeeAllLevels();
        }

        if (Input.GetKeyDown(KeyCode.F2))
        {
            FocusCamera();
        }
    }

    private void CalculateWorldBounds()
    {
        if (_levels.Count - 1 == 0) return;

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
        if (_globalCamera != null) return;

        _globalCamera = new GameObject("Global Camera").AddComponent<Camera>();
        _globalCamera.orthographic = false;        

        Bounds combinedBounds = new Bounds();
        foreach (var level in _levels)
        {
            if (level.activeInHierarchy && level.TryGetComponent(out SpriteRenderer sr))
            {
                combinedBounds.Encapsulate(sr.bounds);
            }
        }

        float worldWidth = combinedBounds.size.x;
        float worldHeight = combinedBounds.size.y;
        float aspectRatio = _globalCamera.aspect;

        _globalCamera.clearFlags = CameraClearFlags.SolidColor;
        _globalCamera.backgroundColor = Color.black;

        float distance = Mathf.Max(worldWidth / (2 * aspectRatio), worldHeight / 2) / Mathf.Tan(Mathf.Deg2Rad * _globalCamera.fieldOfView / 2);

        if (_zoomCoroutine != null) return;
        _dezoomCoroutine = StartCoroutine(DezoomEffect(combinedBounds.center, distance, () =>
        {
            _dezoomCoroutine = null;
        }));
        }

    private IEnumerator DezoomEffect(Vector3 targetPosition, float targetDistance, System.Action onComplete)
    {
        float initialDistance = _mainCamera.transform.position.z;
        float elapsedTime = 0f;

        while (elapsedTime < _cameraZoomSpeed)
        {
            float currentDistance = Mathf.Lerp(initialDistance, -targetDistance, elapsedTime / _cameraZoomSpeed);
            _globalCamera.transform.position = new Vector3(targetPosition.x, targetPosition.y, currentDistance);
            _globalCamera.transform.LookAt(targetPosition);
            elapsedTime += Time.deltaTime;
            yield return null;
        }

        _globalCamera.transform.position = new Vector3(targetPosition.x, targetPosition.y, -targetDistance);
        _globalCamera.transform.LookAt(targetPosition);

        onComplete?.Invoke(); 
    }

    public void SwitchToCamera(int index)
    {
        for (int i = 0; i < _allCameras.Count; i++)
        {
            if (i == index)
            {
                _allCameras[i].Priority = 10;
            }
            else
            {
                _allCameras[i].Priority = 0;
            }
        }
    }

    public void FocusCamera()
    {
        if (_globalCamera != null)
        {
            if (_dezoomCoroutine != null) return;
            _zoomCoroutine = StartCoroutine(ZoomEffect(_mainCamera.transform.position, _globalCamera.transform.position.z, () =>
            {
                Destroy(_globalCamera.gameObject);
                _globalCamera = null;
                _zoomCoroutine = null;
            }));
        }
    }

    private IEnumerator ZoomEffect(Vector3 targetPosition, float initialDistance, System.Action onComplete)
    {
        float elapsedTime = 0f;

        while (elapsedTime < _cameraZoomSpeed)
        {
            float currentDistance = Mathf.Lerp(initialDistance, _mainCamera.transform.position.z, elapsedTime / _cameraZoomSpeed);
            _globalCamera.transform.position = new Vector3(targetPosition.x, targetPosition.y, currentDistance);
            _globalCamera.transform.LookAt(targetPosition);
            elapsedTime += Time.deltaTime;
            yield return null;
        }

        _globalCamera.transform.position = new Vector3(targetPosition.x, targetPosition.y, _mainCamera.transform.position.z);
        _globalCamera.transform.LookAt(targetPosition);

        onComplete?.Invoke();
    }

    public void AddNewLevel(GameObject newLevel)
    {
        _levels.Add(newLevel);

        PolygonCollider2D currentLevelCollider = _levels[0].GetComponent<PolygonCollider2D>();
        SpriteRenderer LevelRenderer = newLevel.GetComponent<SpriteRenderer>();

        Vector2[] points = currentLevelCollider.points;
        Bounds bounds = LevelRenderer.bounds;

        var addedPoint = currentLevelCollider.points[0];

        points = AddBoundsToPolygon(points, bounds, addedPoint);
    
        currentLevelCollider.points = points;
        CalculateWorldBounds();
        CalculateCameraBounds();
    }

    private Vector2[] AddBoundsToPolygon(Vector2[] points, Bounds bounds, Vector2 addedPoint)
    {
        List<Vector2> newPoints = new List<Vector2>(points);
        newPoints.Add(new Vector2(bounds.max.x / 2, bounds.min.y / 2));
        newPoints.Add(new Vector2(bounds.max.x / 2, bounds.max.y / 2));
        newPoints.Add(new Vector2(bounds.min.x / 2, bounds.max.y / 2));
        newPoints.Add(new Vector2(bounds.min.x / 2, bounds.min.y / 2));

        newPoints.Add(new Vector2(bounds.max.x / 2, bounds.min.y / 2));

        return newPoints.ToArray();
    }

    private Vector2[] RemoveBoundsToPolygon(Vector2[] points, Bounds bounds, Vector2 removedPoint)
    {
        List<Vector2> newPoints = new List<Vector2>(points);

        newPoints.Remove(new Vector2(bounds.max.x / 2, bounds.min.y / 2));
        newPoints.Remove(new Vector2(bounds.max.x / 2, bounds.max.y / 2));
        newPoints.Remove(new Vector2(bounds.min.x / 2, bounds.max.y / 2));
        newPoints.Remove(new Vector2(bounds.min.x / 2, bounds.min.y / 2));

        newPoints.Remove(new Vector2(bounds.max.x / 2, bounds.min.y / 2));

        return newPoints.ToArray();
    }

    public void RemoveLevel(GameObject level)
    {
        _levels.Remove(level);

        PolygonCollider2D currentLevelCollider = _levels[0].GetComponent<PolygonCollider2D>();
        SpriteRenderer levelRenderer = level.GetComponent<SpriteRenderer>();

        Vector2[] points = currentLevelCollider.points;
        Bounds bounds = levelRenderer.bounds;

        var removedPoint = points[points.Length - 1];

        points = RemoveBoundsToPolygon(points, bounds, removedPoint);

        currentLevelCollider.points = points;
        
        CalculateWorldBounds();
        CalculateCameraBounds();
    }
}
