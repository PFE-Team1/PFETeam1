using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetActiveGameAction : AGameAction
{
    [SerializeField] private bool _setActive;
    [SerializeField] private GameObject _gameObject;

    private void Start()
    {
    }

    protected override void OnEnd()
    {
    }

    protected override void OnExecute()
    {
        _gameObject.SetActive(_setActive);
    }
    protected override void OnUpdate(float deltaTime)
    {
    }
}
