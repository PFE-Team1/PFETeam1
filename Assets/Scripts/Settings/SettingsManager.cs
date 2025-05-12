using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;
using UnityEngine.InputSystem;

public class SettingsManager : MonoBehaviour
{
    public static SettingsManager Instance { get; private set; }
    [SerializeField] private GameObject _landingMenu;
    [SerializeField] private GameObject _mainMenu;
    [SerializeField] private GameObject _settingsMenu;
    [SerializeField] private GameObject _pauseMenu;
    [SerializeField] private TMP_Dropdown _resolutionDropDown;
    [SerializeField] private TMP_Dropdown _screenTypeDropDown;
    [SerializeField] private Slider _masterVolumeSlider;
    [SerializeField] private Slider _ambianceVolumeSlider;
    [SerializeField] private Slider _musicVolumeSlider;
    [SerializeField] private Slider _sfxVolumeSlider;
    [SerializeField] private Slider _uiVolumeSlider;

    [Header("Controls")]
    [SerializeField] private GameObject _controlsPrefab;
    [SerializeField] private Transform _controlsParent;

    [Header ("Camera Transition")]
    [SerializeField] private GameObject _objectToZoom;
    [SerializeField] private float _zoomSpeed = 5f;

    [SerializeField] private AK.Wwise.RTPC _masterVolumeRTPC;
    [SerializeField] private AK.Wwise.RTPC _ambianceVolumeRTPC;
    [SerializeField] private AK.Wwise.RTPC _musicVolumeRTPC;
    [SerializeField] private AK.Wwise.RTPC _sfxVolumeRTPC;
    [SerializeField] private AK.Wwise.RTPC _uiVolumeRTPC;

    bool wantParallax = true;
    bool wantScreenShake = true;
    bool isMainMenuActive = false;
    public bool IsMainMenuActive { get => isMainMenuActive; set => isMainMenuActive = value; }
    Resolution[] resolutions;
    public bool WantParallax { get => wantParallax; set => wantParallax = value; }
    public bool WantScreenShake { get => wantScreenShake; set => wantScreenShake = value; }

    void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }
    
    void Start()
    {
        resolutions = Screen.resolutions;

        _resolutionDropDown.ClearOptions();
        List<string> options = new List<string>();

        int currentResolutionIndex = 0;
        for (int i = 0; i < resolutions.Length; i++)
        {
            string option = resolutions[i].width + " x " + resolutions[i].height;
            options.Add(option);

            if (resolutions[i].width == Screen.currentResolution.width &&
                resolutions[i].height == Screen.currentResolution.height)
            {
                currentResolutionIndex = i;
            }
        }

        _resolutionDropDown.AddOptions(options);
        _resolutionDropDown.value = currentResolutionIndex;
        _resolutionDropDown.RefreshShownValue();

        InitVolume();
        SetControls();
    }

    void Update()
    {
        if (Input.anyKeyDown && !isMainMenuActive)
        {
            StartCoroutine(UIZoom(() =>
            {
                _objectToZoom.SetActive(false);
                _landingMenu.SetActive(false);
                _mainMenu.SetActive(true);
                isMainMenuActive = true;
            }));
            isMainMenuActive = true;
        }
    }

    IEnumerator UIZoom(System.Action onComplete)
    {
        _objectToZoom.GetComponent<Image>().enabled = true;
        float timer = 0f;
        Vector2 startSize = _objectToZoom.GetComponent<RectTransform>().sizeDelta;
        Vector2 targetSize = new Vector2(Screen.width, Screen.height);
        while (timer < _zoomSpeed)
        {
            timer += Time.deltaTime;
            RectTransform rectTransform = _objectToZoom.GetComponent<RectTransform>();
            rectTransform.sizeDelta = Vector2.Lerp(startSize, targetSize, timer / _zoomSpeed);
            rectTransform.position = Vector2.Lerp(rectTransform.position, new Vector2(Screen.width / 2, Screen.height / 2), timer / _zoomSpeed);
            yield return null;
        }
        onComplete?.Invoke();
    }

    public void SetControls()
    {
        var actions = InputsManager.instance._playerInputs;

        foreach (var action in actions.actions)
        {
            if (action.bindings.Count > 0)
            {
                GameObject control = Instantiate(_controlsPrefab, _controlsParent);
                control.GetComponent<TextUpdater>().Key = action.name;
                control.GetComponent<TextMeshProUGUI>().text = action.name;
                control.GetComponentsInChildren<TextMeshProUGUI>()[1].text = action.bindings[0].ToDisplayString();
                control.GetComponent<Button>().onClick.AddListener(() =>
                {
                    Debug.Log($"{action.name} clicked !");
                    action.PerformInteractiveRebinding()
                        .WithControlsExcluding("<Mouse>/position")
                        .WithCancelingThrough("<Keyboard>/escape")
                        .OnComplete(operation => { operation.Dispose(); SetNewControls(); })
                        .Start();
                });
                control.GetComponent<TextUpdater>().UpdateText();
            }
        }
    }

    public void SetNewControls()
    {
        Debug.Log($"New controls set !");
    }

    public void SetResolution()
    {
        int resolutionIndex = _resolutionDropDown.value;
        Resolution resolution = resolutions[resolutionIndex];
        Screen.SetResolution(resolution.width, resolution.height, Screen.fullScreenMode);
    }

    public void SetScreenType()
    {
        int screenTypes = _screenTypeDropDown.value;
        
        switch (screenTypes)
        {
            case 0:
                Screen.fullScreenMode = FullScreenMode.Windowed;
                break;
            case 1:
                Screen.fullScreenMode = FullScreenMode.FullScreenWindow;
                break;
            case 2:
                Screen.fullScreenMode = FullScreenMode.ExclusiveFullScreen;
                break;
        }
    }

    public void InitVolume()
    {
        if (PlayerPrefs.HasKey("MasterVolume"))
        {
            _masterVolumeSlider.value = PlayerPrefs.GetFloat("MasterVolume");
            _masterVolumeRTPC.SetGlobalValue(_masterVolumeSlider.value);
        }
        else
        {
            PlayerPrefs.SetFloat("MasterVolume", 1f);
            _masterVolumeRTPC.SetGlobalValue(1f);
        }

        if (PlayerPrefs.HasKey("AmbianceVolume"))
        {
            _ambianceVolumeSlider.value = PlayerPrefs.GetFloat("AmbianceVolume");
            _ambianceVolumeRTPC.SetGlobalValue(_ambianceVolumeSlider.value);
        }
        else
        {
            PlayerPrefs.SetFloat("AmbianceVolume", 1f);
            _ambianceVolumeRTPC.SetGlobalValue(1f);
        }

        if (PlayerPrefs.HasKey("MusicVolume"))
        {
            _musicVolumeSlider.value = PlayerPrefs.GetFloat("MusicVolume");
            _musicVolumeRTPC.SetGlobalValue(_musicVolumeSlider.value);
        }
        else
        {
            PlayerPrefs.SetFloat("MusicVolume", 1f);
            _musicVolumeRTPC.SetGlobalValue(1f);
        }

        if (PlayerPrefs.HasKey("SFXVolume"))
        {
            _sfxVolumeSlider.value = PlayerPrefs.GetFloat("SFXVolume");
            _sfxVolumeRTPC.SetGlobalValue(_sfxVolumeSlider.value);
        }
        else
        {
            PlayerPrefs.SetFloat("SFXVolume", 1f);
            _sfxVolumeRTPC.SetGlobalValue(1f);
        }

        if (PlayerPrefs.HasKey("UIVolume"))
        {
            _uiVolumeSlider.value = PlayerPrefs.GetFloat("UIVolume");
            _uiVolumeRTPC.SetGlobalValue(_uiVolumeSlider.value);
        }
        else
        {
            PlayerPrefs.SetFloat("UIVolume", 1f);
            _uiVolumeRTPC.SetGlobalValue(1f);
        }
    }

    public void ChangeMasterVolume()
    {
        float volume = _masterVolumeSlider.value;
        _masterVolumeRTPC.SetGlobalValue(volume);
        PlayerPrefs.SetFloat("MasterVolume", volume);
        PlayerPrefs.Save();
    }
    public void ChangeAmbianceVolume()
    {
        float volume = _ambianceVolumeSlider.value;
        _ambianceVolumeRTPC.SetGlobalValue(volume);
        PlayerPrefs.SetFloat("AmbianceVolume", volume);
        PlayerPrefs.Save();
    }
    public void ChangeMusicVolume()
    {
        float volume = _musicVolumeSlider.value;
        _musicVolumeRTPC.SetGlobalValue(volume);
        PlayerPrefs.SetFloat("MusicVolume", volume);
        PlayerPrefs.Save();
    }
    public void ChangeSFXVolume()
    {
        float volume = _sfxVolumeSlider.value;
        _sfxVolumeRTPC.SetGlobalValue(volume);
        PlayerPrefs.SetFloat("SFXVolume", volume);
        PlayerPrefs.Save();
    }
    public void ChangeUIVolume()
    {
        float volume = _uiVolumeSlider.value;
        _uiVolumeRTPC.SetGlobalValue(volume);
        PlayerPrefs.SetFloat("UIVolume", volume);
        PlayerPrefs.Save();
    }

    public void RestartGame()
    {
        DisplayPauseMenu();
        ScenesManager.instance.ReloadScene();
    }

    public void DisplayPauseMenu()
    {
        _pauseMenu.SetActive(!_pauseMenu.activeSelf);
    }

    public void SetParallax()
    {
        wantParallax = !wantParallax;
    }

    public void SetScreenShake()
    {
        wantScreenShake = !wantScreenShake;
    }

    public void QuitGame()
    {
        Application.Quit();
    }
}
