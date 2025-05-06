using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using UnityEngine.Events;

public class Interactable : MonoBehaviour
{
    private GameObject player;
    private Clone _playerC;
    private PlayerStateMachine _playerStateMachine;
    [SerializeField] private bool isInRange = false;

    public GameObject Player { get => player; set => player = value; }
    public Clone PlayerC { get => _playerC; set => _playerC = value; }
    public PlayerStateMachine PlayerStateMachine { get => _playerStateMachine; set => _playerStateMachine = value; }
    public bool IsInRange { get => isInRange; set => isInRange = value; }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            player = other.gameObject;
            _playerC = player.GetComponent<Clone>();
            _playerStateMachine = player.GetComponent<PlayerStateMachine>();
            isInRange = true;
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            player = null;
            _playerC = null;
            _playerStateMachine = null;
            isInRange = false;
        }
    }
}
