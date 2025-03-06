using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class InputsManager : MonoBehaviour
{
    // permet de récup les inputs bools/float ou vector2 partout dans le code
    #region InputVariables
    private bool _inputJumping;
    private bool _inputInteract;
    private bool _inputZooming;
    private bool _inputDezooming;
    private bool _inputSwitching;
    private bool _inputPausing;
    private bool _inputRestarting;
    private float _moveX;
    private Vector2 _lookaround;
    #endregion
    #region InputPropriétés 
    public bool InputJumping { get => _inputJumping;}
    public bool InputInteract { get => _inputInteract; }

    public bool InputZooming { get => _inputZooming;}
    public bool InputDezooming { get => _inputDezooming;}
    public bool InputSwitching { get => _inputSwitching; }
    public bool InputPausing { get => _inputPausing;}
    public bool InputRestarting { get => _inputRestarting;}
    public float MoveX { get => _moveX; }
    public Vector2 Lookaround { get => _lookaround;}
    #endregion
    #region InputMethodes
    public void OnJump(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            _inputJumping = true;
        }

        if (context.canceled)
        {
            _inputJumping = false;
        }
    }
    public void OnInterract(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            _inputInteract = true;
        }

        if (context.canceled)
        {
            _inputInteract = false;
        }
    }
    public void OnZoom(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            _inputZooming = true;
        }

        if (context.canceled)
        {
            _inputZooming = false;
        }
    }
    public void OnDezoom(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            _inputDezooming = true;
        }

        if (context.canceled)
        {
            _inputDezooming = false;
        }
    }
    public void OnSwitch(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            _inputSwitching = true;
        }

        if (context.canceled)
        {
            _inputSwitching = false;
        }
    }
    public void OnRestart(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            _inputRestarting = true;
        }

        if (context.canceled)
        {
            _inputRestarting = false;
        }
    }
    public void OnPauseResume(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            _inputPausing = true;
        }

        if (context.canceled)
        {
            _inputPausing = false;
        }
    }
    public void OnMove(InputAction.CallbackContext context)
    {
        _moveX = context.ReadValue<Vector2>().x;
    }
    public void OnLook(InputAction.CallbackContext context)
    {
        _lookaround = context.ReadValue<Vector2>();
    }
    #endregion
    #region Singleton
    private static InputsManager instance = null;
    public static InputsManager Instance => instance;


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
        DontDestroyOnLoad(this.gameObject);

        // Initialisation du Game Manager...
    }
    #endregion
    #region Init/InputAction
    private PlayerInput _playerInputs;
    [SerializeField] private InputActionAsset _inputActionAsset;
    private void Start()
    {
        SetupInputs();
    }

    private void SetupInputs()
    {
        _playerInputs = gameObject.AddComponent<PlayerInput>();
        _playerInputs.camera = FindFirstObjectByType<Camera>();
        _playerInputs.notificationBehavior = PlayerNotifications.InvokeUnityEvents;
        _playerInputs.actions = _inputActionAsset;
        _playerInputs.actions["Interact"].performed += OnInterract;
        _playerInputs.actions["Interact"].canceled += OnInterract;
        _playerInputs.actions["Interact"].Enable();
        _playerInputs.actions["Move"].performed += OnMove;
        _playerInputs.actions["Move"].canceled += OnMove;
        _playerInputs.actions["Move"].Enable();
        _playerInputs.actions["Jump"].performed += OnJump;
        _playerInputs.actions["Jump"].canceled += OnJump;
        _playerInputs.actions["Jump"].Enable();
        _playerInputs.actions["Switch"].performed += OnSwitch;
        _playerInputs.actions["Switch"].canceled += OnSwitch;
        _playerInputs.actions["Switch"].Enable();
        _playerInputs.actions["Restart"].performed += OnRestart;
        _playerInputs.actions["Restart"].canceled += OnRestart;
        _playerInputs.actions["Restart"].Enable() ;
        _playerInputs.actions["Pause"].performed += OnPauseResume;
        _playerInputs.actions["Pause"].canceled += OnPauseResume;
        _playerInputs.actions["Pause"].Enable();
        _playerInputs.actions["Zoom"].performed += OnZoom;
        _playerInputs.actions["Zoom"].canceled += OnZoom;
        _playerInputs.actions["Zoom"].Enable();
        _playerInputs.actions["Dezoom"].performed += OnDezoom;
        _playerInputs.actions["Dezoom"].canceled += OnDezoom;
        _playerInputs.actions["Dezoom"].Enable();
        _playerInputs.actions["Look"].performed += OnLook;
        _playerInputs.actions["Look"].canceled += OnLook;
        _playerInputs.actions["Look"].Enable();

    }
    #endregion
}
