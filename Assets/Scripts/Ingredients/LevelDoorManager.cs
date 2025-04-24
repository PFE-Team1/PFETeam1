using System.Collections;
using System.Linq;
using System.Collections.Generic;
using UnityEngine;

public class LevelDoorManage : MonoBehaviour
{
    List<Door> _doors = new List<Door>();

    private void Start()
    {
        _doors.AddRange(GetComponentsInChildren<Door>());
    }
    public void UpdateDoor()
    {
        if (_doors.Find(x => x.GetComponent<DoorVFX>().IsDirection == true))
        {
            foreach (Door d in _doors)
            {
                DoorVFX vfx = d.GetComponent<DoorVFX>();
                vfx.IsDirection = true;
                if (vfx.OtherDoorVFX != null)
                {
                    vfx.OtherDoorVFX.IsDirection = false;
                }
            }
        }

    }
    private void OnDisable()
    {
        if (_doors.Count <= 0) return;
        foreach(Door d in _doors)
        {
            d.OtherDoor?.Close();
            d.Close();
        }
    }
    private void OnEnable()
    {
        if (_doors.Count <= 0) return;
        foreach (Door d in _doors)
        {
            d.OtherDoor = null;
        }
    }
}
