using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OpenButton : Interactable
{
    [SerializeField] List<GameObject> _objectsToRemove;
    [SerializeField] private bool _isRespawnable;
    [SerializeField] private float _respawnTime;
    [SerializeField] private float _respawnStartTime;
    private bool _isRespawning ;
    private Sprite _sprite ;
    private SpriteRenderer _spriteRenderer ;

    private void Start()
    {
        _isRespawning = false;
        _spriteRenderer = GetComponent<SpriteRenderer>();
        _sprite = _spriteRenderer.sprite;
    }
    // Update is called once per frame
    void Update()
    {
        if (IsInRange)
        {
            if (PlayerC.IsInteracting &&!PlayerC.HasInteracted)
            {
                PlayerC.HasInteracted = true;
                foreach(GameObject toRemove in _objectsToRemove)
                {
                    toRemove.SetActive(false);//à la place faire le truc du shader qui s'applique(disolve) et enlever la collision
                }
                _spriteRenderer.sprite=null;
                _isRespawning = true;
                if (_isRespawnable == true)
                {
                    StartCoroutine(Rebuilding());
                }
            }
        }
    }
    IEnumerator Rebuilding()
    {
        float time = 0;
        yield return new WaitForSeconds(_respawnStartTime);
        while (time < _respawnTime)
        {
            time += Time.deltaTime;
            //Shader de resolve progressif sur la durée (time/respawnTime)
            yield return null;
        }
        foreach (GameObject toRemove in _objectsToRemove)
        {
            toRemove.SetActive(true);//à la place faire le truc du shader qui s'applique(disolve) et enlever la collision
        }
        _spriteRenderer.sprite = _sprite;
        _isRespawning = false;
        yield return null;
    }
}
