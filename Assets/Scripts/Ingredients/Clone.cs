using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using Cinemachine;

public class Clone : MonoBehaviour
{
    [SerializeField] private GameObject _clone;
    [SerializeField] private int _charID;
    [SerializeField] private PlayerInput _playerInput;
    private CinemachineVirtualCamera CVC;
    private bool _isInteracting;
    private bool _isInSocleRange=false;
    private GameObject _heldObject;
    public GameObject heldObject { get => _heldObject; set => _heldObject = value; }
    public int CharID { get => _charID;}
    public bool IsInteracting { get => _isInteracting; set => _isInteracting = value; }
    public bool IsInSocleRange { get => _isInSocleRange; set => _isInSocleRange = value; }

    private void Start()
    {
        CVC = FindObjectOfType<CinemachineVirtualCamera>();
        CVC.Follow = transform;
        _playerInput = GetComponent<PlayerInput>();
        _charID = CloneManager.instance.Characters.Count;
        CloneManager.instance.Characters.Add(this);
        CloneManager.instance.Switch(_charID-1);
    }
    
    public void Cloned(GameObject spawnPoint)// mettre dans des états pour la state machine
    {
        GameObject instantiatedClone = Instantiate(_clone, spawnPoint.transform.position, spawnPoint.transform.rotation);
        
    }
    public void Interact(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            _isInteracting = true;
        }
        if (context.canceled)
        {
            _isInteracting = false;
        }
    }
    public void Switch(InputAction.CallbackContext context)// mettre dans des états pour la state machine
    {
        if (context.performed)
        {
            CloneManager.instance.Switch(_charID);

        }
    }
    public void Switchup(bool isEnable)
    {
        _playerInput.enabled = isEnable;
        if (isEnable)
        {
            CVC.Follow = transform;
        }
    }
}
