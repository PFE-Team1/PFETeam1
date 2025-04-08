using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IdlePlayerState : PlayerState
{
    protected override void OnStateInit()
    {
    }

    protected override void OnStateEnter(PlayerState previousState)
    {
        StateMachine.Velocity = new Vector2(0, -0.1f);
        MonoBehaviour.print("Entering Idle");
    }

    protected override void OnStateExit(PlayerState nextState)
    {
        MonoBehaviour.print("Exiting Idle");
    }

    protected override void OnStateUpdate()
    {
        if (StateMachine.IsMovementLocked) return;
        if (!StateMachine.CollisionInfo.isCollidingBelow)
        {
            StateMachine.ChangeState(StateMachine.FallingState);
            return;
        }

        if (_inputsManager.MoveX != 0)
        {
            StateMachine.ChangeState(StateMachine.RunningState);
            return;
        }

        if (_inputsManager.InputJumping && StateMachine.IsJumpInputEaten)
        {
            StateMachine.IsJumpInputEaten = false;
            StateMachine.ChangeState(StateMachine.JumpingState);
            return;
        }

    }
}
