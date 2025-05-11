using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Door : MonoBehaviour
{
    [SerializeField] private Collider _collider;
    [SerializeField] private SpriteRenderer _sprite;
    [SerializeField] private Door _otherDoor;
    [SerializeField] private DoorVFX _vfxOpen;
    [SerializeField] private GameObject _groundOpen;
    [SerializeField] private GameObject _closedDoorVFX;
    public Door OtherDoor { get => _otherDoor; set => _otherDoor = null; }

    public void Open()
    {
        _closedDoorVFX.SetActive(false);
        _collider.isTrigger = true;
        _sprite.enabled = false;
            _vfxOpen.PlayDoorVFX(_otherDoor); 
        _groundOpen.SetActive(true);
    }
    public  void Close()
    {
        _closedDoorVFX.SetActive(true);
        _collider.isTrigger = false;
        _sprite.enabled = true;
        _vfxOpen.StopDoorVFX();
        _groundOpen.SetActive(false);

    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Door")&&other!=_collider )
        {
            _otherDoor = other.GetComponentInChildren<Door>();
            //_otherDoor.Open();
            Open();
        }

    }
  
}
