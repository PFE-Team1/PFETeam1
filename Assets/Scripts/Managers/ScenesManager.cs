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
        SceneManager.LoadSceneAsync(_menuScene);
        
    }
    public void LoadNextScene()
    {
        SceneManager.LoadSceneAsync(_nextScene);
        if (InputsManager.instance != null)
        {
            if (InputsManager.instance.InputRestarting)
            {
                InputsManager.instance.InputRestarting = false;
                StartCoroutine(Deload());
            }
        }
    }

    public void ReloadScene()
    {
        InputsManager.instance.InputRestarting = false;
        SceneManager.LoadSceneAsync(SceneManager.GetActiveScene().name);
        StartCoroutine(Deload());
        SettingsManager.Instance.IsMainMenuActive = false;
    }
    IEnumerator Deload()
    {
        yield return new WaitForSeconds(1);//dur e de l'anim
        SceneManager.UnloadSceneAsync(SceneManager.GetActiveScene());
        yield return null;
    }
}
