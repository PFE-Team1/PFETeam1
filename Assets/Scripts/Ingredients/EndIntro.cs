using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;

public class EndIntro : Interactable
{
    [SerializeField] private bool didOnce = false;
    private string _sceneToLoad;

    protected override void Interact()
    {
    }

    // Update is called once per frame
    void Update()
    {
        if (IsInRange && !didOnce)
        {
            //Application.Quit();
            ScenesManager.instance.LoadNextScene();
            didOnce = true;
            //SceneManager.LoadScene(_sceneToLoad);
        }
    }
}

