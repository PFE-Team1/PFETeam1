using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloneSpawner : Interactable
{

    // Update is called once per frame
    void Update()
    {
        if (IsInRange)
        {
            if (PlayerC.IsInteracting &&!PlayerC.HasInteracted)
            {
                PlayerC.HasInteracted = true;

                PlayerC.Cloned(gameObject);
                Destroy(gameObject);
            }
        }
    }
}
