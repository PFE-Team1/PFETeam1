using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerProfileSwitcher : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField]
    private PlayerMovementParameters _playerMovementParameters;
    void Start()
    {
        // Récupère le box collider, si il n'est pas la, return et warn l'utilisateur
        BoxCollider boxCollider = GetComponent<BoxCollider>();
        if (boxCollider == null)
        {
            Debug.LogWarning("No BoxCollider found on the player, can't switch profile");
            return;
        }
    }
    private void OnTriggerEnter(Collider other)
    {
        if (_playerMovementParameters == null)
        {
            Debug.LogWarning("No PlayerMovementParameters set on the PlayerProfileSwitcher");
            return;
        }

        PlayerStateMachine playerStateMachine = other.GetComponent<PlayerStateMachine>();
        if (playerStateMachine != null)
        {
            playerStateMachine.PlayerMovementParameters = _playerMovementParameters;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        PlayerStateMachine playerStateMachine = other.GetComponent<PlayerStateMachine>();
        if (playerStateMachine != null)
        {
            playerStateMachine.PlayerMovementParameters = playerStateMachine.BasePlayerMovementParameters;
        }
    }
}
