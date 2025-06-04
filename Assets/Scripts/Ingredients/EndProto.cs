using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;
using DG.Tweening;

public class EndProto : Interactable
{

    [SerializeField]private GameObject _level;
    [SerializeField] PaintInOutController _endEffect;
    private SpriteRenderer _fissure;
    private SpriteRenderer _renderer;
    private Animator _animator;

    protected override void Start()
    {
        base.Start();
        _renderer = GetComponent<SpriteRenderer>();
        _animator = GetComponent<Animator>();
        OpenRift();
        // Make it move up and down a litle based on his original position using a tween 
        transform.DOLocalMoveY(transform.localPosition.y + 0.25f, 2).SetLoops(-1, LoopType.Yoyo).SetEase(Ease.InOutSine);
        _endEffect = FindFirstObjectByType<PaintInOutController>();
        if (_endEffect == null) return;
        _endEffect.EndPaint = _level;
        _fissure = GetComponent<SpriteRenderer>();
        StartCoroutine(OpenFissure());
    }

    IEnumerator OpenFissure()
    {
        yield return new WaitForSeconds(5f);
        _fissure.enabled = true;

        //_fissure.le truc là anim et tout;
    }
    IEnumerator EndOfLevel()
    {
        CameraManager.Instance.SeeCurrentLevel(_level);
        yield return new WaitForSeconds(CameraManager.Instance.CameraDezoomTime);
        DestroyOtherLevel();
        if (_endEffect != null)
        {
            _endEffect.PaintOut(_level);
            yield return new WaitForSeconds(_endEffect.DurationOut );
            CameraManager.Instance.MainCamera.Follow = transform;
            float timer = 0;
            Vector3 currentPos = transform.position;
            yield return new WaitForSeconds(3);
        }
        ScenesManager.instance.LoadNextScene();
        yield return null;

    }
    public void DestroyOtherLevel()
    {
        foreach (Level level in FindObjectsOfType<Level>())
        {
            if (level.gameObject != _level)
            {
                Destroy(level.gameObject);
            }
        }
    }
    public void OpenRift()
    {
        _renderer.enabled = true;//+anim du perso qui sort /tombe.
        _animator.SetBool("Openning", true);
    }

    public void CloseRift()
    {
        _animator.SetBool("Closing", true);
    }

    protected override void Interact()
    {
        if (IsInRange)
        {
            transform.parent = null;
            if (!_endEffect || !_level)
            {
                ScenesManager.instance.LoadNextScene();
            }
            else
            {

                StartCoroutine(EndOfLevel());
            }
        }
    }
}

