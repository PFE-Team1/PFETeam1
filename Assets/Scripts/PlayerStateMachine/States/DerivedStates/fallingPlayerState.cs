using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FallingPlayerState : PlayerState
{
    private float _timeSinceEnteredState;
    protected override void OnStateInit()
    {
    }

    protected override void OnStateEnter(PlayerState previousState)
    {
        MonoBehaviour.print("Entering Fall");
    }

    protected override void OnStateExit(PlayerState nextState)
    {
        MonoBehaviour.print("Exiting Fall");
    }

    protected override void OnStateUpdate()
    {
        #region StateChange
        if (StateMachine.CollisionInfo.isCollidingBelow)
        {
            StateMachine.ChangeState(StateMachine.IdleState);
            return;
        }
        #endregion

        #region Yvelocity
        float h = _playerMovementParameters.jumpMaxHeight;
        float th = _playerMovementParameters.fallDuration / 2;
        float g = -(2 * h) / Mathf.Pow(th, 2);

        StateMachine.Velocity.y += g * Time.deltaTime;
        StateMachine.Velocity.y = Mathf.Clamp(StateMachine.Velocity.y, -_playerMovementParameters.maxFallSpeed, _playerMovementParameters.maxFallSpeed);
        //StateMachine.velocity.y =- _movementParams.gravityScale; 
        #endregion

        #region Xvelocity

        float accelerationTime = _playerMovementParameters.fallAccelerationTime;
        float airMaxSpeed = _playerMovementParameters.fallMaxSpeedX;

        _timeSinceEnteredState += Time.deltaTime * _inputsManager.MoveX;
        _timeSinceEnteredState = Mathf.Clamp(_timeSinceEnteredState, -accelerationTime, accelerationTime);

        StateMachine.Velocity.x = Mathf.Abs((_timeSinceEnteredState / accelerationTime) * airMaxSpeed) * _inputsManager.MoveX; ;
        StateMachine.Velocity.x = Mathf.Clamp(StateMachine.Velocity.x, -airMaxSpeed, airMaxSpeed);

        if (_inputsManager.MoveX == 0)
        {
            StateMachine.Velocity.x = 0;
        }
        #endregion
    }
}
