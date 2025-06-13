using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MoreMountains.Feedbacks;

public class StopFeedback : AGameAction
{
    [SerializeField] MMFeedbacks _feedback;

    private void Start()
    {

    }

    protected override void OnEnd()
    {
    }

    protected override void OnExecute()
    {
        _feedback.StopFeedbacks();
    }
    protected override void OnUpdate(float deltaTime)
    {
    }
}