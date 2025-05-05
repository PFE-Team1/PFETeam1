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
                StartCoroutine(EndOfLevel());
                //SceneManager.LoadScene(_sceneToLoad);
            }
        }
    }
    IEnumerator EndOfLevel()
    {
        CameraManager.Instance.SeeCurrentLevel(_level);
        _endEffect.PaintOut(_level);
        CameraManager.Instance.MainCamera.Follow=transform;
        float timer = 0;
        Vector3 currentPos = transform.position;
        while(timer< _displacementDuration)
         {
            float val = _curve.Evaluate(timer / _displacementDuration);
            transform.position = Vector3.Lerp(currentPos, _endPos, val);
            yield return null;
        }
        yield return null;
        
        ScenesManager.instance.loadNextScene();
    }
}

