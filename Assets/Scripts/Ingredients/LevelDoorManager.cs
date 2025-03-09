using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelDoorManage : MonoBehaviour
{
    List<Door> _doors = new List<Door>();

    private void Start()
    {
        _doors.AddRange(GetComponentsInChildren<Door>());
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
