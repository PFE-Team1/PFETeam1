using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;
using DG.Tweening;

public class EndProto : Interactable
{

    [SerializeField]private GameObject _level;
    [SerializeField]private AnimationCurve _curve;
    [SerializeField] private float _displacementDuration;
    [SerializeField] private GameObject _endPos;
    [SerializeField] PaintInOutController _endEffect;

    protected override void Start()
    {
        base.Start();
        // Make it move up and down a litle based on his original position using a tween 
        transform.DOLocalMoveY(transform.localPosition.y + 0.25f, 2).SetLoops(-1, LoopType.Yoyo).SetEase(Ease.InOutSine);
        _endEffect = FindFirstObjectByType<PaintInOutController>();
        if (_endEffect == null) return;
        _endEffect.EndPaint = _level;
    }


    IEnumerator EndOfLevel()
    {
        CameraManager.Instance.SeeCurrentLevel(_level);
        yield return new WaitForSeconds(CameraManager.Instance.CameraDezoomTime);
        foreach (Level level in FindObjectsOfType<Level>())
        {
            if (level.gameObject != _level)
            {
                Destroy(level.gameObject);
            }
        }
        if (_endEffect != null)
        {
            _endEffect.PaintOut(_level);
            yield return new WaitForSeconds(_endEffect.DurationOut );
            CameraManager.Instance.MainCamera.Follow = transform;
            float timer = 0;
            Vector3 currentPos = transform.position;
            while (timer < _displacementDuration)
            {
                float val = _curve.Evaluate(timer / _displacementDuration);
                transform.position = Vector3.Lerp(currentPos, _endPos.transform.position, val);
                timer += Time.deltaTime;
                yield return null;
            }
            yield return new WaitForSeconds(3);
        }
        ScenesManager.instance.LoadNextScene();
        yield return null;

    }


    protected override void Interact()
    {
        if (IsInRange)
        {
            transform.parent = null;
            PlayerC.gameObject.SetActive(false);
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

