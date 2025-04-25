using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnManager : MonoBehaviour
{
    [SerializeField] private GameObject PlayerPrefab;
    void Start()
    {
        GameObject player = Instantiate(PlayerPrefab, transform.position, Quaternion.identity);
    }
}
