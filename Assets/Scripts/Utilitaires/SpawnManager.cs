using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnManager : MonoBehaviour
{
    [SerializeField] private GameObject _playerPrefab;
    [SerializeField] private GameObject _firstPaint;
    [SerializeField] private PaintInOutController _paintVisual;
    private SpriteRenderer _renderer;
    private Animator _animator;
    void Start()
    {
        _renderer=GetComponent<SpriteRenderer>();
        _animator = GetComponent<Animator>();
        //StartCoroutine(StartSequence());
    }
    IEnumerator StartSequence()
    {
        if (_paintVisual)
        {
           // _paintVisual.PaintIn(_firstPaint);
            yield return new WaitForSeconds(_paintVisual.DurationIn+ CameraManager.Instance.CameraDezoomTime+2);
        }
        OpenRift();
        yield return new WaitForSeconds(1f);
        InstatiatePlayer();
        yield return new WaitForSeconds(3f);
        CloseRift();
        yield return new WaitForSeconds(1f);
        Destroy(gameObject);
        yield return null;
    }
    public void OpenRift()
    {
        _renderer.enabled = true;//+anim du perso qui sort /tombe.
        _animator.SetBool("Openning", true);
    }
    public void InstatiatePlayer()
    {
        GameObject player = Instantiate(_playerPrefab, transform.position, Quaternion.identity);

    }
    public void CloseRift()
    {
        _animator.SetBool("Closing", true);
    }

}
