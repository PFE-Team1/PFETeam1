using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IdlePlayerState : PlayerState
{
    private bool Idling = false;
    protected override void OnStateInit()
    {
    }

    protected override void OnStateEnter(PlayerState previousState)
    {
        if ((previousState is cloneState) && !StateMachine.CollisionInfo.isCollidingBelow)
        {
            StateMachine.ChangeState(StateMachine.FallingState);
            return;
        }
        StateMachine.Velocity = new Vector2(0, -0.1f );
    }

    protected override void OnStateExit(PlayerState nextState)
    {
    }

    protected override void OnStateUpdate()
    {
        if (_timeSinceEnteredState>3 && !Idling)
        {
            StateMachine.Animator.SetTrigger("Rest");
        }
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

        if (StateMachine.JumpBuffer > 0)
        {
            StateMachine.JumpBuffer = 0;
            StateMachine.ChangeState(StateMachine.JumpStartState);
            return;
        }

    }
}
