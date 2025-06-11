using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using Cinemachine;
using UnityEngine.Rendering;
using Spine.Unity;

public class Clone : MonoBehaviour
{
    [SerializeField] private GameObject _clone;
    [SerializeField] private int _charID;
    [SerializeField] private PlayerVFX _playerVFX;
    [SerializeField] private GameObject _playerVisual;
    [SerializeField] private List<SkeletonPartsRenderer> _skeletonPartRend;
    private PlayerStateMachine _playerStateMachine;
    [SerializeField] private Transform _paintingTransform;
    private CinemachineVirtualCamera CVC;
    private InputsManager _inputs;
    [SerializeField] private bool _isInSocleRange = false;
    private GameObject _heldObject;
    public GameObject heldObject { get => _heldObject; set => _heldObject = value; }
    public int CharID { get => _charID; }
    public Transform PaintingTransform { get => _paintingTransform; set => _paintingTransform = value; }
    public bool IsInSocleRange { get => _isInSocleRange; set => _isInSocleRange = value; }

    private void Start()
    {
        CVC = CameraManager.Instance.MainCamera;
        CameraManager.Instance.PlayerTransform = transform;
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
            //EventManager.instance?.OnJump.Invoke();
            _inputs.InputSwitching = false;
        }
        
    }

    public void Cloned(GameObject spawnPoint, string InitialSkinName)// mettre dans des �tats pour la state machine
    {
        _playerStateMachine.ChangeState(_playerStateMachine.CloneState);
        _clone.GetComponentInChildren<SkeletonMecanim>().initialSkinName = InitialSkinName;
        GameObject instantiatedClone = Instantiate(_clone, spawnPoint.transform.position, spawnPoint.transform.rotation);
        AudioManager.Instance.SFX_CreateClone.Post(gameObject);
        instantiatedClone.GetComponentInChildren<ToolTipManager>().InsideZone = false;
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
                                List<GameObject> changement=AllChilds(gameObject);
                                int val= child.GetComponent<Renderer>().sortingLayerID;
                                foreach (GameObject change in changement)
                                {
                                    if (change.GetComponent<Renderer>())
                                    {
                                        change.GetComponent<Renderer>().sortingLayerID = val;
                                    }
                                    if (change.GetComponent<ParticleSystemRenderer>())
                                    {
                                        change.GetComponent<ParticleSystemRenderer>().sortingLayerID = val;
                                    }
                                }
                                foreach (SkeletonPartsRenderer skel in _skeletonPartRend) 
                                {
                                    skel.MeshRenderer.sortingLayerID = val;
                                }
                                return;
                            }
                        }
                    }
                }
            }
        }
    }
    public void ChangeToLayerX(string val)
    {
        foreach (SkeletonPartsRenderer skel in _skeletonPartRend)
        {
            skel.MeshRenderer.sortingLayerName = val;
        }
    }
    private List<GameObject> AllChilds(GameObject root)
    {
        List<GameObject> result = new List<GameObject>();
        if (root.transform.childCount > 0)
        {
            foreach (Transform VARIABLE in root.transform)
            {
                Searcher(result, VARIABLE.gameObject);
            }
        }
        return result;
    }

    private void Searcher(List<GameObject> list, GameObject root)
    {
        list.Add(root);
        if (root.transform.childCount > 0)
        {
            foreach (Transform VARIABLE in root.transform)
            {
                Searcher(list, VARIABLE.gameObject);
            }
        }
    }
    public void ChangeLayer(int layerID)
    {
        gameObject.layer = 3;
        foreach (GameObject child in AllChilds(gameObject))
        {
            child.layer = 3;
        }
    }

}
