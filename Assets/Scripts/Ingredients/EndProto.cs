using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EndProto : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            Application.Quit();
        }
    }
}
