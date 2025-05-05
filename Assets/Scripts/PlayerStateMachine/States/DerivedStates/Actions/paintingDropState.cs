using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class paintingDropState : PlayerState
{
    protected override void OnStateInit()
    {
    }

    protected override void OnStateEnter(PlayerState previousState)
    {
    }

    protected override void OnStateExit(PlayerState nextState)
    {
        StateMachine.Animator.runtimeAnimatorController = StateMachine.BaseAnimator;
    }

    protected override void OnStateUpdate()
    {
        _timeSinceEnteredState += Time.deltaTime;
        if (_timeSinceEnteredState > _playerMovementParameters.timeToDrop)
        {
            if (StateMachine.CollisionInfo.isCollidingBelow)
            {
                if (_inputsManager.MoveX != 0)
                {
                    StateMachine.Velocity.y = -0.1f;
                    StateMachine.ChangeState(StateMachine.RunningState);
                    return;
                }
                StateMachine.ChangeState(StateMachine.IdleState);
                return;
            }
        }
    }
}
