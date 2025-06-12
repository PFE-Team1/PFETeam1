using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class waitForPlayerToSpawn : AGameAction
{
    public override ActionEndCondition EndCondition => ActionEndCondition.ConditionMet;
    protected override void OnEnd()
    {
    }

    protected override void OnExecute()
    {
    }
    protected override void OnUpdate(float deltaTime)
    {
        PlayerStateMachine playerStateMachine = CloneManager.instance.GetCurrentStateMachine();
        if (playerStateMachine == null)
        {
            return;
        }
        if (CloneManager.instance == null)
        {
            return;
        }

        _ConditionMet = playerStateMachine != null && playerStateMachine.gameObject.activeInHierarchy;
    }
}
