using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class Level : MonoBehaviour
{
    public bool _wasAlreadySpawned;
    [SerializeField] private Texture _levelTexture;
    public bool WasAlreadySpawned { get => _wasAlreadySpawned; set => _wasAlreadySpawned = value; }

    [SerializeField] private float offset = 2f;
    [SerializeField] GameObject _end;
    public float Offset { get => offset; set => offset = value; }
    public Texture LevelTexture { get => _levelTexture; }
    public GameObject End { get => _end; set => _end = value; }

    void Awake()
    {
        Collider2D collider = GetComponent<Collider2D>();
        if (collider is BoxCollider2D boxCollider)
        {
            boxCollider.size += new Vector2(offset * 2.1f, offset * 2.1f);
        }
    }
   public void FindPlayer(bool active)
    {
        List<Clone> clone = GetComponentsInChildren<Clone>(true).ToList();
        foreach (Clone c in clone)
        {
            c.gameObject.SetActive(active);
        }
    }
}
