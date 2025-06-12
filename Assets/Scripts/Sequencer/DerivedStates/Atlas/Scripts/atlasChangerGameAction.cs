using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class atlasChangerGameAction : AGameAction
{
    [Header("Action Settings")]
    [SerializeField] private Material Mat;
    [SerializeField] private ChangeMode changeMode = ChangeMode.ChangeCurrentPlayer;
    public override ActionEndCondition EndCondition => ActionEndCondition.ConditionMet;
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
            Debug.LogWarning("CloneManager instance is null. Please ensure it is initialized before executing this action.");
            return;
        }

        switch (changeMode)
        {
            case ChangeMode.ChangeCurrentPlayer:
                if (playerStateMachine == null)
                {
                    return;
                }
                SetAtlasTexture(playerStateMachine);
                _ConditionMet = true;
                break;
            case ChangeMode.ChangeAllPlayers:
                foreach (Clone clone in CloneManager.instance.Characters)
                {
                    PlayerStateMachine playerStateMachineAll = clone.GetComponent<PlayerStateMachine>();
                    if (playerStateMachineAll == null)
                    {
                        Debug.LogWarning($"PlayerStateMachine for character {clone.CharID} is null. Skipping this character.");
                        continue;
                    }
                    SetAtlasTexture(playerStateMachineAll);
                }
                _ConditionMet = true;
                break;
        }
    }
    protected override void OnEnd()
    {
    }

    public void SetAtlasTexture(PlayerStateMachine playerStateMachine)
    {
        foreach(SkeletonRenderer skeletonRenderer in playerStateMachine.GetComponentsInChildren<SkeletonRenderer>())
        {
            var originalMaterial = skeletonRenderer.SkeletonDataAsset.atlasAssets[0].PrimaryMaterial;
            skeletonRenderer.CustomMaterialOverride[originalMaterial] = Mat; // to enable the replacement.
        }
    }

    private enum ChangeMode
    {
        ChangeCurrentPlayer,
        ChangeAllPlayers,
    }
}
