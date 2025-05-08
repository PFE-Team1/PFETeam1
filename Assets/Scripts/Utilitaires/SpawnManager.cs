using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnManager : MonoBehaviour
{
    [SerializeField] private GameObject _playerPrefab;
    [SerializeField] private GameObject _firstPaint;
    private PaintInOutController _paintVisual;
    void Start()
    {
        _paintVisual = FindObjectOfType<PaintInOutController>();
        StartCoroutine(StartSequence());
        
    }
    IEnumerator StartSequence()
    {
        _paintVisual?.PaintIn(_firstPaint);
        yield return new WaitForSeconds(_paintVisual.DurationIn);
        GameObject player = Instantiate(_playerPrefab, transform.position, Quaternion.identity);
        yield return new WaitForSeconds(2);
        Destroy(gameObject);
        yield return null;
    }
}
