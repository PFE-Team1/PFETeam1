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
        else if (Instance != this)
        {
            Destroy(gameObject);
            return;
        }
    }

    private void Start()
    {
        Initialize();
    }

    public void Initialize()
    {
        _mainMenu.SetActive(false);
        SettingsManager.Instance.IsMainMenuActive = true;
        SettingsManager.Instance.DidOnce = false;
        _landingMenu.SetActive(true);
    }
}
