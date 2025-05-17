using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RespawnableWall : MonoBehaviour
{
   [SerializeField]private bool _isRepawnBlocked;

    public bool IsRepawnBlocked { get => _isRepawnBlocked; }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            _isRepawnBlocked = true;
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            _isRepawnBlocked = false;
        }
    }
}
