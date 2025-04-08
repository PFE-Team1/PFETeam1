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
        MonoBehaviour.print("Entering Run");
    }

    protected override void OnStateExit(PlayerState nextState)
    {
        MonoBehaviour.print("Exiting Run");
    }

    protected override void OnStateUpdate()
    {

        if (StateMachine.JumpBuffer > 0)
        {
            StateMachine.JumpBuffer = 0;
            StateMachine.ChangeState(StateMachine.JumpingState);
            return;
        }

        if (!StateMachine.CollisionInfo.isCollidingBelow)
        {
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

        // Déterminer si nous accélérons ou décélérons
        bool isAccelerating = ((_timeSinceEnteredState >= 0 && targetValue > _timeSinceEnteredState) ||
                               (_timeSinceEnteredState <= 0 && targetValue < _timeSinceEnteredState));


        // Choisir le bon pas d'interpolation en fonction de si on accélère ou décélère
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

        // Calcul de la vitesse en fonction du temps écoulé
        float speedRatio = _timeSinceEnteredState / _playerMovementParameters.accelerationTime;
        StateMachine.Velocity.x = speedRatio * _playerMovementParameters.maxSpeed;

    }

    }
