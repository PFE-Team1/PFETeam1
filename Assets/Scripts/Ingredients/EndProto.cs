using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;
using DG.Tweening;

public class EndProto : Interactable
{

    [SerializeField]private GameObject _level;
    [SerializeField] PaintInOutController _endEffect;
    [SerializeField] ParticleSystem _riftEffect;
    [SerializeField] GameActionsSequencer _endSequence;
    private SpriteRenderer _fissure;
    private SpriteRenderer _renderer;
    private Animator _animator;

    protected override void Start()
    {
        _endSequence = GameObject.Find("EndSequence").GetComponent<GameActionsSequencer>();
        base.Start();
        _renderer = GetComponent<SpriteRenderer>();
        _animator = GetComponent<Animator>();
        _level.GetComponent<Level>().End = gameObject;
        // Make it move up and down a litle based on his original position using a tween 
        transform.DOLocalMoveY(transform.localPosition.y + 0.25f, 2).SetLoops(-1, LoopType.Yoyo).SetEase(Ease.InOutSine);
        _endEffect = FindFirstObjectByType<PaintInOutController>();
        _endEffect.EndPaint = _level;
        _fissure = GetComponent<SpriteRenderer>();
        StartCoroutine(OpenFissure());
    }

    IEnumerator OpenFissure()
    {
        yield return new WaitForSeconds(5f);
        _fissure.enabled = true;
        OpenRift();
        yield return new WaitForSeconds(1f);
        _riftEffect.Play();


        //_fissure.le truc l� anim et tout;
    }
    IEnumerator EndOfLevel()
    {
        _endEffect.EndPaint = _level;
        Destroy(PlayerC.gameObject) ;
        if (_endEffect != null)
        {
            _endEffect.PaintOut(_level);
        }
        DestroyOtherLevel();
        CloseRift();
        yield return new WaitForSeconds(1.5f);
        _riftEffect.Stop();
        yield return new WaitForSeconds(.5f);
        _renderer.enabled = false;
        yield return new WaitForSeconds(2);
        CameraManager.Instance.SeeCurrentLevel(_level);
        yield return new WaitForSeconds(CameraManager.Instance.CameraDezoomTime + _endEffect.DurationOut + 3);
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
    private void OpenRift()
    {
        _renderer.enabled = true;//+anim du perso qui sort /tombe.
        _animator.SetBool("Openning", true);
        AudioManager.Instance.SFX_Déchirure.Post(gameObject);
    }

    private void CloseRift()
    {
        _animator.SetBool("Closing", true);
    }

    protected override void Interact()
    {
        if (IsInRange)
        {
            _endSequence.Play();
            //transform.parent = null;
            //if (!_endEffect || !_level)
            //{
            //    ScenesManager.instance.LoadNextScene();
            //}
            //else
            //{

            //    StartCoroutine(EndOfLevel());
            //}
        }
    }
}

