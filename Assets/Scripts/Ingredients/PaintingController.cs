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
    bool isInRange = false;
    bool isHeld = false;

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            player = other.gameObject;
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
            if (Input.GetKeyDown(KeyCode.E))
            {
                if (isHeld)
                {
                    Vector3 releasePosition = transform.position;
                    RaycastHit2D[] hits = Physics2D.RaycastAll(releasePosition, Vector3.back);

                    foreach (var hit in hits)
                    {
                        if (hit.collider != null)
                        {
                            GameObject hitObject = hit.collider.gameObject;

                            CompositeCollider2D composite = hitObject.GetComponent<CompositeCollider2D>();
                            if (composite != null)
                            {
                                BoxCollider2D[] childColliders = hitObject.GetComponentsInChildren<BoxCollider2D>();
                                foreach (var child in childColliders)
                                {
                                    SpriteRenderer sr = child.GetComponent<SpriteRenderer>();
                                    if (sr != null)
                                    {
                                        Bounds levelBounds = sr.bounds;
                                        Bounds paintingBounds = GetComponent<SpriteRenderer>().bounds;

                                        if (levelBounds.Intersects(paintingBounds))
                                        {
                                            transform.SetParent(child.transform);
                                            player.GetComponent<PlayerControllerTest>().heldObject = null;
                                            isHeld = false;
                                            return;
                                        }
                                    }
                                }
                            }
                        }
                    }

                    transform.SetParent(tableau.transform);
                    player.GetComponent<PlayerControllerTest>().heldObject = null;
                    isHeld = false;
                }


                else
                {
                    transform.SetParent(player.transform);
                    isHeld = true;
                    player.GetComponent<PlayerControllerTest>().heldObject = gameObject;
                }
            }
        }
    }

    public Transform GetSpawnPoint()
    {
        return spawnPoint.transform;
    }
}
