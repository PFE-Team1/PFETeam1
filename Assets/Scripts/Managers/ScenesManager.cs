using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ScenesManager : MonoBehaviour
{
    public static ScenesManager  instance = null;
    [SerializeField]private string _nextScene;
    [SerializeField]private string _menuScene;
    private void Awake()
    {
        instance = this;
    }
    private void Update()
    {
        if (InputsManager.instance == null) return;
    }
    public void LoadMenu()
    {
        SceneManager.LoadScene(_menuScene);
        
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
        SettingsManager.Instance.IsMainMenuActive = false;
    }
    IEnumerator LoadingNext()
    {
        yield return new WaitForSeconds(1);//dur e de l'anim
        SceneManager.LoadScene(_nextScene);
        yield return null;
    }
    IEnumerator ReLoading()
    {
        yield return new WaitForSeconds(1);//dur e de l'anim
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
        yield return null;
    }

    public void LoadScene(string sceneName)
    {
        SceneManager.LoadScene(sceneName);
    }
}
