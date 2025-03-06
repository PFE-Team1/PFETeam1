using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelDoorManage : MonoBehaviour
{
    [SerializeField] List<Door> _doors = new List<Door>();

    private void OnDisable()
    {
        if (_doors.Count <= 0) return;
        foreach(Door d in _doors)
        {
            d.OtherDoor?.Close();
            d.Close();
        }
    }
}
