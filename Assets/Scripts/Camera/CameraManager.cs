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
    [SerializeField] private GameObject _compositeParent;
    private List<CinemachineVirtualCamera> _allCameras = new List<CinemachineVirtualCamera>();

    private Bounds _cameraBounds;
    private Camera _globalCamera;

    public float _cameraZoomSpeed = 1f;
    public float _cameraMoveSpeed = 1f;

    private Coroutine _zoomCoroutine;
    private Coroutine _dezoomCoroutine;

    public CinemachineVirtualCamera MainCamera { get => _mainCamera; set => _mainCamera = value; }
    public List<CinemachineVirtualCamera> AllCameras { get => _allCameras; set => _allCameras = value; }
    public GameObject CompositeParent { get => _compositeParent; set => _compositeParent = value; }
    public List<GameObject> Levels { get => _levels; set => _levels = value; }

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

    public void DefineCameraBounds()
    {
        _mainCamera.GetComponent<CinemachineConfiner>().InvalidatePathCache();
    }

    public void AddNewLevel(GameObject newLevel)
    {
        _levels.Add(newLevel);
        CalculateWorldBounds();
        DefineCameraBounds();
        CalculateCameraBounds();
    }

    public void RemoveLevel(GameObject level)
    {
        _levels.Remove(level);
        DefineCameraBounds();
        CalculateWorldBounds();
        CalculateCameraBounds();
    }
}
