using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class disableInputsGameAction : AGameAction
{
    protected override void OnEnd()
    {
    }

    protected override void OnExecute()
    {
        InputsManager inputsManager = InputsManager.instance;
        inputsManager.DisableAllInputs();
    }

    protected override void OnUpdate(float deltaTime)
    {
    }
}
