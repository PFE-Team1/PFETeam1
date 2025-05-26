using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloneSpawner : Interactable
{
    [SerializeField] GameObject _spawnPoint;
    [SerializeField] string InitialSkinName = "Pink Clone";
    // Update is called once per frame

    protected override void Interact()
    {
        if (IsInRange)
        {
            PlayerC.Cloned(_spawnPoint, InitialSkinName);
            Destroy(_spawnPoint);
            Destroy(gameObject);
        }
    }
}
