using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetInputsGameAction : AGameAction
{
    [Header("Action Settings")]
    [SerializeField] private Inputs inputs = new Inputs();
    protected override void OnEnd()
    {
    }

    protected override void OnExecute()
    {
        InputsManager inputsManager = InputsManager.instance;
        inputsManager.InputJumping = inputs.InputJumping;
        inputsManager.InputInteract = inputs.InputInteract;
        inputsManager.MoveX = inputs.MoveX;
    }

    protected override void OnUpdate(float deltaTime)
    {
    }

    [Serializable]
    class Inputs
    {
        public bool InputJumping;
        public bool InputInteract;
        public float MoveX;
        public Inputs()
        {
            InputJumping = false;
            InputInteract = false;
            MoveX = 0f;
        }
    }
}
