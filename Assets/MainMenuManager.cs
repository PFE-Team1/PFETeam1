using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainMenuManager : MonoBehaviour
{
    public static MainMenuManager Instance { get; private set; }
    
    [SerializeField] private GameObject _landingMenu;
    [SerializeField] private GameObject _mainMenu;
    public GameObject LandingMenu => _landingMenu;
    public GameObject MainMenu { get => _mainMenu; }

    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
        }
        else
        {
            Destroy(gameObject);
        }
    }
    void Start()
    {
        _mainMenu.SetActive(false);
        SettingsManager.Instance.IsMainMenuActive = true;
        _landingMenu.SetActive(true);
    }
}
