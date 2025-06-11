using MoreMountains.Tools;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
public class setFadeGameAction : AGameAction
{

    [Header("Action Settings")]
    [Range(0f, 1f)]
    [SerializeField] float fadeRatio = 0.5f; // Ratio de fondu, entre 0 et 1
    protected override void OnExecute()
    {
        if (UIManager.Instance == null)
        {
            Debug.LogWarning("UIManager instance is null. Please ensure it is initialized before executing this action.");
            return;
        }
        UIManager.Instance.SetFadeValue(fadeRatio);
    }
    protected override void OnUpdate(float deltaTime)
    {
    }
    protected override void OnEnd()
    {
    }
}
