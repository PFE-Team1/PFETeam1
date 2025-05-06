using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;

public class EndProto : Interactable
{

    [SerializeField]private GameObject _level;
    [SerializeField]private AnimationCurve _curve;
    [SerializeField] private float _displacementDuration;
    [SerializeField] private Vector3 _endPos;
    [SerializeField] PaintInOutController _endEffect;
  
    // Update is called once per frame
    void Update()
    {
        if (IsInRange)
        {
            if (PlayerC.IsInteracting)
            {
                PlayerC.IsInteracting = false;
                PlayerC.gameObject.SetActive(false);
                if (!_endEffect || !_level)
                {
                    ScenesManager.instance.loadNextScene();
                }
                else
                {
                    StartCoroutine(EndOfLevel());
                }
                //SceneManager.LoadScene(_sceneToLoad);
            }
        }
    }
    IEnumerator EndOfLevel()
    {
        CameraManager.Instance.SeeCurrentLevel(_level);
        _endEffect.PaintOut(_level);
        yield return new WaitForSeconds(_endEffect.DurationOut/2);
        CameraManager.Instance.MainCamera.Follow=transform;
        float timer = 0;
        Vector3 currentPos = transform.position;
        while(timer< _displacementDuration)
         {
            float val = _curve.Evaluate(timer / _displacementDuration);
            transform.position = Vector3.Lerp(currentPos, _endPos, val);
            timer += Time.deltaTime;
            yield return null;
        }
        yield return new WaitForSeconds(3);
        ScenesManager.instance.loadNextScene();
        yield return null;

    }
}

