using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class NewBehaviourScript : AGameAction
{
    [Header("Action Settings")]
    [SerializeField] private UnityEvent _event;
    protected override void OnExecute()
    {
    
    }
    protected override void OnUpdate(float deltaTime)
    {
    }
    protected override void OnEnd()
    {
    }
}
