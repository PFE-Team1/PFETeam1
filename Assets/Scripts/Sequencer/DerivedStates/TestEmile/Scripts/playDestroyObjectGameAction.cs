using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class DestroyObjectGameAction : AGameAction
{
    [Header("Action Settings")]
    [SerializeField] private GameObject _object;
    protected override void OnExecute()
    {
        Destroy(_object);
    }
    protected override void OnUpdate(float deltaTime)
    {

    }
    protected override void OnEnd()
    {
    }
}
