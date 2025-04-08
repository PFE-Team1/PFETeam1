using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using UnityEngine.Events;

public class Interactable : MonoBehaviour
{
    private GameObject player;
    private Clone _playerC;
    [SerializeField] private bool isInRange = false;

    public GameObject Player { get => player; set => player = value; }
    public Clone PlayerC { get => _playerC; set => _playerC = value; }
    public bool IsInRange { get => isInRange; set => isInRange = value; }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            player = other.gameObject;
            _playerC = player.GetComponent<Clone>();
            isInRange = true;
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            player = null;
            _playerC = null;
            isInRange = false;
        }
    }
}
