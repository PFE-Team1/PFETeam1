using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class InputsManager : MonoBehaviour
{
    // permet de r�cup les inputs bools/float ou vector2 partout dans le code
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
    #region InputPropri�t�s 
    public bool InputJumping { get => _inputJumping;}
    public bool InputInteract { get => _inputInteract; }

    public bool InputZooming { get => _inputZooming;}
    public bool InputDezooming { get => _inputDezooming;}
    public bool InputSwitching { get => _inputSwitching; set => _inputSwitching = value; }
    public bool InputPausing { get => _inputPausing;}
    public bool InputRestarting { get => _inputRestarting; set => _inputRestarting = value; }
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
    public void OnInteract(InputAction.CallbackContext context)
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
    public void OnPause(InputAction.CallbackContext context)
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
    public static InputsManager instance = null;

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
        SetupInputs();

        // Initialisation du Game Manager...
    }

    private void InvokeInputMethod(string methodName, InputAction.CallbackContext context)
    {
        var method = GetType().GetMethod(methodName, System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.NonPublic);
        if (method != null)
        {
            method.Invoke(this, new object[] { context });
        }
        else
        {
            Debug.LogWarning($"Méthode {methodName} introuvable dans InputsManager.");
        }
    }

    #region Init/InputAction
    public PlayerInput _playerInputs;
    [SerializeField] private InputActionAsset _inputActionAsset;

    private void SetupInputs()
    {
        _playerInputs = gameObject.AddComponent<PlayerInput>();
        _playerInputs.camera = FindFirstObjectByType<Camera>();
        _playerInputs.notificationBehavior = PlayerNotifications.InvokeUnityEvents;
        _playerInputs.actions = _inputActionAsset;

        foreach (var action in _playerInputs.actions)
        {
            action.performed += ctx => InvokeInputMethod($"On{action.name}", ctx);
            action.canceled += ctx => InvokeInputMethod($"On{action.name}", ctx);
            action.Enable();
        }
    }
    #endregion
}
