using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class ZoomLevelGameAction : AGameAction
{
    [Header("Action Settings")]
    [SerializeField] private GameObject _level;
    protected override void OnExecute()
    {
        CameraManager.Instance.SeeCurrentLevel(_level);
    }
    protected override void OnUpdate(float deltaTime)
    {

    }
    protected override void OnEnd()
    {
    }
}
