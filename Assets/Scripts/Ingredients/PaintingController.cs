using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(BoneFollower))]
public class PaintingController : Interactable
{
    [SerializeField] private GameObject _newLevelPrefab;
    [SerializeField] private GameObject _spawnPoint;
    public GameObject newLevelPrefab { get => _newLevelPrefab; set => _newLevelPrefab = value; }
    public GameObject spawnPoint { get => _spawnPoint; set => _spawnPoint = value; }
    private SpriteRenderer _spriteRenderer;
    private PaintHandler _paintHandlerAccessor;
    private Collider2D _targetCollider;
    private PaintHandler _paintHandler { get => getPaintHandler(); set => _paintHandler = value; }
    public bool _isHeld = false;
    public PlayerStateMachine CurrentHoldingStateMachine;

    [SerializeField] private ParticleSystem VFX_GrabToile;
    [SerializeField] private ParticleSystem VFX_PoseToile;

    private BoneFollower boneFollower;

    private PaintHandler getPaintHandler()
    {
        _paintHandlerAccessor = Player.GetComponentInChildren<PaintHandler>();
        return _paintHandlerAccessor;
    }

    protected override void Start()
    {
        base.Start();
        boneFollower = GetComponent<BoneFollower>();
        _spriteRenderer = GetComponent<SpriteRenderer>();
    }
    protected override void Interact()
    {
        if (IsInRange && !PlayerC.IsInSocleRange)
        {
            if (_isHeld)
            {
                if (VFX_PoseToile != null)
                {
                    Destroy(Instantiate(VFX_PoseToile, transform), 1f);
                }
                AudioManager.Instance.SFX_PoseToile.Post(gameObject);
                AnimateDropPainting();
            }
            else
            {
                AnimateGrabPainting();
            }
        }
    }

    public Transform GetSpawnPoint()
    {
        return spawnPoint.transform;
    }

    public void AnimateDropPainting()
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
                    Collider2D[] childColliders = hitObject.GetComponentsInChildren<Collider2D>();
                    foreach (var child in childColliders)
                    {
                        SpriteRenderer sr = child.GetComponent<SpriteRenderer>();
                        if (sr != null)
                        {
                            PlayerStateMachine.ChangeState(PlayerStateMachine.PaintingDropState);
                            _paintHandler.CurrentPaintingController = this;
                            _targetCollider = child;
                            return;
                        }
                    }
                }
            }
        }
    }
    public void DropPainting()
    {
        // Visuel de peinture
        transform.SetParent(_targetCollider.GetComponentInChildren<SpriteMask>().transform);
        transform.localRotation = Quaternion.Euler(0, 0, 0);
        transform.localScale = new Vector3(0.2f, 0.2f, 0.2f);

        _paintHandler.ChangeSortingorder(_spriteRenderer.sortingOrder + 1);
        boneFollower.SkeletonRenderer = null;
        PlayerC.heldObject = null;
        _isHeld = false;
        CurrentHoldingStateMachine = null;
        return;
    }

    public void AnimateGrabPainting()
    {
        PlayerStateMachine.ChangeState(PlayerStateMachine.PaintingGrabState);
        _paintHandler.CurrentPaintingController = this;
    }
    public void GrabPainting()
    {
        if (VFX_GrabToile != null)
        {
            Destroy(Instantiate(VFX_GrabToile, transform), 1f);
        }
        AudioManager.Instance.SFX_GrabToile.Post(gameObject);
        boneFollower.SkeletonRenderer = Player.GetComponentInChildren<SkeletonRenderer>();
        boneFollower.followZPosition = false;
        boneFollower.boneName = "Target_Arm_R";
        transform.SetParent(PlayerC.PaintingTransform);
        transform.position = PlayerC.PaintingTransform.position;
        _paintHandler.ChangeLayer(_spriteRenderer.sortingLayerID);
        _paintHandler.ChangeSortingorder(_spriteRenderer.sortingOrder);
        CurrentHoldingStateMachine = PlayerC.GetComponent<PlayerStateMachine>();
        _isHeld = true;
        IsInRange = true;
        PlayerC.heldObject = gameObject;
    }
}
