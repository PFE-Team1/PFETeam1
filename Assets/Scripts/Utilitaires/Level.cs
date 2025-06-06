using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Level : MonoBehaviour
{
    public bool _wasAlreadySpawned;

    public bool WasAlreadySpawned { get => _wasAlreadySpawned; set => _wasAlreadySpawned = value; }

    [SerializeField] private float offset = 2f;
    public float Offset { get => offset; set => offset = value; }

    void Awake()
    {
        Collider2D collider = GetComponent<Collider2D>();
        if (collider is BoxCollider2D boxCollider)
        {
            boxCollider.size += new Vector2(offset * 2.1f, offset * 2.1f);
        }
    }
}
