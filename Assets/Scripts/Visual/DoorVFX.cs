using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DoorVFX : MonoBehaviour
{
    [SerializeField] GameObject _doorVFXPrefab;
    [SerializeField]private GameObject _doorVFXInstance;
    [SerializeField] DoorVFX _otherDoorVFX;

    private bool _isSpawned=false;
    [SerializeField]private bool _isDirection=false;

    public bool IsSpawned { get => _isSpawned; set => _isSpawned = value; }
    public GameObject DoorVFXInstance { get => _doorVFXInstance; set => _doorVFXInstance = value; }
    public bool IsDirection { get => _isDirection; set => _isDirection = value; }
    public DoorVFX OtherDoorVFX { get => _otherDoorVFX; set => _otherDoorVFX = value; }

    public void PlayDoorVFX(Door otherDoor)
    {
        _otherDoorVFX = otherDoor.GetComponent<DoorVFX>();
        _otherDoorVFX.OtherDoorVFX = this;
        Debug.Log(IsDirection);
        if (IsDirection == true&&_doorVFXInstance==null)
        {
            Debug.Log("feur");
            _doorVFXInstance = Instantiate(_doorVFXPrefab, (transform.position + otherDoor.transform.position) / 2, transform.rotation);
            _otherDoorVFX.DoorVFXInstance = _doorVFXInstance;
        }

    }
    public void StopDoorVFX()
    {
       // _otherDoorVFX.DoorVFXInstance = null;
        Destroy(_doorVFXInstance);
        _doorVFXInstance = null;
        //_otherDoorVFX.OtherDoorVFX = null;
        _otherDoorVFX = null;
    }

}
