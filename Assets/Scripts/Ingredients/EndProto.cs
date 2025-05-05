using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;

public class EndProto : Interactable
{

    [SerializeField]private GameObject _level;
    // Update is called once per frame
    void Update()
    {
        if (IsInRange)
        {
            if (PlayerC.IsInteracting)
            {
                PlayerC.IsInteracting = false;
                //Application.Quit();
                CameraManager.Instance.SeeCurrentLevel(_level);
                ScenesManager.instance.loadNextScene();
                //SceneManager.LoadScene(_sceneToLoad);
            }
        }
    }
}

