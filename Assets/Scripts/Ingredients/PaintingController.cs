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
    [SerializeField] private GameObject _VFXPoseSocle;
    [SerializeField] private ParticleSystem _VFXTrail;
    [SerializeField] private float RotationZ = 0f;
    public GameObject newLevelPrefab { get => _newLevelPrefab; set => _newLevelPrefab = value; }
    public GameObject spawnPoint { get => _spawnPoint; set => _spawnPoint = value; }
    private SpriteRenderer _spriteRenderer;
    private Rigidbody _rigidBody;
    private PaintHandler _paintHandlerAccessor;
    private Transform _targetTransform;
    private PaintHandler _paintHandler { get => getPaintHandler(); set => _paintHandler = value; }
    public bool _isHeld = false;
    public PlayerStateMachine CurrentHoldingStateMachine;

    private Transform _currentlyGrabbingTransform = null;

    [SerializeField] private ParticleSystem VFX_GrabToile;
    [SerializeField] private ParticleSystem VFX_PoseToile;

    private BoneFollower boneFollower;
    private bool _hasSpawned;

    public bool HasSpawned { get => _hasSpawned; set => _hasSpawned = value; }
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
        _rigidBody = GetComponent<Rigidbody>();
    }
    protected override void Interact()
    {
        print(PlayerC.IsInSocleRange);
        if (IsInRange)
        {
            if (_isHeld)
            {
                if (!PlayerC.IsInSocleRange)
                {
                    if (VFX_PoseToile != null)
                    {
                        Destroy(Instantiate(VFX_PoseToile, transform), 1f);
                    }
                    AudioManager.Instance.SFX_PoseToile.Post(gameObject);
                    AnimateDropPainting();
                }
            }
            else if (!transform.parent.GetComponent<LevelSpawner>()) 
            {
                AnimateGrabPainting();
            }
        }
    }

    public Transform GetSpawnPoint()
    {
        return spawnPoint.transform;
    }

    public void AnimateDropPainting(Transform Parent = null)
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
                            _targetTransform = Parent ? Parent : child.GetComponentInChildren<SpriteMask>().transform;
                            PlayerC.heldObject = null;
                            _isHeld = false;
                            CurrentHoldingStateMachine = null;
                            if (!GetComponentInChildren<UIToolTipZone>()) return;
                            gameObject.GetComponentInChildren<UIToolTipZone>().enabled = true;

                            return;
                        }
                    }
                }
            }
        }
    }
    public void DropPainting()
    {
        _VFXTrail.Play(true);
        _rigidBody.useGravity = true;
        transform.SetParent(_targetTransform);
        transform.localRotation = Quaternion.Euler(0, 0, 0);
        transform.localScale = new Vector3(0.2f, 0.2f, 0.2f);
        _paintHandler.ChangeSortingorder(_spriteRenderer.sortingOrder + 2);
        boneFollower.SkeletonRenderer = null;

        if (transform.parent.GetComponent<LevelSpawner>() != null) transform.localPosition = Vector3.zero;

        return;
    }

    public void AnimateGrabPainting()
    {
        PlayerStateMachine.ChangeState(PlayerStateMachine.PaintingGrabState);
        _isHeld = true;
        IsInRange = true;
        _paintHandler.CurrentPaintingController = this;
        _currentlyGrabbingTransform = PlayerC.PaintingTransform;
    }
    public void GrabPainting()
    {
        _VFXTrail.Stop(true);
        if (VFX_GrabToile != null)
        {
            Destroy(Instantiate(VFX_GrabToile, transform), 1f);
        }
        UnfreezePos();
        _rigidBody.useGravity = false;
        AudioManager.Instance.SFX_GrabToile.Post(gameObject);
        boneFollower.SkeletonRenderer = Player.GetComponentInChildren<SkeletonRenderer>();
        boneFollower.followZPosition = false;
        boneFollower.boneName = "Target_Arm_R";
        boneFollower.followBoneRotation = false;
        transform.localRotation = Quaternion.Euler(0, 0, RotationZ);
        transform.SetParent(_currentlyGrabbingTransform);
        transform.position = _currentlyGrabbingTransform.position;
        _paintHandler.ChangeLayer(_spriteRenderer.sortingLayerID);
        _paintHandler.ChangeSortingorder(_spriteRenderer.sortingOrder);
        CurrentHoldingStateMachine = PlayerC.GetComponent<PlayerStateMachine>();
        PlayerC.heldObject = gameObject;
        if (!GetComponentInChildren<UIToolTipZone>()) return;
        GetComponentInChildren<UIToolTipZone>().enabled = false;
    }
    public void FreezePos()
    {
        _rigidBody.constraints = RigidbodyConstraints.FreezeAll;
    }
    public void UnfreezePos()
    {

        _rigidBody.constraints = RigidbodyConstraints.FreezePositionZ|RigidbodyConstraints.FreezeRotation;
    }
    public void PlayVFXSocle()
    {
        _VFXPoseSocle.SetActive(true);
    }
}
