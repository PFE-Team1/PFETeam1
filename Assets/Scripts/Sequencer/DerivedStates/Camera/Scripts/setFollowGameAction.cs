using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class setFollowGameAction : AGameAction
{

    [Header("Action Settings")]
    [SerializeField]
    [Tooltip("The target GameObject to look at.")]
    private GameObject targetGameObject;

    protected override void OnEnd()
    {
    }

    protected override void OnExecute()
    {
        CameraManager.Instance.SetFollow(targetGameObject);
    }

    protected override void OnUpdate(float deltaTime)
    {
    }

    private void OnRightKeyPressed()
    {
        _ConditionMet = true;
    }
}
