using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PaintInOutController : MonoBehaviour
{
    private Material _material;
    [SerializeField]float _duration=0.2f;
    [SerializeField]GameObject _firstPaint;
    [SerializeField] GameObject _raw;
    RectTransform _rectTransform;
    RawImage _image;

    private void Awake()
    {

        _rectTransform = _raw.GetComponent<RectTransform>();
        _image = _raw.GetComponent<RawImage>();
        _material = _image.material;
    }
    private void Start()
    {
        CameraManager.Instance.SeeCurrentLevel(_firstPaint);
        PaintIn(_firstPaint);
    }
    public  void PaintIn(GameObject paint)// objet , position taille
    {
        RectTransform paintRect = paint.GetComponent<RectTransform>();
        _rectTransform.anchorMin =paintRect.anchorMin;
        _rectTransform.anchorMax =paintRect.anchorMax;
        _rectTransform.anchoredPosition = paintRect.anchoredPosition;
        _rectTransform.sizeDelta = paintRect.sizeDelta;
        _rectTransform.localScale = paintRect.localScale;
        transform.position = paintRect.position;
        _image.enabled = true;
        StartCoroutine(ShaderIn(paint));
    }
    IEnumerator ShaderIn(GameObject paint)
    {
        float timer = 0;
        while (timer < _duration)
        {
            _material.SetFloat("_Fade", (timer/_duration)*1.5f);
            timer += Time.deltaTime;
            yield return null;
        }
        paint.layer = 0;
        foreach (Transform child in paint.transform)
        {
            child.gameObject.layer = 0;
        }
        CameraManager.Instance.FocusCamera();
        _image.enabled = false;
        yield return null;
    }
}
