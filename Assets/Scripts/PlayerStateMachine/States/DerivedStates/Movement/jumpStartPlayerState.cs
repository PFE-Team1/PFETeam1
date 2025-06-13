using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JumpStartPlayerState : PlayerState
{
    protected override void OnStateInit()
    {
    }

    protected override void OnStateEnter(PlayerState previousState)
    {
        StateMachine.Animator.SetTrigger("JumpStart");
    }

    protected override void OnStateExit(PlayerState nextState)
    {
    }

    protected override void OnStateUpdate()
    {
        if (SettingsManager.Instance != null)
        {
            if (SettingsManager.Instance.IsInPause)
            {
                StateMachine.ChangeState(StateMachine.IdleState);
                return;
            }
        }
        _timeSinceEnteredState += Time.deltaTime;
        if (_timeSinceEnteredState > _playerMovementParameters.timeToJump)
        {
            StateMachine.ChangeState(StateMachine.JumpingState);
            return;
        }
    }
}