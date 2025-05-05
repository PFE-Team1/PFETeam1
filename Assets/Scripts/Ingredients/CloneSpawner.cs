using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloneSpawner : Interactable
{
    [SerializeField] GameObject _spawnPoint;
    // Update is called once per frame
    void Update()
    {
        if (IsInRange)
        {
            if (PlayerC.IsInteracting &&!PlayerC.HasInteracted)
            {
                PlayerC.HasInteracted = true;

                PlayerC.Cloned(_spawnPoint);
                Destroy(_spawnPoint);
                Destroy(gameObject);
            }
        }
    }
}
