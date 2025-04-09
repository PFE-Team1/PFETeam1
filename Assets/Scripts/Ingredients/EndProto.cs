using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;

public class EndProto : Interactable
{

    private string _sceneToLoad;
    // Update is called once per frame
    void Update()
    {
        if (IsInRange)
        {
            if (PlayerC.IsInteracting)
            {
                PlayerC.IsInteracting = false;
                Application.Quit();
                //SceneManager.LoadScene(_sceneToLoad);
            }
        }
    }
}

