using MoreMountains.Tools;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
public class FadeOutGameAction : AGameAction
{

    [Header("Action Settings")]
    [SerializeField] private float TweenDuration = 1f; // Durée de l'action en secondes

    public override ActionEndCondition EndCondition => ActionEndCondition.ConditionMet;
    protected override void OnExecute()
    {
        if (UIManager.Instance == null)
        {
            Debug.LogWarning("UIManager instance is null. Please ensure it is initialized before executing this action.");
            return;
        }

        Tween tween = null;
        tween = UIManager.Instance.FadeOut(TweenDuration);

        // On tween ended, set the condition as met
        if (tween != null)
        {
            tween.OnComplete(() => _ConditionMet = true);
        }
        else
        {
            Debug.LogWarning("Tween is null. Please check the UIManager setup.");
            _ConditionMet = true; // Set condition met if no tween is created
        }
    }
    protected override void OnUpdate(float deltaTime)
    {
    }
    protected override void OnEnd()
    {
    }
}
