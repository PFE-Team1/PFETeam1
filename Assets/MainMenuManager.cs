using System.Collections;
using UnityEngine;
using UnityEngine.UI;
public class MainMenuManager : MonoBehaviour
{
    public static MainMenuManager Instance { get; private set; }

    [SerializeField] private GameObject _landingMenu;
    [SerializeField] private GameObject _mainMenu;
    [SerializeField] private GameObject _firstItem;
    [Header("Animation")]
    [SerializeField] private Animator _firstMenuAnimator;
    [SerializeField] private Animator _secondMenuAnimator;
    [SerializeField] private AnimationClip _firstMenuAnimation;
    [SerializeField] private AnimationClip _secondMenuAnimation;
    [SerializeField] private AnimationClip _zoomForPlayAnimation;
    public GameObject LandingMenu => _landingMenu;
    public GameObject MainMenu { get => _mainMenu; }
    public GameObject FirstItem => _firstItem;
    public Animator FirstMenuAnimator => _firstMenuAnimator;
    public Animator SecondMenuAnimator => _secondMenuAnimator;
    public AnimationClip FirstMenuAnimation => _firstMenuAnimation;
    public AnimationClip SecondMenuAnimation => _secondMenuAnimation;
    public AnimationClip ZoomForPlayAnimation => _zoomForPlayAnimation;

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
        _firstItem.GetComponent<Button>().interactable = true;
    }

    public IEnumerator DisplayAnimations(System.Action onComplete)
    {
        _firstMenuAnimator.Play(_firstMenuAnimation.name);
        _secondMenuAnimator.Play(_secondMenuAnimation.name);
        yield return new WaitForSeconds(_firstMenuAnimation.length);
        onComplete?.Invoke();
    }

    public int GetFirstAnimationLength()
    {
        return (int)_firstMenuAnimation.length;
    }

    public int GetSecondAnimationLength()
    {
        return (int)_secondMenuAnimation.length;
    }

    public void ZoomForPlay()
    {
        SecondMenuAnimator.Play(ZoomForPlayAnimation.name);
        StartCoroutine(WaitForZoomToComplete(() => ScenesManager.instance.LoadNextScene()));
    }

    private IEnumerator WaitForZoomToComplete(System.Action onComplete)
    {
        yield return new WaitForSeconds(GetSecondAnimationLength());
        onComplete?.Invoke();
    }

    public void OpenSettings()
    {
        SettingsManager.Instance?.OpenSettings();
    }

    public void QuitGame()
    {
        Application.Quit();
    }
}
