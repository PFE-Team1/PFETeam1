using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class Clone : MonoBehaviour
{
    [SerializeField] GameObject _prefab1;
    [SerializeField] GameObject _prefab2;
    [SerializeField] Vector3 _offset;

    [SerializeField] Clone _next;
    [SerializeField] GameObject _nextGO;
    [SerializeField] Clone _previous;
    [SerializeField] GameObject _previousGO;
    [SerializeField] GameObject _selfGO;
    [SerializeField] Clone _self;
    [SerializeField] PlayerInput _nextPI;
    [SerializeField] PlayerInput _previousPI;
    [SerializeField] PlayerInput _selfPI;

    public Clone Next { get => _next; set => _next = value; }
    public Clone Previous { get => _previous; set => _previous = value; }
    public PlayerInput NextPI { get => _nextPI; set => _nextPI = value; }
    public PlayerInput PreviousPI { get => _previousPI; set => _previousPI = value; }

    private void Awake()
    {
        _selfGO = gameObject;
        _self = _selfGO.GetComponent<Clone>();  
        _selfPI = _selfGO.GetComponent<PlayerInput>();
        Debug.Log(gameObject.name);
    }
    public void Cloned(InputAction.CallbackContext context)
    {
        if (context.started)
        {
            if (_next == null)
            {
                _nextGO = Instantiate(_prefab1, _offset + transform.position, transform.rotation);
                updateNextPrevious();
            }
            else if (_previous == null)
            {
                _previousGO = Instantiate(_prefab2, _offset-transform.position, transform.rotation);
                updateNextPrevious();
            }
        }
    }
    public void Switch(InputAction.CallbackContext context)
    {
        if (context.started)
        {
            if (_next)
            {
                _nextPI.enabled = true;
                _selfPI.enabled=false;
            }
            else if (_previous)
            {
                _previousPI.enabled=true;
                _selfPI.enabled = false;
            }
        }
    }
    public void updateNextPrevious()
    {
        _selfGO = gameObject;
        _self = _selfGO.GetComponent<Clone>();
        _selfPI = _selfGO.GetComponent<PlayerInput>();
        if (_nextGO)
        {
            _next = _nextGO.GetComponent<Clone>();
            _nextPI = _nextGO.GetComponent<PlayerInput>();
            if (_previousGO)
            {
                _next.Next = _previous;
                _next.NextPI = _previousPI;
                _next._nextGO = _previousGO;
            }
            _next.Previous = _self;
            _next.PreviousPI = _selfPI;
            _next._previousGO = gameObject;
        }
        if (_previousGO)
        {
            _previous = _previousGO.GetComponent<Clone>();
            _previousPI = _previousGO.GetComponent<PlayerInput>();
            if (_nextGO)
            {
                _previous.Previous = _next;
                _previous.PreviousPI = _nextPI;
                _previous._previousGO = _nextGO;
            }
            _previous.Next = _self;
            _previous.NextPI = _selfPI;
            _previous._nextGO = gameObject;


        }
    }
}
