using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PaintInOutController : MonoBehaviour
{
    private LineRenderer _line;
    private SpriteRenderer _eraseRend;
    [SerializeField]float _duration=0.2f;
    [SerializeField]float _durationOut=0.2f;
    [SerializeField]GameObject _firstPaint;
    [SerializeField]GameObject _endPaint;
    [SerializeField] GameObject _raw;
    [SerializeField] GameObject _mask;
    [SerializeField] GameObject _erase;
    RectTransform _rectTransform;
    RawImage _image;

    public float DurationOut { get => _durationOut; }

    private void Awake()
    {

        _rectTransform = _raw.GetComponent<RectTransform>();
        _image = _raw.GetComponent<RawImage>();
        _line = _mask.GetComponent<LineRenderer>();
        _eraseRend = _erase.GetComponent<SpriteRenderer>();
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
        _endCoroutine=StartCoroutine(ShaderOut(paint));
    }
    IEnumerator ShaderIn(GameObject paint)
    {
        float timer = 0;
        while (timer < _duration)
        {
            _line.material.SetFloat("_CursorAppearance",(timer / _duration) * 3f);
            timer += Time.deltaTime;//remplacer line avec shader d'aurore
            yield return null;
        }
        paint.layer = 0;
         foreach (GameObject child in AllChilds(paint))
        {
            child.layer = 0;
        }
        CameraManager.Instance.FocusCamera();
        _image.enabled = false;
        _line.material.SetFloat("_CursorAppearance", 0);
       yield return null;
    }
    IEnumerator ShaderOut(GameObject paint)
    {
        _eraseRend.material.SetFloat("_CursorErase", 0);
        paint.layer = 6;
        foreach (GameObject child in AllChilds(paint))
        {
            child.layer = 6;
        }
        float timer = 0;
      
        while (timer < _durationOut)
        {
            _eraseRend.material.SetFloat("_CursorErase", 2f*(timer / _durationOut));
            timer += Time.deltaTime;//remplacer line avec shader d'aurore FLOAT OUI 
            yield return null;
        }     
        
        paint.SetActive(false);
        _image.enabled = false;
        if(paint!= _endPaint)
        {
            CameraManager.Instance.FocusCamera();
            CameraManager.Instance.ReEvaluate();
        }
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