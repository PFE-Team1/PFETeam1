using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloneSpawner : Interactable
{
    [SerializeField] GameObject _spawnPoint;
    [SerializeField] GameActionsSequencer _sequencer;
    [SerializeField] Renderer _rend;
    [SerializeField] string InitialSkinName = "Pink Clone";
    Clone player;
    // Update is called once per frame

    protected override void Interact()
    {
        if (IsInRange)
        {
            player = PlayerC;
            _sequencer.Play();
        }
    }

    public void CreateClone()
    {
        player.Cloned(_spawnPoint, InitialSkinName);
        Destroy(_spawnPoint);
        Destroy(gameObject.GetComponent<UIToolTipZone>());
        Destroy(gameObject.GetComponent<CloneSpawner>());
        _rend.enabled=false;

    }
}
