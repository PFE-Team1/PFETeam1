using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OpenButton : Interactable
{
    [SerializeField] GameObject _toRemove;

    // Update is called once per frame
    void Update()
    {
        if (IsInRange)
        {
            if (PlayerC.IsInteracting && PlayerC.heldObject == null)
            {
                PlayerC.IsInteracting = false;
                Destroy(_toRemove);
                Destroy(gameObject);
            }
        }
    }
}
