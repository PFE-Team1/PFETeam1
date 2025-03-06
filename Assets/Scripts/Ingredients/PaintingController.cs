using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PaintingController : MonoBehaviour
{
    [SerializeField] private GameObject _newLevelPrefab;
    [SerializeField] private GameObject _spawnPoint;
    public GameObject newLevelPrefab { get => _newLevelPrefab; set => _newLevelPrefab = value; }
    public GameObject spawnPoint { get => _spawnPoint; set => _spawnPoint = value; }
    private GameObject player;
    private GameObject tableau;
    private Clone playerC;
    bool isInRange = false;
    bool isHeld = false;

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            player = other.gameObject;
            playerC = player.GetComponent<Clone>();
            isInRange = true;
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            player = null;
            isInRange = false;
        }
    }

    void Start()
    {
        tableau = GetComponentInParent<BoxCollider2D>().gameObject;
    }

    void Update()
    {
        if (isInRange)
        {
            if (playerC.IsInteracting&&!playerC.IsInSocleRange)
            {
                if (isHeld)
                {
                    transform.SetParent(tableau.transform);
                    playerC.heldObject = null;
                    isHeld = false;
                }
                else
                {
                    transform.SetParent(player.transform);
                    isHeld = true;
                    playerC.heldObject = gameObject;
                }
                playerC.IsInteracting = false;
            }
        }
    }

    public Transform GetSpawnPoint()
    {
        return spawnPoint.transform;
    }
}
