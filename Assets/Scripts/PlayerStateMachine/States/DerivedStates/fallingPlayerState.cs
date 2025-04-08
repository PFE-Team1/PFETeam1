using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FallingPlayerState : PlayerState
{
    protected override void OnStateInit()
    {
    }

    protected override void OnStateEnter(PlayerState previousState)
    {
        _timeSinceEnteredState = StateMachine.Velocity.x / _playerMovementParameters.fallMaxSpeedX * _playerMovementParameters.fallAccelerationTime;
        //MonoBehaviour.print("Entering Fall");
        AudioManager.Instance.FOL_Atterissage.Post(null);
    }

    protected override void OnStateExit(PlayerState nextState)
    {
        //MonoBehaviour.print("Exiting Fall");
    }

    protected override void OnStateUpdate()
    {
        #region StateChange
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
        #endregion

        #region Yvelocity
        float h = _playerMovementParameters.jumpMaxHeight;
        float th = _playerMovementParameters.fallDuration / 2;
        float g = -(2 * h) / Mathf.Pow(th, 2);

        StateMachine.Velocity.y += g * Time.deltaTime;
        StateMachine.Velocity.y = Mathf.Clamp(StateMachine.Velocity.y, -_playerMovementParameters.maxFallSpeed, _playerMovementParameters.maxFallSpeed);
        #endregion

        #region Xvelocity
            float targetValue = 0;
            if (_inputsManager.MoveX != 0)
            {
                targetValue = _playerMovementParameters.fallAccelerationTime * _inputsManager.MoveX;
            }

            // D�terminer si nous acc�l�rons ou d�c�l�rons
            bool isAccelerating = ((_timeSinceEnteredState >= 0 && targetValue > _timeSinceEnteredState) ||
                                   (_timeSinceEnteredState <= 0 && targetValue < _timeSinceEnteredState));


            // Choisir le bon pas d'interpolation en fonction de si on acc�l�re ou d�c�l�re
            float step;
            if (isAccelerating)
            {
                step = Time.deltaTime / _playerMovementParameters.fallAccelerationTime;
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

            // Calcul de la vitesse en fonction du temps �coul�
            float speedRatio = _timeSinceEnteredState / _playerMovementParameters.fallAccelerationTime;
            StateMachine.Velocity.x = speedRatio * _playerMovementParameters.fallMaxSpeedX;
        #endregion
    }
}
