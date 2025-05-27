using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;

public class EndIntro : Interactable
{

    private string _sceneToLoad;

    protected override void Interact()
    {
    }

    // Update is called once per frame
    void Update()
    {
        if (IsInRange)
        {
                //Application.Quit();
                ScenesManager.instance.LoadNextScene();
                //SceneManager.LoadScene(_sceneToLoad);
        }
    }
}

