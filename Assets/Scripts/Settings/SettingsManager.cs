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

    bool wantParallax = true;
    bool wantScreenShake = true;
    bool isMainMenuActive = false;
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
            _landingMenu.SetActive(false);
            _mainMenu.SetActive(true);
            isMainMenuActive = true;
        }
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
            AkSoundEngine.SetRTPCValue("MASTER_Volume_RTPC", _masterVolumeSlider.value);
        }
        else
        {
            PlayerPrefs.SetFloat("MasterVolume", 1f);
            AkSoundEngine.SetRTPCValue("MASTER_Volume_RTPC", 1f);
        }

        if (PlayerPrefs.HasKey("AmbianceVolume"))
        {
            _ambianceVolumeSlider.value = PlayerPrefs.GetFloat("AmbianceVolume");
            AkSoundEngine.SetRTPCValue("AMB_BUS_Volume_RTPC", _ambianceVolumeSlider.value);
        }
        else
        {
            PlayerPrefs.SetFloat("AmbianceVolume", 1f);
            AkSoundEngine.SetRTPCValue("AMB_BUS_Volume_RTPC", 1f);
        }

        if (PlayerPrefs.HasKey("MusicVolume"))
        {
            _musicVolumeSlider.value = PlayerPrefs.GetFloat("MusicVolume");
            AkSoundEngine.SetRTPCValue("MUS_BUS_Volume_RTPC", _musicVolumeSlider.value);
        }
        else
        {
            PlayerPrefs.SetFloat("MusicVolume", 1f);
            AkSoundEngine.SetRTPCValue("MUS_BUS_Volume_RTPC", 1f);
        }

        if (PlayerPrefs.HasKey("SFXVolume"))
        {
            _sfxVolumeSlider.value = PlayerPrefs.GetFloat("SFXVolume");
            AkSoundEngine.SetRTPCValue("SFX_BUS_Volume_RTPC", _sfxVolumeSlider.value);
        }
        else
        {
            PlayerPrefs.SetFloat("SFXVolume", 1f);
            AkSoundEngine.SetRTPCValue("SFX_BUS_Volume_RTPC", 1f);
        }

        if (PlayerPrefs.HasKey("UIVolume"))
        {
            _uiVolumeSlider.value = PlayerPrefs.GetFloat("UIVolume");
            AkSoundEngine.SetRTPCValue("UI_BUS_Volume_RTPC", _uiVolumeSlider.value);
        }
        else
        {
            PlayerPrefs.SetFloat("UIVolume", 1f);
            AkSoundEngine.SetRTPCValue("UI_BUS_Volume_RTPC", 1f);
        }
    }

    public void ChangeMasterVolume()
    {
        float volume = _masterVolumeSlider.value;
        AkSoundEngine.SetRTPCValue("MASTER_Volume_RTPC",volume);
        PlayerPrefs.SetFloat("MasterVolume", volume);
        PlayerPrefs.Save();
    }
    public void ChangeAmbianceVolume()
    {
        float volume = _ambianceVolumeSlider.value;
        AkSoundEngine.SetRTPCValue("AMB_BUS_Volume_RTPC", volume);
        PlayerPrefs.SetFloat("AmbianceVolume", volume);
        PlayerPrefs.Save();
    }
    public void ChangeMusicVolume()
    {
        float volume = _musicVolumeSlider.value;
        AkSoundEngine.SetRTPCValue("MUS_BUS_Volume_RTPC", volume);
        PlayerPrefs.SetFloat("MusicVolume", volume);
        PlayerPrefs.Save();
    }
    public void ChangeSFXVolume()
    {
        float volume = _sfxVolumeSlider.value;
        AkSoundEngine.SetRTPCValue("SFX_BUS_Volume_RTPC", volume);
        PlayerPrefs.SetFloat("SFXVolume", volume);
        PlayerPrefs.Save();
    }
    public void ChangeUIVolume()
    {
        float volume = _uiVolumeSlider.value;
        AkSoundEngine.SetRTPCValue("UI_BUS_Volume_RTPC", volume);
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
