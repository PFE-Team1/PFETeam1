using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Door : MonoBehaviour
{
    [SerializeField] private Collider _collider;
    [SerializeField] private Collider _triggerCollider;
    [SerializeField] private Door _otherDoor;
    [SerializeField] private DoorVFX _vfxOpen;
    [SerializeField] private GameObject _groundOpen;
    [SerializeField] private GameObject _closedDoorVFX;
    private GameObject _player;
    public Door OtherDoor { get => _otherDoor; set => _otherDoor = null; }

    public void Open()
    {
        _triggerCollider.excludeLayers = 0;
        _closedDoorVFX.SetActive(false);
        _collider.isTrigger = true;
            _vfxOpen.PlayDoorVFX(_otherDoor); 
        _groundOpen.SetActive(true);
    }
    public  void Close()
    {
        _triggerCollider.excludeLayers = 8;
        _closedDoorVFX.SetActive(true);
        _collider.isTrigger = false;
        _vfxOpen.StopDoorVFX();
        _groundOpen.SetActive(false);
        if (_player != null)
        {
            _player.SetActive(false);
            _player.transform.position = Vector3.zero;
            _player.SetActive(true);
            _player = null;
        }

    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Door")&&other!=_collider )
        {
            _otherDoor = other.GetComponentInChildren<Door>();
            //_otherDoor.Open();
            Open();
        }
        if (other.CompareTag("Player"))
        {
            _player = other.gameObject;
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            _player = null;
        }
    }
}
