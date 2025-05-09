using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DoorVFX : MonoBehaviour
{
    [SerializeField] GameObject _doorVFXPrefab;
    [SerializeField]private GameObject _doorVFXInstance;
    [SerializeField] DoorVFX _otherDoorVFX;
     [SerializeField] LevelDoorManage _levelDoorManager;
     [SerializeField] AnimationCurve _curve;
    bool _isSwitching;

    private bool _isSpawned=false;
    [SerializeField]private bool _isDirection=false;

    public bool IsSpawned { get => _isSpawned; set => _isSpawned = value; }
    public GameObject DoorVFXInstance { get => _doorVFXInstance; set => _doorVFXInstance = value; }
    public bool IsDirection { get => _isDirection; set => _isDirection = value; }
    public DoorVFX OtherDoorVFX { get => _otherDoorVFX; set => _otherDoorVFX = value; }
    public LevelDoorManage LevelDoorManager { get => _levelDoorManager; set => _levelDoorManager = value; }
    public AnimationCurve Curve { get => _curve; }
    public bool IsSwitching { get => _isSwitching; set => _isSwitching = value; }

    public void PlayDoorVFX(Door otherDoor)
    {
        _otherDoorVFX = otherDoor.GetComponent<DoorVFX>();
        _otherDoorVFX.OtherDoorVFX = this;
        if (IsDirection == true&&_doorVFXInstance==null)
        {
            _doorVFXInstance = Instantiate(_doorVFXPrefab, (transform.position + otherDoor.transform.position) / 2, transform.rotation);
            _otherDoorVFX.DoorVFXInstance = _doorVFXInstance;
            _otherDoorVFX.IsDirection = false;
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
    public void SwitchDirection()
    {
        if (!IsSwitching)
        {
            foreach (DoorMaterialInstance child in _doorVFXInstance.transform.GetChild(0).GetComponentsInChildren<DoorMaterialInstance>())
            {
                IsSwitching = true;
                child.InversePath(this);
            }
            foreach (DoorMaterialInstance child in _doorVFXInstance.transform.GetChild(1).GetComponentsInChildren<DoorMaterialInstance>())
            {
                IsSwitching = true;
                child.InversePath(this);
            }
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            if (!IsDirection)
            {
                _levelDoorManager.UpdateDoor();
            }
        }
    }
}
