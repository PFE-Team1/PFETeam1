using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RunningPlayerState : PlayerState
{
    protected override void OnStateInit()
    {
    }

    protected override void OnStateEnter(PlayerState previousState)
    {
        _timeSinceEnteredState = StateMachine.Velocity.x / _playerMovementParameters.maxSpeed * _playerMovementParameters.accelerationTime;
    }

    protected override void OnStateExit(PlayerState nextState)
    {
    }

    protected override void OnStateUpdate()
    {
        if (StateMachine.JumpBuffer > 0)
        {
            StateMachine.JumpBuffer = 0;
            StateMachine.ChangeState(StateMachine.JumpStartState);
            return;
        }

        // afin d'éviter de faire les petits sauts dans les slopes
        if (!StateMachine.CollisionInfo.isCollidingBelow)
        {
            StateMachine.Velocity.y = -0.1f;
            StateMachine.ChangeState(StateMachine.FallingState);
            return;
        }

        if (Mathf.Abs(StateMachine.Velocity.x) <= 0 && _inputsManager.MoveX == 0)
        {
            StateMachine.ChangeState(StateMachine.IdleState);
            return;
        }

        // Calcul de la valeur cible en fonction de l'input
        float targetValue = 0;
        if (_inputsManager.MoveX != 0)
        {
            targetValue = _playerMovementParameters.accelerationTime * _inputsManager.MoveX;
        }

        // D�terminer si nous acc�l�rons ou d�c�l�rons
        bool isAccelerating = ((_timeSinceEnteredState >= 0 && targetValue > _timeSinceEnteredState) ||
                               (_timeSinceEnteredState <= 0 && targetValue < _timeSinceEnteredState));


        // Choisir le bon pas d'interpolation en fonction de si on acc�l�re ou d�c�l�re
        float step;
        if (isAccelerating)
        {
            step = Time.deltaTime / _playerMovementParameters.accelerationTime;
        }
        else
        {
            step = Time.deltaTime / _playerMovementParameters.decelerationTime;
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

        // Calcul de la vitesse en fonction du temps �coul�
        float speedRatio = _timeSinceEnteredState / _playerMovementParameters.accelerationTime;
        StateMachine.Velocity.x = speedRatio * _playerMovementParameters.maxSpeed;


        #region Yvelocity
        float h = _playerMovementParameters.jumpMaxHeight;
        float th = _playerMovementParameters.fallDuration / 2;
        float g = -(2 * h) / Mathf.Pow(th, 2);

        StateMachine.Velocity.y += g * Time.deltaTime;
        StateMachine.Velocity.y = Mathf.Clamp(StateMachine.Velocity.y, -_playerMovementParameters.maxFallSpeed, _playerMovementParameters.maxFallSpeed);
        #endregion
    }

}
