using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Grabbable : MonoBehaviour
{
    bool _isGrabbed = false;

    public bool IsGrabbed { get => _isGrabbed; set => _isGrabbed = value; }

}
