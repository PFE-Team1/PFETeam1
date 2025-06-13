using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloneSpawner : Interactable
{
    [SerializeField] GameObject _spawnPoint;
    [SerializeField] string InitialSkinName = "Pink Clone";
    private bool interacted = false;
    // Update is called once per frame

    protected override void Interact()
    {
        if (interacted) return;
        if (IsInRange)
        {
            interacted = true;
            // if we find a sequencer in the childs
            GameActionsSequencer sequencer = GetComponentInChildren<GameActionsSequencer>();
            if (sequencer != null)
            {
                sequencer.Play();
            }
            else
            {
                PlayerC.Cloned(_spawnPoint, InitialSkinName);
                Destroy(_spawnPoint);
                Destroy(gameObject);
            }
        }
    }
}
