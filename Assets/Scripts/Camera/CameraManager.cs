using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using Unity.VisualScripting;
using UnityEngine.Events;
using DG.Tweening.Core.Easing;
using DG.Tweening;

public class CameraManager : MonoBehaviour
{
    public static CameraManager Instance { get; private set; }
    [SerializeField] private List<GameObject> _levels; 
    [SerializeField] private CinemachineVirtualCamera _mainCamera;
    [SerializeField] private GameObject _compositeParent;
    [SerializeField] private float _cameraZoomTime;
    [SerializeField] private float _cameraDezoomTime;
    private Bounds _cameraBounds;
    CinemachineVirtualCamera _globalCamera;

    float initOrthoSize;
    Transform _playerTransform;

    private Coroutine _zoomCoroutine;
    private Coroutine _dezoomCoroutine;

    public CinemachineVirtualCamera MainCamera { get => _mainCamera; set => _mainCamera = value; }
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
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F1))
        {
            AudioManager.Instance.SFX_Dezoom.Post(gameObject);
            SeeAllLevels();
        }

        if (Input.GetKeyDown(KeyCode.F2))
        {
            AudioManager.Instance.SFX_Zoom.Post(gameObject);
            FocusCamera();
        }

        if (Input.GetKeyDown(KeyCode.F3))
        {
            SeeCurrentLevel(_levels[0]);
        }

        if (Input.GetKeyDown(KeyCode.F4))
        {
            CameraShake(0.5f, 1f);
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

    public void SeeCurrentLevel(GameObject level)
    {
        if (_globalCamera != null) return;
        _globalCamera = new GameObject("Global Camera").AddComponent<CinemachineVirtualCamera>();
        
        if (level.TryGetComponent(out SpriteRenderer sr))
        {
            _globalCamera.m_Lens.Orthographic = true;
            _globalCamera.m_Lens.OrthographicSize = sr.bounds.size.y / 2;
            _globalCamera.transform.position = new Vector3(sr.bounds.center.x, sr.bounds.center.y, _mainCamera.transform.position.z);
        }

        if (_zoomCoroutine != null) return;
        _dezoomCoroutine = StartCoroutine(DezoomEffect(_globalCamera.transform.position, _globalCamera.m_Lens.OrthographicSize, () =>
        {
            _dezoomCoroutine = null;
        }));
    }

    public void SeeAllLevels()
    {
        if (_globalCamera != null) return;

        Bounds combinedBounds = new Bounds();
        bool hasBounds = false;

        foreach (var level in _levels)
        {
            if (level.activeInHierarchy && level.TryGetComponent(out SpriteRenderer sr))
            {
                if (!hasBounds)
                {
                    combinedBounds = sr.bounds;
                    hasBounds = true;
                }
                else
                {
                    combinedBounds.Encapsulate(sr.bounds);
                }
            }
        }

        if (!hasBounds) return;

        GameObject globalCamObj = new GameObject("Global Camera");
        _globalCamera = globalCamObj.AddComponent<CinemachineVirtualCamera>();

        _globalCamera.m_Lens = _mainCamera.m_Lens;
        _globalCamera.Priority = _mainCamera.Priority - 1;

        CopyCinemachineComponents(_mainCamera, _globalCamera);

        _globalCamera.m_Lens.Orthographic = true;
        _globalCamera.m_Lens.OrthographicSize = Mathf.Max(
            combinedBounds.size.x / (2f * _mainCamera.m_Lens.Aspect),
            combinedBounds.size.y / 2f
        );

        _globalCamera.transform.position = new Vector3(
            combinedBounds.center.x,
            combinedBounds.center.y,
            _mainCamera.transform.position.z
        );

        if (_zoomCoroutine != null) return;

        _dezoomCoroutine = StartCoroutine(DezoomEffect(
            _globalCamera.transform.position,
            _globalCamera.m_Lens.OrthographicSize,
            () => {
                _dezoomCoroutine = null;
            }
        ));
    }

    private void CopyCinemachineComponents(CinemachineVirtualCamera source, CinemachineVirtualCamera target)
    {
        foreach (var comp in target.GetComponents<CinemachineComponentBase>())
        {
            DestroyImmediate(comp);
        }

        foreach (var sourceComp in source.GetComponents<CinemachineComponentBase>())
        {
            var type = sourceComp.GetType();
            var method = typeof(CinemachineVirtualCamera).GetMethod("AddCinemachineComponent", System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public);
            var genericMethod = method.MakeGenericMethod(type);
            var targetComp = genericMethod.Invoke(target, null) as CinemachineComponentBase;

            foreach (var field in type.GetFields())
            {
                if (field.IsPublic && field.CanWrite())
                {
                    field.SetValue(targetComp, field.GetValue(sourceComp));
                }
            }
        }
    }

    private IEnumerator DezoomEffect(Vector3 targetPosition, float targetOrthoSize, System.Action onComplete)
    {
        float elapsedTime = 0f;

        Vector3 startPosition = _mainCamera.transform.position;
        float startOrthoSize = _mainCamera.m_Lens.OrthographicSize;

        while (elapsedTime < _cameraDezoomTime)
        {
            float t = Mathf.SmoothStep(0f, 1f, Mathf.Clamp01(elapsedTime / _cameraDezoomTime));

            _mainCamera.transform.position = Vector3.Lerp(startPosition, new Vector3(targetPosition.x, targetPosition.y, startPosition.z), t);
            _mainCamera.m_Lens.OrthographicSize = Mathf.Lerp(startOrthoSize, targetOrthoSize, t);

            elapsedTime += Time.deltaTime;
            yield return null;
        }

        _mainCamera.transform.position = new Vector3(targetPosition.x, targetPosition.y, startPosition.z);
        _mainCamera.m_Lens.OrthographicSize = targetOrthoSize;

        Debug.Log("📷 Dezoom terminé. Tous les niveaux sont visibles.");

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

        Vector3 startPosition = _mainCamera.transform.position;
        float startOrthoSize = _mainCamera.m_Lens.OrthographicSize;

        Vector3 targetPosition = _playerTransform.position;
        float targetOrthoSize = initOrthoSize;

        Destroy(_globalCamera.gameObject);
        _globalCamera = null;

        while (elapsedTime < _cameraZoomTime)
        {
            float t = elapsedTime / _cameraZoomTime;

            _mainCamera.transform.position = Vector3.Lerp(startPosition, new Vector3(targetPosition.x, targetPosition.y, startPosition.z), t);
            _mainCamera.m_Lens.OrthographicSize = Mathf.Lerp(startOrthoSize, targetOrthoSize, t);

            elapsedTime += Time.deltaTime;
            yield return null;

            Debug.Log($"Elapsed Time: {elapsedTime}, t: {t}");
        }

        _mainCamera.transform.position = new Vector3(targetPosition.x, targetPosition.y, startPosition.z);
        _mainCamera.m_Lens.OrthographicSize = targetOrthoSize;

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
