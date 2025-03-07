using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Door : MonoBehaviour
{
    [SerializeField] private Collider _collider;
    [SerializeField] private SpriteRenderer _sprite;
    [SerializeField]private Door _otherDoor;
    
    public Door OtherDoor { get => _otherDoor; set => _otherDoor = null; }

    public void Open()
    {
        _collider.excludeLayers = 8;
        _sprite.enabled = false;
    }
    public  void Close()
    {
        _collider.excludeLayers = 0;
        _sprite.enabled = true;
    }
    private void OnTriggerEnter(Collider other)

    {
        if (other.CompareTag("Door") )
        {
            _otherDoor = other.GetComponentInParent<Door>();
            //_otherDoor.Open();
            Open();
        }
    }
    private void Update()
    {

    }
}
