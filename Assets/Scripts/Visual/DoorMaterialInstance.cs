using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DoorMaterialInstance : MonoBehaviour
{
    private Material _material;
    [SerializeField]private Renderer _renderer;
    float _oldTimeScale=0;
    Coroutine _coroutine;
    // Start is called before the first frame update
    void Awake()
    {
        _material = _renderer.material;
    }
    public void In()
    {
        StartCoroutine(FadeIn());
    }
    public void Out(DoorVFX door)
    {
        StartCoroutine(FadeOut( door));

    }
    IEnumerator FadeIn()
    {
        float appearance = _material.GetFloat("_Cursor_Appearance_Corridor");
        float newAppearance= appearance;
        float timer = 0;
        while (timer < 3)
        {
            newAppearance = Mathf.Lerp(appearance, -0.5f, timer/3);
            _material.SetFloat("_Cursor_Appearance_Corridor", newAppearance);
            timer += Time.deltaTime;
            yield return null;
        }
    }
    IEnumerator FadeOut(DoorVFX door)
    {
        float appearance = _material.GetFloat("_Cursor_Appearance_Corridor");
        float newAppearance = appearance;
        float timer = 0;
        while (timer < 3)
        {
            newAppearance = Mathf.Lerp(appearance, 1f, timer / 3);
            _material.SetFloat("_Cursor_Appearance_Corridor", newAppearance);
            timer += Time.deltaTime;
            yield return null;
        }

    }
    IEnumerator InversingPath(DoorVFX door)
    {
        float timeScale = _material.GetFloat("_TimeScale");
        float newTimeScale = timeScale;
        _oldTimeScale = timeScale;
        float timer = 0;
        if (timeScale== 1)
        {
            while (timer < 3)
            {
                float val = door.Curve.Evaluate(timer / 3);
                newTimeScale = Mathf.Lerp(timeScale, 0, val);
                _material.SetFloat("_TimeScale", newTimeScale);
                timer += Time.deltaTime;
                yield return null;
            }
            _material.SetFloat("_TimeScale", 0);
        }
        if (timeScale ==0)
        {
            while (timer < 3)
            {
                float val = door.Curve.Evaluate(timer / 3);
                newTimeScale = Mathf.Lerp(timeScale, 1, val);
                _material.SetFloat("_TimeScale", newTimeScale);
                timer += Time.deltaTime;
                yield return null;
            }
            _material.SetFloat("_TimeScale", 1);
        }
        _coroutine = null;
        door.IsSwitching = false;
       yield return null;
    }

public void InversePath(DoorVFX door)//� retravailler si j'ai le temps
    {
        if (_coroutine!=null)
        {
            StopCoroutine(_coroutine);
            _coroutine = null;
            float timeScale = _material.GetFloat("_TimeScale");
            if (_oldTimeScale > timeScale)
            {
                _material.SetFloat("_TimeScale", 0);
            }
            else
            {
                _material.SetFloat("_TimeScale", 1);
            }
        }
        _coroutine=StartCoroutine(InversingPath( door));
    }
}
