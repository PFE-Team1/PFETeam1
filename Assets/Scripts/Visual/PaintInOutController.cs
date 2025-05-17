using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;
using UnityEngine;
using UnityEngine.UI;

public class PaintInOutController : MonoBehaviour
{
    private LineRenderer _line;
    private SpriteRenderer _eraseRend;
    [SerializeField]float _durationIn=5f;
    [SerializeField]float _durationOut=3f;
    [SerializeField]float _cameraMoveDuration=0.5f;
    [SerializeField]GameObject _firstPaint;
    [SerializeField]GameObject _endPaint;
    [SerializeField] GameObject _raw;
    [SerializeField] GameObject _mask;
    [SerializeField] GameObject _erase;
    RectTransform _rectTransform;
    RawImage _image;
    Coroutine _coroutine;

    [Button("Paint In")]
    public void PaintInButton()
    {
        PaintIn(_firstPaint);
    }

    public float DurationOut { get => _durationOut; }
    public GameObject EndPaint { get => _endPaint; set => _endPaint = value; }
    public float DurationIn { get => _durationIn;}

    private void Awake()
    {

        _rectTransform = _raw.GetComponent<RectTransform>();
        _image = _raw.GetComponent<RawImage>();
        _line = _mask.GetComponent<LineRenderer>();
        _eraseRend = _erase.GetComponent<SpriteRenderer>();
    }

    public  void PaintIn(GameObject paint)// objet , position taille
    {
        if (_coroutine!=null)
        {
            _eraseRend.material.SetFloat("_CursorErase", 2);
            _line.material.SetFloat("_CursorAppearance", 0);
            StopCoroutine(_coroutine);
            CameraManager.Instance.FocusCamera();
        }
        RectTransform paintRect = paint.GetComponent<RectTransform>();
        Debug.Log($"{paint.name} {paintRect.sizeDelta} {paintRect.localScale} {paintRect.position}");

        _rectTransform.anchorMin =paintRect.anchorMin;
        _rectTransform.anchorMax =paintRect.anchorMax;
        //_rectTransform.anchoredPosition = paintRect.anchoredPosition;
        _rectTransform.sizeDelta = paintRect.sizeDelta;
        _rectTransform.localScale = paintRect.localScale;
        transform.position = paintRect.position;
        _image.enabled = true;
        _coroutine=StartCoroutine(ShaderIn(paint));
    }
    public void PaintOut(GameObject paint)// objet , position taille
    {
        if (_coroutine != null)
        {
            _eraseRend.material.SetFloat("_CursorErase", 2);
            _line.material.SetFloat("_CursorAppearance", 0);
            StopCoroutine(_coroutine);
            CameraManager.Instance.FocusCamera();
            _image.enabled = false;
        }
        RectTransform paintRect = paint.GetComponent<RectTransform>();

        _rectTransform.anchorMin = paintRect.anchorMin;
        _rectTransform.anchorMax = paintRect.anchorMax;
        //_rectTransform.anchoredPosition = paintRect.anchoredPosition;
        _rectTransform.sizeDelta = paintRect.sizeDelta;
        _rectTransform.localScale = paintRect.localScale;
        transform.position = paintRect.position;
        _image.enabled = true;
        _coroutine=StartCoroutine(ShaderOut(paint));
    }
    IEnumerator ShaderIn(GameObject paint)
    {
        CameraManager.Instance.SeeCurrentLevel(paint, _cameraMoveDuration);
        float timer = 0;
        yield return new WaitForSeconds(_cameraMoveDuration);
        while (timer < _durationIn)
        {
            _line.material.SetFloat("_CursorAppearance",(timer / _durationIn)*2);
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
        CameraManager.Instance.SeeCurrentLevel(paint, _cameraMoveDuration);
        _eraseRend.material.SetFloat("_CursorErase", -1);
        paint.layer = 6;
        foreach (GameObject child in AllChilds(paint))
        {
            child.layer = 6;
        }
        float timer = 0;
        yield return new WaitForSeconds(_cameraMoveDuration);
        while (timer < _durationOut)
        {
            _eraseRend.material.SetFloat("_CursorErase", (timer / _durationOut)*3-1);
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