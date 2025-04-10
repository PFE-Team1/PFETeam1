using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ScenesManager : MonoBehaviour
{
    public static ScenesManager  instance = null;
    [SerializeField]private string _nextScene;
    [SerializeField]private string _menuScene;
    [SerializeField]private GameObject _Scene;
    [SerializeField]private bool _isMainLevel;
    private void Awake()
    {
        instance = this;
    }
    public void loadNextScene()
    {
        SceneManager.LoadSceneAsync(_nextScene);
        StartCoroutine(Deload());
    }
    IEnumerator Deload()
    {
        if (_isMainLevel)
        {
            Destroy(_Scene);
            //active l'anim de deload
        }
        yield return new WaitForSeconds(1);//durée de l'anim
        SceneManager.UnloadSceneAsync(SceneManager.GetActiveScene());
        yield return null;
    }
}
