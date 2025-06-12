using System.Collections;
using System.Collections.Generic;
using System.Linq.Expressions;
using UnityEngine;

public class playAnimationGameAction : AGameAction
{
    [Header("Action Settings")]
    [SerializeField]
    [Tooltip("The name of the animation to play.")]
    private string animationName = "CloneCreation";
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
        PlayerStateMachine playerStateMachine = CloneManager.instance.GetCurrentStateMachine();
        playerStateMachine.Animator.SetTrigger(animationName);
    }
    protected override void OnUpdate(float deltaTime)
    {
    }
}
