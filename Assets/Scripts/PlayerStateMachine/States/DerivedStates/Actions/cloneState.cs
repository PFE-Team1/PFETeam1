using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class cloneState : PlayerState
{
    protected override void OnStateInit()
    {
    }

    protected override void OnStateEnter(PlayerState previousState)
    {
        _timeSinceEnteredState = StateMachine.Velocity.x / _playerMovementParameters.fallMaxSpeedX * _playerMovementParameters.fallAccelerationTime;
        StateMachine.Animator.SetBool("Clone", true);
    }

    protected override void OnStateExit(PlayerState nextState)
    {
        StateMachine.Animator.SetBool("Carrying", false);
        StateMachine.Animator.SetBool("Clone", false);
    }

    protected override void OnStateUpdate()
    {
        StateMachine.Animator.SetBool("Carrying", StateMachine.IsCarrying);
        if (StateMachine.CollisionInfo.isCollidingBelow)
        {
            StateMachine.Velocity = new Vector2(0, -0.1f);
        }
        else
        {
            #region Yvelocity
            float h = _playerMovementParameters.jumpMaxHeight;
            float th = _playerMovementParameters.fallDuration / 2;
            float g = -(2 * h) / Mathf.Pow(th, 2);

            float t = Time.deltaTime;
            if (StateMachine.Velocity.y > 0) t *= 4;
            StateMachine.Velocity.y += g * t;
            StateMachine.Velocity.y = Mathf.Clamp(StateMachine.Velocity.y, -_playerMovementParameters.maxFallSpeed, _playerMovementParameters.maxFallSpeed);
            #endregion

            #region Xvelocity
            float targetValue = 0;

            // Déterminer si nous accélérons ou décélérons
            bool isAccelerating = ((_timeSinceEnteredState >= 0 && targetValue > _timeSinceEnteredState) ||
                                   (_timeSinceEnteredState <= 0 && targetValue < _timeSinceEnteredState));


            // Choisir le bon pas d'interpolation en fonction de si on accélère ou décélère
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

            // Calcul de la vitesse en fonction du temps écoulé
            float speedRatio = _timeSinceEnteredState / _playerMovementParameters.fallAccelerationTime;
            StateMachine.Velocity.x = speedRatio * _playerMovementParameters.fallMaxSpeedX;

            #endregion
        }
    }
}
