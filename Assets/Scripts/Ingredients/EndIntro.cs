using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;

public class EndIntro : Interactable
{

    private string _sceneToLoad;
    // Update is called once per frame
    void Update()
    {
        if (IsInRange)
        {
                //Application.Quit();
                ScenesManager.instance.loadNextScene();
                //SceneManager.LoadScene(_sceneToLoad);
        }
    }
}

