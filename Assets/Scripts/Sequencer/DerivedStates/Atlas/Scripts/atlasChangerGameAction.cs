using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class atlasChangerGameAction : AGameAction
{
    [Header("Action Settings")]
    [SerializeField] private Texture2D atlasTexture;
    [SerializeField] private ChangeMode changeMode = ChangeMode.ChangeCurrentPlayer;
    protected override void OnExecute()
    {
        if (CloneManager.instance == null)
        {
            Debug.LogWarning("CloneManager instance is null. Please ensure it is initialized before executing this action.");
            return;
        }

        switch (changeMode)
        {
            case ChangeMode.ChangeCurrentPlayer:
                PlayerStateMachine playerStateMachine = CloneManager.instance.GetCurrentStateMachine();
                if (playerStateMachine == null)
                {
                    Debug.LogWarning("PlayerStateMachine is null. Please ensure it is initialized before executing this action.");
                    return;
                }
                SetAtlasTexture(playerStateMachine);
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
                break;
        }
    }
    protected override void OnUpdate(float deltaTime)
    {
    }
    protected override void OnEnd()
    {
    }

    public void SetAtlasTexture(PlayerStateMachine playerStateMachine)
    {
        if (playerStateMachine == null)
        {
            Debug.LogWarning("PlayerStateMachine is null. Please ensure it is initialized before setting the atlas texture.");
            return;
        }
        playerStateMachine.MeshRenderer.sharedMaterial.mainTexture = atlasTexture;
    }

    private enum ChangeMode
    {
        ChangeCurrentPlayer,
        ChangeAllPlayers,
    }
}
