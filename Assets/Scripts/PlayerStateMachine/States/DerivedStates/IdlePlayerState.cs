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
        StateMachine.Velocity = Vector2.zero;
        MonoBehaviour.print("Entering Idle");
    }

    protected override void OnStateExit(PlayerState nextState)
    {
        MonoBehaviour.print("Exiting Idle");
    }

    protected override void OnStateUpdate()
    {
        if (!StateMachine.CollisionInfo.isCollidingBelow)
        {
            StateMachine.ChangeState(StateMachine.FallingState);
            return;
        }
    }
}
