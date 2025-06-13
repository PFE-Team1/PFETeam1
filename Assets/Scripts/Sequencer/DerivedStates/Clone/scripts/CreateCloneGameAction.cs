using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CreateCloneGameAction : AGameAction
{
    [SerializeField] CloneSpawner _cloneSpawner;

    private void Start()
    {
    }

    protected override void OnEnd()
    {
    }

    protected override void OnExecute()
    {
        _cloneSpawner.CreateClone();
    }
    protected override void OnUpdate(float deltaTime)
    {
    }
}
