using MoreMountains.Tools;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class showLetterBoxGameAction : AGameAction
{

    [Header("Action Settings")]
    [SerializeField] private string debugMessage = "Debug Game Action Executed";

    [SerializeField] private float duration = 1f; // Durée de l'action en secondes
    [SerializeField] private float openingRatio = 0.7f; // Ratio d'ouverture de la letterbox
    [SerializeField] private LetterBoxType letterBoxType = LetterBoxType.UpDown; // Type de letterbox
    protected override void OnExecute()
    {
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
