using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using UnityEngine.Events;
using System;

public class Interactable : MonoBehaviour
{
    public GameObject player;
    private Clone _playerC;
    private PlayerStateMachine _playerStateMachine;
    [SerializeField] private bool isInRange = false;

    public GameObject Player { get => player; set => player = value; }

    public List<GameObject> CollidingPlayers = new List<GameObject>();
    public Clone PlayerC { get => _playerC; set => _playerC = value; }
    public PlayerStateMachine PlayerStateMachine { get => _playerStateMachine; set => _playerStateMachine = value; }
    public bool IsInRange { get => isInRange; set => isInRange = value; }

    public bool isSocle = false;

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            if (!CollidingPlayers.Contains(other.gameObject))
            {
                CollidingPlayers.Add(other.gameObject);
            }
        }
    }
    void OnTriggerStay(Collider other)
    {
        UpdateCollidingPlayers();
    }

    void UpdateCollidingPlayers()
    {
        foreach (var collidingPlayer in CollidingPlayers)
        {
            PlayerStateMachine CollidingStateMachine = collidingPlayer.GetComponent<PlayerStateMachine>();
            if (player == null || CollidingStateMachine.CurrentState != CollidingStateMachine.CloneState || CollidingPlayers.Count == 1)
            {
                player = collidingPlayer;
                _playerC = player.GetComponent<Clone>();
                _playerStateMachine = CollidingStateMachine;
                isInRange = true;
                if (isSocle) player.GetComponent<Clone>().IsInSocleRange = true;
            }
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            if (CollidingPlayers.Contains(other.gameObject))
            {
                CollidingPlayers.Remove(other.gameObject);
                if (isSocle) other.GetComponent<Clone>().IsInSocleRange = false;
            }
            if (CollidingPlayers.Count == 0)
            {
                isInRange = false;
                player = null;
                _playerC = null;
                _playerStateMachine = null;
                return;
            }
        }
    }

    public void ResetcollidingPlayers()
    {
        CollidingPlayers = new List<GameObject>();
    }
}
