using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class SpawnPlayerGameAction : AGameAction
{
    [Header("Action Settings")]
    [SerializeField] private SpawnManager _spawn;

    protected override void OnExecute()
    {
        _spawn.InstatiatePlayer();
    }
    protected override void OnUpdate(float deltaTime)
    {

    }
    protected override void OnEnd()
    {
    }
}
