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
        _timeSinceEnteredState = StateMachine.Velocity.x / _playerMovementParameters.jumpMaxSpeedX * _playerMovementParameters.jumpAccelerationTime;

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
            StateMachine.Velocity.y = 0;
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

        if (StateMachine.CollisionInfo.isCollidingLeft || StateMachine.CollisionInfo.isCollidingRight)
        {
            _timeSinceEnteredState = 0;
        }

        g = (-2 * h) / Mathf.Pow(th, 2);

        StateMachine.Velocity.y += g * Time.deltaTime;
        #endregion

        #region Xvelocity
        float targetValue = 0;
        if (_inputsManager.MoveX != 0)
        {
            targetValue = _playerMovementParameters.jumpAccelerationTime * _inputsManager.MoveX;
        }

        // Déterminer si nous accélérons ou décélérons
        bool isAccelerating = ((_timeSinceEnteredState >= 0 && targetValue > _timeSinceEnteredState) ||
                               (_timeSinceEnteredState <= 0 && targetValue < _timeSinceEnteredState));


        // Choisir le bon pas d'interpolation en fonction de si on accélère ou décélère
        float step;
        if (isAccelerating)
        {
            step = Time.deltaTime / _playerMovementParameters.jumpAccelerationTime;
        }
        else
        {
            step = Time.deltaTime / _playerMovementParameters.fallDecelerationTime;
        }

        // Appliquer l'interpolation
        if (_timeSinceEnteredState < targetValue)
        {
            _timeSinceEnteredState = Mathf.Min(_timeSinceEnteredState + step, targetValue);
        }
        else if (_timeSinceEnteredState > targetValue)
        {
            _timeSinceEnteredState = Mathf.Max(_timeSinceEnteredState - step, targetValue);
        }

        // Calcul de la vitesse en fonction du temps écoulé
        float speedRatio = _timeSinceEnteredState / _playerMovementParameters.jumpAccelerationTime;
        StateMachine.Velocity.x = speedRatio * _playerMovementParameters.jumpMaxSpeedX;
        #endregion
    }
}