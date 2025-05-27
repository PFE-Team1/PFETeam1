using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnManager : MonoBehaviour
{
    [SerializeField] private GameObject _playerPrefab;
    [SerializeField] private GameObject _firstPaint;
    [SerializeField] private PaintInOutController _paintVisual;
    private SpriteRenderer _renderer;
    void Start()
    {
        _renderer=GetComponent<SpriteRenderer>();

        StartCoroutine(StartSequence());
    }
    IEnumerator StartSequence()
    {
        if (_paintVisual)
        {
            _paintVisual.PaintIn(_firstPaint);
            yield return new WaitForSeconds(_paintVisual.DurationIn+ CameraManager.Instance.CameraDezoomTime+2);
        }
        _renderer.enabled = true;//+anim du perso qui sort /tombe.
        yield return new WaitForSeconds(.5f);
        GameObject player = Instantiate(_playerPrefab, transform.position, Quaternion.identity);
        yield return new WaitForSeconds(.5f);
        Destroy(gameObject);
        yield return null;
    }
}
