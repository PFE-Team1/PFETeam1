using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class InputsManager : MonoBehaviour
{
    #region Variables
    private bool _inputJumping;
    private bool _inputZooming;
    private bool _inputDezooming;
    private bool _inputSwitching;
    private bool _inputPausing;
    private bool _inputRestarting;
    private float _moveX;
    private Vector2 _lookaround;
#endregion
    #region Propriétés 
    public bool InputJumping { get => _inputJumping;}
    public bool InputZooming { get => _inputZooming;}
    public bool InputDezooming { get => _inputDezooming;}
    public bool InputSwitching { get => _inputSwitching; }
    public bool InputPausing { get => _inputPausing;}
    public bool InputRestarting { get => _inputRestarting;}
    public float MoveX { get => _moveX; }
    public Vector2 Lookaround { get => _lookaround;}
    #endregion
    #region Methodes
    public void Jump(InputAction.CallbackContext context)
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
    public void Zoom(InputAction.CallbackContext context)
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
    public void Dezoom(InputAction.CallbackContext context)
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
    public void Switch(InputAction.CallbackContext context)
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
    public void Restart(InputAction.CallbackContext context)
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
    public void Pause(InputAction.CallbackContext context)
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
    public void Move(InputAction.CallbackContext context)
    {
        _moveX = context.ReadValue<Vector2>().x;
    }
    public void LookAround(InputAction.CallbackContext context)
    {
        _lookaround = context.ReadValue<Vector2>();
    }
    #endregion
}
