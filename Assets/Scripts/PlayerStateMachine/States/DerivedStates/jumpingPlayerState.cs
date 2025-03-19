using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JumpingPlayerState : PlayerState
{
    protected override void OnStateInit()
    {
    }

    protected override void OnStateEnter(PlayerState previousState)
    {
        _timeSinceEnteredState = StateMachine.Velocity.x / _playerMovementParameters.airMaxSpeedX * _playerMovementParameters.JumpAccelerationTime;

        float h = _playerMovementParameters.jumpMaxHeight;
        float th = _playerMovementParameters.jumpDuration / 2;

        StateMachine.Velocity.x *= _playerMovementParameters.inertieLoss;
        StateMachine.Velocity.y = 2 * h / th;
        MonoBehaviour.print("Entering Jump");
    }

    protected override void OnStateExit(PlayerState nextState)
    {
        MonoBehaviour.print("Exiting Jump");
    }

    protected override void OnStateUpdate()
    {
        if (StateMachine.Velocity.y < 0 || StateMachine.CollisionInfo.isCollidingAbove)
        {
            StateMachine.ChangeState(StateMachine.FallingState);
            return;
        }

        #region Yvelocity

        float h;
        float th;
        float g;
        if (!_inputsManager.InputJumping)
        {
            h = _playerMovementParameters.minJump;
            th = _playerMovementParameters.minJump / _playerMovementParameters.jumpMaxHeight * _playerMovementParameters.jumpDuration / 2;
        }
        else
        {
            h = _playerMovementParameters.jumpMaxHeight;
            th = _playerMovementParameters.jumpDuration / 2;
        }
        g = (-2 * h) / Mathf.Pow(th, 2);

        StateMachine.Velocity.y += g * Time.deltaTime;
        #endregion

        #region Xvelocity

        float accelerationTime = _playerMovementParameters.JumpAccelerationTime;
        float airMaxSpeed = _playerMovementParameters.airMaxSpeedX;

        _timeSinceEnteredState += Time.deltaTime * _inputsManager.MoveX;
        _timeSinceEnteredState = Mathf.Clamp(_timeSinceEnteredState, -accelerationTime, accelerationTime);

        StateMachine.Velocity.x = (_timeSinceEnteredState / accelerationTime) * airMaxSpeed;
        StateMachine.Velocity.x = Mathf.Clamp(StateMachine.Velocity.x, -airMaxSpeed, airMaxSpeed);
        #endregion
    }
}