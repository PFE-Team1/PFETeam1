using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Parrallaxe : MonoBehaviour
{
    #region Layers
    [SerializeField] private List<GameObject>  _layers;
    #endregion
    [SerializeField] private bool _vertical;
    [SerializeField] private bool _horizontal;
    private Camera _mainCamera;
    [SerializeField]private BoxCollider2D _bounds;
    [SerializeField]private float _strengthY=0.01f;
    [SerializeField]private float _strengthX=0.01f;
    [SerializeField,Range(0.1f,0.2f)]private float fallOff=0.01f;
    private Vector2 _startPos;
    void Start()
    {
        _mainCamera=FindObjectOfType<Camera>();
        _startPos = transform.position;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        float distX = 0;
        float distY = 0;
        if (_vertical)
        {
            distY = _mainCamera.transform.position.y * _strengthY;
            if (distY > _bounds.size.y / 2) distY = _bounds.size.y / 2;
            if (distY <1- _bounds.size.y / 2) distY = 1-_bounds.size.y / 2;
        }
        if (_horizontal)
        {
            distX = _mainCamera.transform.position.x * _strengthX;
            if (distX > _bounds.size.x / 2) distX = _bounds.size.x / 2;
            if (distX <1- _bounds.size.x / 2) distX = 1-_bounds.size.x / 2;
        }
        float currentFallOff = 0;
        foreach(GameObject layer in _layers)
        {
            layer.transform.position = new Vector2(_startPos.x + distX*(1-currentFallOff), _startPos.y + distY*(1-currentFallOff));
            currentFallOff += fallOff;
        }
    }
}
