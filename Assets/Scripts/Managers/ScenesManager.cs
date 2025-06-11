using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;
using Wwise;

public class ScenesManager : MonoBehaviour
{
    public static ScenesManager instance = null;
    [SerializeField] private string _nextScene;
    [SerializeField] private string currentScene;
    [SerializeField] private string _menuScene;

    private void Awake()
    {
        instance = this;
        SceneManager.sceneLoaded += OnSceneLoaded;
    }

    private void OnDestroy()
    {
        SceneManager.sceneLoaded -= OnSceneLoaded;
    }

    private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        SceneManager.SetActiveScene(SceneManager.GetSceneByName(currentScene));
    }

    private void Update()
    {
        if (InputsManager.instance == null) return;
    }

    public void LoadMenu()
    {
        SceneManager.LoadSceneAsync(_menuScene, LoadSceneMode.Additive);
        SceneManager.UnloadSceneAsync(SceneManager.GetActiveScene().name);
    }

    public void LoadNextScene()
    {
        if (InputsManager.instance != null)
        {
            StartCoroutine(LoadingNext());
        }
    }

    public void ReloadScene()
    {
        InputsManager.instance.InputRestarting = false;
        SceneManager.LoadSceneAsync(SceneManager.GetActiveScene().name);
        StartCoroutine(ReLoading());
    }

    IEnumerator LoadingNext()
    {
        MusicScenePermanent.instance.ChangeMusic();
        SettingsManager.Instance.IsMainMenuActive = false;
        yield return new WaitForSeconds(1);
        SceneManager.UnloadSceneAsync(currentScene);
        SceneManager.LoadSceneAsync(_nextScene, LoadSceneMode.Additive);
        yield return null;
    }

    IEnumerator ReLoading()
    {
        yield return new WaitForSeconds(1);
        SceneManager.LoadSceneAsync(currentScene, LoadSceneMode.Additive);
        yield return null;
    }

    public void LoadScene(string SceneName)
    {
        SceneManager.LoadScene(SceneName);
    }
}
