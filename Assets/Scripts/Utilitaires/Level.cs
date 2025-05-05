using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Level : MonoBehaviour
{
    bool _wasAlreadySpawned;

    public bool WasAlreadySpawned { get => _wasAlreadySpawned; set => _wasAlreadySpawned = value; }
}
