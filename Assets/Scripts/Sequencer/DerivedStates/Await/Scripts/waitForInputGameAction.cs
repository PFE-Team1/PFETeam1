using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class waitForInputGameAction : AGameAction
{

    [Header("Action Settings")]
    [SerializeField]
    [Tooltip("The type of input to wait for.")]
    InputsManager.InputType inputType = InputsManager.InputType.Jump;

    public override ActionEndCondition EndCondition => ActionEndCondition.ConditionMet;
    protected override void OnEnd()
    {
        print("Ending waitForInputGameAction. Condition met: " + _ConditionMet);
        switch (inputType)
        {
            case InputsManager.InputType.Jump:
                EventManager.instance.OnInputJump.RemoveListener(OnRightKeyPressed);
                break;
            case InputsManager.InputType.Move:
                EventManager.instance.OnInputMove.RemoveListener(OnRightKeyPressed);
                break;
            case InputsManager.InputType.Interact:
                EventManager.instance.OnInputInteract.RemoveListener(OnRightKeyPressed);
                break;
            case InputsManager.InputType.Switch:
                EventManager.instance.OnInputSwitch.RemoveListener(OnRightKeyPressed);
                break;
        }
    }

    protected override void OnExecute()
    {
        print("Wait for input action started. Waiting for input type: " + inputType);
        switch (inputType)
        {
            case InputsManager.InputType.Jump:
                EventManager.instance.OnInputJump.AddListener(OnRightKeyPressed);
                break;
            case InputsManager.InputType.Move:
                EventManager.instance.OnInputMove.AddListener(OnRightKeyPressed);
                break;
            case InputsManager.InputType.Interact:
                EventManager.instance.OnInputInteract.AddListener(OnRightKeyPressed);
                break;
            case InputsManager.InputType.Switch:
                EventManager.instance.OnInputSwitch.AddListener(OnRightKeyPressed);
                break;
            default:
                Debug.LogWarning("Unsupported input type for waitForInputGameAction.");
                break;
        }
    }
    protected override void OnUpdate(float deltaTime)
    {
    }

    private void OnRightKeyPressed()
    {
        _ConditionMet = true;
    }
}
