using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Level : MonoBehaviour
{
    [SerializeField] private float offset = 2f;
    public float Offset { get => offset; set => offset = value; }

    [SerializeField] private GameObject ambianceManager;
    public GameObject AmbianceManager { get => ambianceManager; set => ambianceManager = value; }
}
