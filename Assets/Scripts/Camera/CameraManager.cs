using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using Unity.VisualScripting;
using UnityEngine.Events;

public class CameraManager : MonoBehaviour
{
    public static CameraManager Instance { get; private set; }
    [SerializeField] private List<GameObject> _levels; 
    [SerializeField] private CinemachineVirtualCamera _mainCamera;
    [SerializeField] private GameObject _compositeParent;
    private List<CinemachineVirtualCamera> _allCameras = new List<CinemachineVirtualCamera>();
    [SerializeField] private UnityEvent SFX_Dezoom;
    [SerializeField] private UnityEvent SFX_Zoom;

    private Bounds _cameraBounds;
    public CinemachineVirtualCamera _globalCamera;

    public float _cameraZoomSpeed = 1f;
    public float _cameraMoveSpeed = 1f;

    float initOrthoSize;
    Transform _playerTransform;

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
        _playerTransform = _mainCamera.transform;
        initOrthoSize = _mainCamera.m_Lens.OrthographicSize;
        CalculateCameraBounds();
        _mainCamera.GetComponent<CinemachineConfiner>().InvalidatePathCache();
        _allCameras.AddRange(_mainCamera.GetComponentsInChildren<CinemachineVirtualCamera>());
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F1))
        {
            SFX_Dezoom.Invoke();
            SeeAllLevels();
        }

        if (Input.GetKeyDown(KeyCode.F2))
        {
            SFX_Zoom.Invoke();
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
        _globalCamera = new GameObject("Global Camera").AddComponent<CinemachineVirtualCamera>();
        
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

        _globalCamera.m_Lens.Orthographic = true;
        _globalCamera.m_Lens.OrthographicSize = Mathf.Max(worldWidth / (2 * _mainCamera.m_Lens.Aspect), worldHeight / 2);

        _globalCamera.transform.position = new Vector3(combinedBounds.center.x, combinedBounds.center.y, _mainCamera.transform.position.z);

        if (_zoomCoroutine != null) return;
        _dezoomCoroutine = StartCoroutine(DezoomEffect(combinedBounds.center, _globalCamera.m_Lens.OrthographicSize, () =>
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
            elapsedTime += Time.deltaTime;
            yield return null;
        }

        _globalCamera.transform.position = new Vector3(targetPosition.x, targetPosition.y, _mainCamera.transform.position.z);
        onComplete?.Invoke(); 
    }

    public void ShowNewLevel()
    {
        StartCoroutine(ShowAndHideLevel());
    }

    IEnumerator ShowAndHideLevel()
    {
        SeeAllLevels();
        yield return new WaitForSeconds(2f);
        FocusCamera();
    }

    public void CameraShake(float time, float intensity)
    {   
        _mainCamera.GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>().m_AmplitudeGain = intensity;
        StartCoroutine(StopShake(time));
    }

    IEnumerator StopShake(float time)
    {
        yield return new WaitForSeconds(time);
        _mainCamera.GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>().m_AmplitudeGain = 0f;
    }

    public void FocusCamera()
    {
        if (_globalCamera != null)
        {
            if (_dezoomCoroutine != null) return;
            
            _zoomCoroutine = StartCoroutine(ZoomEffect(() =>
            {
                _zoomCoroutine = null;
            }));
        }
    }

    private IEnumerator ZoomEffect(System.Action onComplete)
    {
        float elapsedTime = 0f;
        _mainCamera.m_Lens.OrthographicSize = _globalCamera.m_Lens.OrthographicSize;
        _mainCamera.transform.position = _globalCamera.transform.position;

        yield return new WaitForSeconds(0.1f);
        Destroy(_globalCamera.gameObject);
        _globalCamera = null;

        while (elapsedTime < _cameraZoomSpeed)
        {
            _mainCamera.m_Lens.OrthographicSize = Mathf.Lerp(_mainCamera.m_Lens.OrthographicSize, initOrthoSize, elapsedTime / _cameraZoomSpeed);
            _mainCamera.transform.position = Vector3.Lerp(_mainCamera.transform.position, _playerTransform.position, elapsedTime / _cameraZoomSpeed);
            elapsedTime += Time.deltaTime;
            yield return null;
        }
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
       // _levels.Remove(level);
        DefineCameraBounds();
        CalculateWorldBounds();
        CalculateCameraBounds();
    }
}
