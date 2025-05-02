using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using Cinemachine;

public class Clone : MonoBehaviour
{
    [SerializeField] private GameObject _clone;
    [SerializeField] private int _charID;
    [SerializeField] private PlayerVFX _playerVFX;
    [SerializeField] private GameObject _playerVisual;
    private PlayerStateMachine _playerStateMachine;
    [SerializeField] private Transform _paintingTransform;
    private CinemachineVirtualCamera CVC;
    private InputsManager _inputs;
    private bool _isInteracting;
    private bool _hasInteracted;
    [SerializeField] private bool _isInSocleRange = false;
    private GameObject _heldObject;
    public GameObject heldObject { get => _heldObject; set => _heldObject = value; }
    public int CharID { get => _charID; }
    public Transform PaintingTransform { get => _paintingTransform; set => _paintingTransform = value; }
    public bool IsInteracting { get => _isInteracting; set => _isInteracting = value; }
    public bool IsInSocleRange { get => _isInSocleRange; set => _isInSocleRange = value; }
    public bool HasInteracted { get => _hasInteracted; set => _hasInteracted = value; }

    private void Start()
    {
        CVC = CameraManager.Instance.MainCamera;
        CVC.Follow = transform;
        _inputs = InputsManager.instance;
        _playerStateMachine = GetComponent<PlayerStateMachine>();
        _charID = CloneManager.instance.Characters.Count;
        ChangeParent();
        CloneManager.instance.Characters.Add(this);
        CloneManager.instance.Switch(_charID - 1);
        _playerVisual.layer = transform.parent!=null? transform.parent.gameObject.layer:0;

    }

    void Update()
    {
        transform.position = new Vector3(transform.position.x, transform.position.y, 0);

        if (_inputs.InputSwitching && CloneManager.instance.CurrentPlayer == _charID)
        {
            CloneManager.instance.Switch(_charID);
            EventManager.instance?.OnJump.Invoke();
            _inputs.InputSwitching = false;
        }
        if (!_inputs.InputInteract)
        {
            _isInteracting = false;
        }
        if (_inputs.InputInteract && !_isInteracting&&CloneManager.instance.CurrentPlayer == _charID)
        {
            _isInteracting = true;
            _inputs.InputInteract = false;
        }
        if (_hasInteracted)
        {
            _isInteracting = false;
            _hasInteracted = false;
        }
    }

    public void Cloned(GameObject spawnPoint)// mettre dans des �tats pour la state machine
    {
        _playerStateMachine.ChangeState(_playerStateMachine.CloneState);
        GameObject instantiatedClone = Instantiate(_clone, spawnPoint.transform.position, spawnPoint.transform.rotation);
        AudioManager.Instance.SFX_CreateClone.Post(gameObject);
    }
    public void Switchup(bool isEnable)
    {
        if (isEnable)
        {
            CVC.Follow = gameObject.transform;
            //CVC.transform.position = transform.position;
        }
        //_playerVFX.CanPlayVFX(isEnable);

    }
    public void ChangeParent()
    {
        RaycastHit2D[] hits = Physics2D.RaycastAll(transform.position, Vector3.back);
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
                            Bounds paintingBounds = GetComponent<CapsuleCollider>().bounds;

                            if (levelBounds.Intersects(paintingBounds))
                            {
                                transform.SetParent(child.GetComponentInChildren<SpriteMask>().transform);
                                return;
                            }
                        }
                    }
                }
            }
        }
    }
}
