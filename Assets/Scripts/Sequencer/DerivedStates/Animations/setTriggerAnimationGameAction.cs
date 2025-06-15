using System.Collections;
using System.Collections.Generic;
using System.Linq.Expressions;
using UnityEngine;

public class setTriggerAnimationGameAction : AGameAction
{
    [Header("Action Settings")]
    [SerializeField]
    private Animator _animator;
    [SerializeField]
    private string _triggerName = "TriggerAnimation";
    [SerializeField]
    [Tooltip("Duration of the animation in seconds")]
    private float animationDuration = 1f;

    private void Awake()
    {
        duration = animationDuration;
    }
    protected override void OnEnd()
    {
    }

    protected override void OnExecute()
    {
        if (_animator == null)
        {
            Debug.LogError("Animator is not assigned in setTriggerAnimationGameAction.");
            return;
        }

        _animator.SetTrigger(_triggerName);
    }
    protected override void OnUpdate(float deltaTime)
    {
    }
}
