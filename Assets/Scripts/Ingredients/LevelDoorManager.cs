using System.Collections;
using System.Linq;
using System.Collections.Generic;
using UnityEngine;

public class LevelDoorManage : MonoBehaviour
{
    [SerializeField]List<Door> _doors = new List<Door>();
    [SerializeField]bool _isEnd;
    bool _wasRemoved;

    private void Start()
    {
        _doors.AddRange(GetComponentsInChildren<Door>());
        foreach(Door door in _doors)
        {
            DoorVFX vfx = door.GetComponent<DoorVFX>();
            vfx.LevelDoorManager = this;
        }
    }
    public void UpdateDoor()
    {
        if (_doors.Find(x => x.GetComponent<DoorVFX>().IsDirection == false))
        {
            foreach (Door d in _doors)
            {
                if (d == null) continue;
                DoorVFX vfx = d.GetComponent<DoorVFX>();
                if (!vfx.IsDirection)
                {
                    
                    vfx.IsDirection = true;
                    if (vfx.OtherDoorVFX != null)
                    {
                        vfx.SwitchDirection();
                        vfx.OtherDoorVFX.IsDirection = false;
                    }
                }

            }
        }

    }
    private void OnEnable()
    {
        
    }

    public void Disable()
    {
        if (_isEnd) return;
        if (_doors.Count <= 0) return;
        foreach(Door d in _doors)
        {
            _wasRemoved = true;
            d?.OtherDoor?.Close();
            d?.Close();
        }
    }
    /*private void OnEnable()
    {
        if (_doors.Count <= 0) return;
        foreach (Door d in _doors)
        {
            d.OtherDoor = null;
        }
    }*/
}
