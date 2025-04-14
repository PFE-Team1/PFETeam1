using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PaintInOutController : MonoBehaviour
{
    private Material _material;
    [SerializeField]float _duration=0.2f;
    [SerializeField]GameObject _firstPaint;
    RectTransform _rectTransform;
    RawImage _image;

    private void Awake()
    {
        _material = GetComponent<RawImage>().material;
        _rectTransform = GetComponent<RectTransform>();
        _image = GetComponent<RawImage>();
    }
    private void Start()
    {
        PaintIn(_firstPaint);
    }
    private void PaintIn(GameObject paint)// objet , position taille
    {
        _rectTransform = paint.GetComponent<RectTransform>();
        _image.enabled = true;
        StartCoroutine(ShaderIn(paint));
    }
    IEnumerator ShaderIn(GameObject paint)
    {
        float timer = 0;
        while (timer < _duration)
        {
            _material.SetFloat("_Fade", timer/10);
            timer += Time.deltaTime;
            yield return null;
        }
        paint.layer = 0;
        foreach (Transform child in paint.transform)
        {
            child.gameObject.layer = 0;
        }
        _image.enabled = false;
        yield return null;
    }
}
