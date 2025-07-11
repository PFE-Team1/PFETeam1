using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using Unity.VisualScripting;
using DG.Tweening;

public class CameraManager : MonoBehaviour
{
    public static CameraManager Instance { get; private set; }
    [SerializeField] private List<GameObject> _levels;
    [SerializeField] private CinemachineVirtualCamera _mainCamera;
    [SerializeField] private GameObject _compositeParent;
    [SerializeField] private float _cameraZoomTime;
    [SerializeField] private float _cameraDezoomTime;
    [SerializeField] private float duration = 5f;
    [SerializeField] private Ease _cameraDezoomEase = Ease.OutBack;
    [SerializeField] private Ease _cameraZoomEase = Ease.OutBack;
    private PaintInOutController _paintInOutController;
    private Bounds _cameraBounds;
    CinemachineVirtualCamera _globalCamera;

    float initOrthoSize;
    Transform _playerTransform;

    private Coroutine _zoomCoroutine;
    private Coroutine _dezoomCoroutine;

    public CinemachineVirtualCamera MainCamera { get => _mainCamera; set => _mainCamera = value; }
    public GameObject CompositeParent { get => _compositeParent; set => _compositeParent = value; }
    public List<GameObject> Levels { get => _levels; set => _levels = value; }
    public float CameraDezoomTime { get => _cameraDezoomTime; }
    public Transform PlayerTransform
    {
        get => _playerTransform;
        set
        {
            _playerTransform = value;
            MainCamera.Follow = _playerTransform;
        }
    }


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
        _paintInOutController = FindObjectOfType<PaintInOutController>();
    }

    void Start()
    {
        if (FindAnyObjectByType<SpawnManager>() != null) PlayerTransform = FindAnyObjectByType<SpawnManager>().transform;
        initOrthoSize = _mainCamera.m_Lens.OrthographicSize;
        CalculateCameraBounds();
        DefineCameraBounds();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F1))
        {
            // AudioManager.Instance.SFX_Dezoom.Post(gameObject);
            //SeeAllLevels();
        }

        if (Input.GetKeyDown(KeyCode.F2))
        {
            // AudioManager.Instance.SFX_Zoom.Post(gameObject);
            //FocusCamera();
        }

        if (Input.GetKeyDown(KeyCode.F3))
        {
            // SeeCurrentLevel(_levels[0]);
        }

        if (Input.GetKeyDown(KeyCode.F4))
        {
            // CameraShake(0.5f, 1f);
        }
    }

    private void CalculateWorldBounds()
    {
        if (_levels.Count - 1 == 0) return;

        if (_levels[0] == null) return;

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

    public void SeeCurrentLevel(GameObject level, float duration = 0)
    {
        if (_globalCamera != null) return;
        if (_zoomCoroutine != null || _dezoomCoroutine != null) return;

        _globalCamera = new GameObject("Global Camera").AddComponent<CinemachineVirtualCamera>();

        /*  if (level.TryGetComponent(out SpriteRenderer sr))
          {
              _globalCamera.m_Lens.Orthographic = true;
              if (sr.bounds.size.y < sr.bounds.size.x)
              {
                  _globalCamera.m_Lens.OrthographicSize = sr.bounds.size.y / 2;
              }
              else
              {
                  _globalCamera.m_Lens.OrthographicSize = sr.bounds.size.x / 2;
              }
              _globalCamera.transform.position = new Vector3(sr.bounds.center.x, sr.bounds.center.y, _mainCamera.transform.position.z);
          }*/
        if (level.TryGetComponent(out RectTransform rt))
        {
            _globalCamera.m_Lens.Orthographic = true;
            if (rt.sizeDelta.y > rt.sizeDelta.x)
            {
                _globalCamera.m_Lens.OrthographicSize = rt.sizeDelta.y / 2.5f;
            }
            else
            {
                _globalCamera.m_Lens.OrthographicSize = rt.sizeDelta.x / 3;
            }
            _globalCamera.transform.position = new Vector3(level.transform.position.x, level.transform.position.y, _mainCamera.transform.position.z);
        }
        _dezoomCoroutine = StartCoroutine(DezoomEffect(_globalCamera.transform.position, _globalCamera.m_Lens.OrthographicSize, () =>
        {
            _dezoomCoroutine = null;
        }, duration));
    }

    public void SeeAllLevels()
    {
        if (_globalCamera != null) return;
        if (_zoomCoroutine != null || _dezoomCoroutine != null) return;

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

        _dezoomCoroutine = StartCoroutine(DezoomEffect(
            _globalCamera.transform.position,
            _globalCamera.m_Lens.OrthographicSize,
            () =>
            {
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

    private IEnumerator DezoomEffect(Vector3 targetPosition, float targetOrthoSize, System.Action onComplete, float duration = 0)
    {
        float elapsedTime = 0f;
        if (duration == 0)
        {
            duration = _cameraDezoomTime;
        }
        Vector3 startPosition = _mainCamera.transform.position;
        float startOrthoSize = _mainCamera.m_Lens.OrthographicSize;

        float decrease = targetOrthoSize - startOrthoSize;

        //_cameraDezoomTime = Mathf.Abs(decrease) / _cameraDezoomTime;

        while (elapsedTime < duration)
        {
            float t = DOVirtual.EasedValue(0f, 1f, elapsedTime / duration, _cameraDezoomEase);

            _mainCamera.transform.position = Vector3.Lerp(startPosition, new Vector3(targetPosition.x, targetPosition.y, startPosition.z), t);
            _mainCamera.m_Lens.OrthographicSize = Mathf.Lerp(startOrthoSize, targetOrthoSize, t);

            elapsedTime += Time.deltaTime;
            yield return null;
        }

        _mainCamera.transform.position = new Vector3(targetPosition.x, targetPosition.y, startPosition.z);
        _mainCamera.m_Lens.OrthographicSize = targetOrthoSize;
        onComplete?.Invoke();
    }


    public void ShowNewLevel()
    {
        //StartCoroutine(ShowAndHideLevel()); mesure temporaire
    }

    IEnumerator ShowAndHideLevel()
    {
        SeeAllLevels();
        yield return new WaitForSeconds(duration);
        FocusCamera();
    }

    public void CameraShake(float time, float intensity)
    {
        if (SettingsManager.Instance?.WantScreenShake == false) return;
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
        _mainCamera.Follow = null;
        if (_globalCamera != null && _playerTransform != null)
        {
            if (_zoomCoroutine != null || _dezoomCoroutine != null) return;
            _zoomCoroutine = StartCoroutine(ZoomEffect(() =>
            {
                _zoomCoroutine = null;
                _mainCamera.Follow = _playerTransform;
            }));
        }
    }

    private IEnumerator ZoomEffect(System.Action onComplete)
    {
        float elapsedTime = 0f;

        Vector3 startPosition = _globalCamera.transform.position;
        float startOrthoSize = _globalCamera.m_Lens.OrthographicSize;

        _mainCamera.transform.position = startPosition;

        Vector3 targetPosition = _playerTransform.position;
        float targetOrthoSize = initOrthoSize;

        Destroy(_globalCamera.gameObject);
        _globalCamera = null;

        while (elapsedTime < _cameraZoomTime)
        {
            float normalizedTime = elapsedTime / _cameraZoomTime;
            
            _mainCamera.transform.position = Vector3.Lerp(startPosition, new Vector3(targetPosition.x, targetPosition.y, startPosition.z), normalizedTime);
            _mainCamera.m_Lens.OrthographicSize = Mathf.Lerp(startOrthoSize, targetOrthoSize, normalizedTime);

            elapsedTime += Time.deltaTime;
            yield return null;
        }

        _mainCamera.transform.position = new Vector3(targetPosition.x, targetPosition.y, startPosition.z);
        _mainCamera.m_Lens.OrthographicSize = targetOrthoSize;
        onComplete?.Invoke();
    }


    public void DefineCameraBounds()
    {
        CinemachineConfiner confiner = _mainCamera.GetComponent<CinemachineConfiner>();
        if (!confiner)
        {
            return;
        }
        confiner.InvalidatePathCache();

    }

    public void AddNewLevel(GameObject newLevel)
    {
        _levels.Add(newLevel);
    }

    public void SetNewLevel(GameObject newLevel)
    {
        _paintInOutController?.PaintIn(newLevel);
        ReEvaluate();
    }

    public void RemoveLevel(GameObject level)
    {
        // _levels.Remove(level);
        _paintInOutController?.PaintOut(level);
        if (!_paintInOutController)
        {
            level.SetActive(false);
        }
        ReEvaluate();
    }
    public void ReEvaluate()
    {
        CalculateWorldBounds();
        CalculateCameraBounds();
        DefineCameraBounds();
    }

    public void SetFollow(GameObject gameObject)
    {
        if (gameObject != null)
        {
            PlayerTransform = gameObject.transform;
            _mainCamera.Follow = PlayerTransform;
        }
        else
        {
            PlayerTransform = null;
            _mainCamera.Follow = null;
        }
    }

    public CinemachineVirtualCamera GetCurrentCamera()
    {
        return _mainCamera;
    }
}
