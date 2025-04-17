using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PaintInOutController : MonoBehaviour
{
    private LineRenderer _line;
    [SerializeField]float _duration=0.2f;
    [SerializeField]GameObject _firstPaint;
    [SerializeField] GameObject _raw;
    [SerializeField] GameObject _mask;
    RectTransform _rectTransform;
    RawImage _image;

    private void Awake()
    {

        _rectTransform = _raw.GetComponent<RectTransform>();
        _image = _raw.GetComponent<RawImage>();
        _line = _mask.GetComponent<LineRenderer>();
    }
    private void Start()
    {
        CameraManager.Instance.SeeCurrentLevel(_firstPaint);
        PaintIn(_firstPaint);
    }
    public  void PaintIn(GameObject paint)// objet , position taille
    {        RectTransform paintRect = paint.GetComponent<RectTransform>();

        _rectTransform.anchorMin =paintRect.anchorMin;
        _rectTransform.anchorMax =paintRect.anchorMax;
        //_rectTransform.anchoredPosition = paintRect.anchoredPosition;
        _rectTransform.sizeDelta = paintRect.sizeDelta;
        _rectTransform.localScale = paintRect.localScale;
        transform.position = paintRect.position;
        _image.enabled = true;
        StartCoroutine(ShaderIn(paint));
    }
    public void PaintOut(GameObject paint)// objet , position taille
    {
        RectTransform paintRect = paint.GetComponent<RectTransform>();
        _rectTransform.anchorMin = paintRect.anchorMin;
        _rectTransform.anchorMax = paintRect.anchorMax;
        //_rectTransform.anchoredPosition = paintRect.anchoredPosition;
        _rectTransform.sizeDelta = paintRect.sizeDelta;
        _rectTransform.localScale = paintRect.localScale;
        transform.position = paintRect.position;
        _image.enabled = true;
        StartCoroutine(ShaderOut(paint));
    }
    IEnumerator ShaderIn(GameObject paint)
    {
        float timer = 0;
        while (timer < _duration)
        {
            _line.material.SetFloat("_Float_GP",(timer / _duration) * 3f);
            timer += Time.deltaTime;//remplacer line avec shader d'aurore
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
    IEnumerator ShaderOut(GameObject paint)
    {
        float timer = 0;
        while (timer < _duration)
        {
            _line.material.SetFloat("_Float_GP",1-(timer / _duration)* 3f);
            timer += Time.deltaTime;//remplacer line avec shader d'aurore FLOAT OUI 
            yield return null;
        }
        paint.layer = 0;
        foreach (GameObject child in AllChilds(paint))
        {
            child.layer = 0;
        }
        CameraManager.Instance.FocusCamera();
        _image.enabled = false;
        yield return null;
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
}