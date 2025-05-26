using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnManager : MonoBehaviour
{
    [SerializeField] private GameObject _playerPrefab;
    [SerializeField] private GameObject _firstPaint;
    [SerializeField] private PaintInOutController _paintVisual;
    void Start()
    {
        StartCoroutine(StartSequence());
    }
    IEnumerator StartSequence()
    {
        Debug.Log($"COUCADZAh");
        if (_paintVisual)
        {
            Debug.Log($"COUCADZAh2");
            _paintVisual.PaintIn(_firstPaint);
            yield return new WaitForSeconds(_paintVisual.DurationIn);
        } 
        GameObject player = Instantiate(_playerPrefab, transform.position, Quaternion.identity);
        yield return new WaitForSeconds(.5f);
        Destroy(gameObject);
        yield return null;
    }
}
