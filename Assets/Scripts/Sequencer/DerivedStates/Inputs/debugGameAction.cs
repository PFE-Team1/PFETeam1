using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class debugGameAction : AGameAction
{

    [Header("Action Settings")]
    [SerializeField] private string debugMessage = "Debug Game Action Executed";
    protected override void OnExecute()
    {
        print(debugMessage);
    }
    protected override void OnUpdate(float deltaTime)
    {
    }
    protected override void OnEnd()
    {
    }
}
