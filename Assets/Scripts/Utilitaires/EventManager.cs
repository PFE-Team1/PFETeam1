using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using NaughtyAttributes;
using UnityEngine.Events;

public class EventManager : MonoBehaviour
{
    #region Instance
    public static EventManager instance;
    private void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
        else Destroy(this);
    }
    #endregion
    [Header("Personage")]
    public UnityEvent Feur;
    
    [Header("Camera")]
    public UnityEvent CameraZoom;
    public UnityEvent CameraDezoom;
    public UnityEvent CameraShake;
    public float shakeDuration;
    public float shakeMagnitude;   

}
