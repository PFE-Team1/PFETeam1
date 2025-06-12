using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class paintingGrabState : PlayerState
{
    float _timeSinceAnimation = 0f;
    protected override void OnStateInit()
    {

    }

    protected override void OnStateEnter(PlayerState previousState)
    {
        StateMachine.Animator.runtimeAnimatorController = StateMachine.AnimatorWithPaint;
        StateMachine.Animator.SetTrigger("GrabPaint");
        _timeSinceAnimation = 0f;
        _timeSinceEnteredState = StateMachine.Velocity.x / _playerMovementParameters.fallMaxSpeedX * _playerMovementParameters.fallAccelerationTime;
    }

    protected override void OnStateExit(PlayerState nextState)
    {
    }

    protected override void OnStateUpdate()
    {
        if (SettingsManager.Instance != null)
        {
            if (SettingsManager.Instance.isInPause)
            {
                StateMachine.ChangeState(StateMachine.IdleState);
                return;
            }
        }
        
        _timeSinceAnimation += Time.deltaTime;

        if (_timeSinceAnimation > _playerMovementParameters.timeToGrab)
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


        if (StateMachine.CollisionInfo.isCollidingBelow)
        {
            StateMachine.Velocity = new Vector2(0, -0.1f);
        }
        else
        {
            #region Yvelocity
            float h = _playerMovementParameters.jumpMaxHeight;
            float th = _playerMovementParameters.fallDuration / 4;
            float g = -(2 * h) / Mathf.Pow(th, 2);

            StateMachine.Velocity.y += g * Time.deltaTime;
            StateMachine.Velocity.y = Mathf.Clamp(StateMachine.Velocity.y, -_playerMovementParameters.maxFallSpeed, _playerMovementParameters.maxFallSpeed);
            #endregion

            #region Xvelocity
            float targetValue = 0;

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

}
