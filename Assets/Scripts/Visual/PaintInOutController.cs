using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PaintInOutController : MonoBehaviour
{
    private Material _material;
    [SerializeField]float _duration=0.2f;

    private void Awake()
    {
        _material = GetComponent<RawImage>().material;
    }
    private void Start()
    {
        PaintIn();
    }
    private void PaintIn()
    {
        StartCoroutine(ShaderIn());
    }
    IEnumerator ShaderIn()
    {
        float timer = 0;
        while (timer < _duration)
        {
            _material.SetFloat("_Fade", timer/10);
            timer += Time.deltaTime;
            yield return null;
        }
        yield return null;
    }
}
