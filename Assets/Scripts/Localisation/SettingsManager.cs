using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using AK.Wwise;
using UnityEngine.UI;

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

    public void ChangeMasterVolume()
    {
        AkSoundEngine.SetRTPCValue("MASTER_Volume_RTPC", _masterVolumeSlider.value);
    }
    public void ChangeAmbianceVolume()
    {
        AkSoundEngine.SetRTPCValue("AMB_BUS_Volume_RTPC", _ambianceVolumeSlider.value);
    }
    public void ChangeMusicVolume()
    {
        AkSoundEngine.SetRTPCValue("MUS_BUS_Volume_RTPC", _musicVolumeSlider.value);
    }
    public void ChangeSFXVolume()
    {
        AkSoundEngine.SetRTPCValue("SFX_BUS_Volume_RTPC", _sfxVolumeSlider.value);
    }
    public void ChangeUIVolume()
    {
        AkSoundEngine.SetRTPCValue("UI_BUS_Volume_RTPC", _uiVolumeSlider.value);
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
