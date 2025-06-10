using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Events;

public class EventManager : MonoBehaviour
{
    public static EventManager instance;
    public UnityEvent OnStartWalking;
    public UnityEvent OnStopWalking;
    public UnityEvent OnJump;
    public UnityEvent OnLand;
    public UnityEvent OnPickUpPainting;
    public UnityEvent OnLetGoPainting;
    public UnityEvent OnDoorOpen;
    public UnityEvent OnPaintingGrab;

    public UnityEvent OnInput;

    public UnityEvent OnInputInteract = new UnityEvent();
    private void Awake()
    {
        if (instance != null && instance != this)
        {
            Destroy(this.gameObject);
            return;
        }
        else
        {
            instance = this;
        }
    }
    private void OnLevelWasLoaded(int level)
    {
        print( "level"+level);
        OnInputInteract.RemoveAllListeners();
    }

}
