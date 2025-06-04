using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class enableInputsGameAction : AGameAction
{
    protected override void OnEnd()
    {
    }

    protected override void OnExecute()
    {
        InputsManager inputsManager = InputsManager.instance;
        inputsManager.EnableAllInputs();
    }

    protected override void OnUpdate(float deltaTime)
    {
    }
}
