using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;

public class loadSceneGameAction : AGameAction
{
    [SerializeField] private ScenesManager _scenesManager;

    protected override void OnEnd()
    {
    }

    protected override void OnExecute()
    {
        _scenesManager.LoadNextScene();
    }
    protected override void OnUpdate(float deltaTime)
    {
    }
}
