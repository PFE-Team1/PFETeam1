using System.Collections;
using System.Linq;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;

public class SettingsManager : MonoBehaviour
{
    public static SettingsManager Instance { get; private set; }
    
    [SerializeField] private GameObject _settingsMenu;
    [SerializeField] private GameObject _pauseMenu;

    [SerializeField] private GameObject _settingsCanva;
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

    [Header("FirstController")]
    [SerializeField] private GameObject _firstPauseItem;

    [Header("Volume")]
    [SerializeField] private AK.Wwise.RTPC _masterVolumeRTPC;
    [SerializeField] private AK.Wwise.RTPC _ambianceVolumeRTPC;
    [SerializeField] private AK.Wwise.RTPC _musicVolumeRTPC;
    [SerializeField] private AK.Wwise.RTPC _sfxVolumeRTPC;
    [SerializeField] private AK.Wwise.RTPC _uiVolumeRTPC;

    [Header("Events")]
    [SerializeField] private AK.Wwise.Event _pauseEvent;
    [SerializeField] private AK.Wwise.Event _unpauseEvent;

    public bool wantParallax = true;
    public bool wantScreenShake = true;
    bool isMainMenuActive = true;
    bool isInPause = false;
    bool didOnce;
    bool hasAldreadyAMusic = false;
    Coroutine _zoomCoroutine;
    public bool IsMainMenuActive { get => isMainMenuActive; set => isMainMenuActive = value; }
    public bool IsInPause { get => isInPause; set => isInPause = value; }
    public bool DidOnce { get => didOnce; set => didOnce = value; }
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
        
        _unpauseEvent.Post(gameObject);
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.K))
        {
            ScenesManager.instance.LoadNextScene();
        }
        if (didOnce) return;
        if (!SplashScreen.isFinished) return;
        if ((Gamepad.current != null && Gamepad.current.allControls.Any(control => control.IsPressed())) || Input.anyKeyDown)
        {
            didOnce = true;
            AudioManager.Instance.SUI_PressAnyKey.Post(gameObject);
            if (_zoomCoroutine != null) return;
            MainMenuManager.Instance.MainMenu.SetActive(true);
            _zoomCoroutine = StartCoroutine(UIZoom(() =>
            {
                _zoomCoroutine = null;
            }));
        }
    }

    IEnumerator UIZoom(System.Action onComplete)
    {
        yield return StartCoroutine(MainMenuManager.Instance.DisplayAnimations(() =>
        {
            EventSystem.current.SetSelectedGameObject(MainMenuManager.Instance.FirstItem);
        }));
        yield return new WaitForSeconds(2f);
        if (!hasAldreadyAMusic) { MusicScenePermanent.instance.StartFirstMusic(); hasAldreadyAMusic = true; }
        onComplete?.Invoke();
    }

    public void SetControls()
    {
        var actions = InputsManager.instance._playerInputs;

        foreach (Transform child in _controlsParent)
        {
            Destroy(child.gameObject);
        }

        foreach (var action in actions.actions.Where(a => a.bindings.Any(b => b.groups.Contains(actions.currentControlScheme))))
        {
            if (action.bindings.Count > 0)
            {
                GameObject control = Instantiate(_controlsPrefab, _controlsParent);
                control.GetComponentInChildren<TextUpdater>().Key = action.name;
                control.GetComponentInChildren<TextMeshProUGUI>().text = action.name;
                control.GetComponentsInChildren<TextMeshProUGUI>()[1].text = action.bindings.First(b => b.groups.Contains(actions.currentControlScheme)).ToDisplayString();
                control.GetComponentInChildren<Button>().onClick.AddListener(() =>
                {
                    action.PerformInteractiveRebinding()
                    .WithControlsExcluding("<Mouse>/position")
                    .WithCancelingThrough("<Keyboard>/escape")
                    .WithCancelingThrough("<Gamepad>/buttonEast")
                    .OnComplete(operation => { operation.Dispose(); SetNewControls(); })
                    .Start();
                });
                control.GetComponentInChildren<TextUpdater>().UpdateText();
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
        if (!isMainMenuActive)
        {
            _pauseMenu.SetActive(!_pauseMenu.activeSelf);
            _settingsMenu.SetActive(false);
            EventSystem.current.SetSelectedGameObject(_firstPauseItem);
            isInPause = _pauseMenu.activeSelf;
            if (isInPause) _pauseEvent.Post(gameObject);
            else _unpauseEvent.Post(gameObject);
        }
    }

    public void SetNewEvent()
    {
        if (isInPause)
        {
            EventSystem.current.SetSelectedGameObject(_firstPauseItem);
        }
        else 
        {
            EventSystem.current.SetSelectedGameObject(MainMenuManager.Instance?.FirstItem);
        }
    }

    public void OpenSettings()
    {
        _settingsMenu.SetActive(!_settingsMenu.activeSelf);
    }

    public void QuitGame()
    {
        Application.Quit();
    }
}
