using MoreMountains.Tools;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
public class showLetterBoxGameAction : AGameAction
{

    [Header("Action Settings")]
    [SerializeField] private float TweenDuration = 1f; // Durée de l'action en secondes
    [SerializeField] private float openingRatio = 0.7f; // Ratio d'ouverture de la letterbox
    [SerializeField] private LetterBoxType letterBoxType = LetterBoxType.UpDown; // Type de letterbox

    public override ActionEndCondition EndCondition => ActionEndCondition.ConditionMet;
    protected override void OnExecute()
    {
        if (UIManager.Instance == null)
        {
            Debug.LogWarning("UIManager instance is null. Please ensure it is initialized before executing this action.");
            return;
        }

        Tween tween = null;
        switch (letterBoxType)
        {
            case LetterBoxType.UpDown:
                    tween = UIManager.Instance.TweenUpDownLetterBoxHeight(openingRatio, TweenDuration);
                break;
            case LetterBoxType.LeftRight:
                    tween = UIManager.Instance.TweenLeftRightLetterBoxWidth(openingRatio, TweenDuration);
                break;
        }

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
    [Serializable]
    private enum LetterBoxType
    {
        UpDown,
        LeftRight
    }
}
