using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RespawnableWall : MonoBehaviour
{
   [SerializeField]private bool _isRepawnBlocked;

    public bool IsRepawnBlocked { get => _isRepawnBlocked; }
    private int _count=0;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            _count++;
            _isRepawnBlocked = true;
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            _count--;
            if (_count == 0)
            {
                _isRepawnBlocked = false;

            }
        }
    }
}
