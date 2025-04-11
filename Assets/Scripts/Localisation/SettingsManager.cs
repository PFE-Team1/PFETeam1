using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class SettingsManager : MonoBehaviour
{
    [SerializeField] private GameObject _landingMenu;
    [SerializeField] private GameObject _mainMenu;
    [SerializeField] private GameObject _settingsMenu;
    [SerializeField] private TMP_Dropdown resolutionDropDown;
    [SerializeField] private TMP_Dropdown screenTypeDropDown;
    bool isMainMenuActive = false;
    Resolution[] resolutions;
    
    
    void Start()
    {
        resolutions = Screen.resolutions;

        resolutionDropDown.ClearOptions();
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

        resolutionDropDown.AddOptions(options);
        resolutionDropDown.value = currentResolutionIndex;
        resolutionDropDown.RefreshShownValue();
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
        int resolutionIndex = resolutionDropDown.value;
        Resolution resolution = resolutions[resolutionIndex];
        Screen.SetResolution(resolution.width, resolution.height, Screen.fullScreenMode);
    }

    public void SetScreenType()
    {
        int screenTypes = screenTypeDropDown.value;
        
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

    public void QuitGame()
    {
        Application.Quit();
    }
}
