using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(BoneFollower))]
public class PaintingController : Interactable
{
    [SerializeField] private GameObject _newLevelPrefab;
    [SerializeField] private GameObject _spawnPoint;
    public GameObject newLevelPrefab { get => _newLevelPrefab; set => _newLevelPrefab = value; }
    public GameObject spawnPoint { get => _spawnPoint; set => _spawnPoint = value; }
    private GameObject tableau;
    bool isHeld = false;

    [SerializeField] private ParticleSystem VFX_GrabToile;
    [SerializeField] private ParticleSystem VFX_PoseToile;
    private BoneFollower boneFollower;

    void Start()
    {
        tableau = GetComponentInParent<BoxCollider2D>().gameObject;
        boneFollower = GetComponent<BoneFollower>();
    }

    void Update()
    {
        if (IsInRange)
        {
            if (PlayerC.IsInteracting && !PlayerC.IsInSocleRange && !PlayerC.HasInteracted)
            {
                PlayerC.HasInteracted = true;
                if (isHeld)
                {
                    if (VFX_PoseToile != null)
                    {
                        Destroy(Instantiate(VFX_PoseToile, transform), 1f);
                    }
                    AudioManager.Instance.SFX_PoseToile.Post(gameObject);
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
                                Collider2D[] childColliders = hitObject.GetComponentsInChildren<Collider2D>();
                                foreach (var child in childColliders)
                                {
                                    SpriteRenderer sr = child.GetComponent<SpriteRenderer>();
                                    if (sr != null)
                                    {
                                        Bounds levelBounds = sr.bounds;
                                        Bounds paintingBounds = GetComponent<SpriteRenderer>().bounds;

                                        if (levelBounds.Intersects(paintingBounds))
                                        {
                                            
                                            // Visuel de peinture
                                            transform.SetParent(child.GetComponentInChildren<SpriteMask>().transform);
                                            transform.localRotation = Quaternion.Euler(0, 0, 0);
                                            transform.localScale = new Vector3(0.2f, 0.2f, 0.2f);
                                            // Changing state of State machine
                                            PlayerStateMachine.ChangeState(PlayerStateMachine.PaintingDropState);
                                            Player.GetComponentInChildren<PaintHandler>().BodyPartRenderer.MeshRenderer.sortingOrder = 251;
                                            boneFollower.SkeletonRenderer = null;
                                            PlayerC.heldObject = null;
                                            isHeld = false;
                                            return;
                                        }
                                    }
                                }
                            }
                        }
                    }

                }
                else
                {
                    if (VFX_GrabToile != null)
                    {
                        Destroy(Instantiate(VFX_GrabToile, transform), 1f);
                    }
                    AudioManager.Instance.SFX_GrabToile.Post(gameObject);
                    PlayerStateMachine.ChangeState(PlayerStateMachine.PaintingGrabState);
                    // Visuel de peinture
                    boneFollower.SkeletonRenderer = Player.GetComponentInChildren<SkeletonRenderer>();
                    boneFollower.followZPosition = false;
                    boneFollower.boneName = "Target_Arm_R";
                    transform.SetParent(PlayerC.PaintingTransform);
                    transform.position = PlayerC.PaintingTransform.position;
                    Player.GetComponentInChildren<PaintHandler>().BodyPartRenderer.MeshRenderer.sortingOrder = 250;
                    isHeld = true;
                    PlayerC.heldObject = gameObject;
                }
            }
        }
    }

    public Transform GetSpawnPoint()
    {
        return spawnPoint.transform;
    }
}
