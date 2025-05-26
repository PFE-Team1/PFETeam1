using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OpenButton : Interactable
{
    [SerializeField] private List<ObectToDestroy> _objectsToRemove = new List<ObectToDestroy>();

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
                _spriteRenderer.sprite = null;
                _isRespawning = true;
                PlayerC.HasInteracted = true;
                foreach (ObectToDestroy toRemove in _objectsToRemove)
                {
                    toRemove.ObjectToRemove.SetActive(false);//� la place faire le truc du shader qui s'applique(disolve) et enlever la collision
                    if (toRemove.IsRespawnable == true)
                    {
                        StartCoroutine(Rebuilding(toRemove));
                    }
                    AudioManager.Instance.SFX_OuvertureMur.Post(gameObject);
                }
            }
        }
    }
    IEnumerator Rebuilding(ObectToDestroy destroyed)
    {
        float time = 0;
        yield return new WaitForSeconds(destroyed.RespawnStartTime);
        while (time < destroyed.RespawnTime)
        {
            time += Time.deltaTime;
            //Shader de resolve progressif sur la dur�e (time/respawnTime)
            yield return null;
        }
            destroyed.ObjectToRemove.SetActive(true);//� la place faire le truc du shader qui s'applique(disolve) et enlever la collision
        
        _spriteRenderer.sprite = _sprite;
        _isRespawning = false;
        yield return null;
    }
}
[Serializable]
struct ObectToDestroy
{
    public  GameObject ObjectToRemove;
    public bool IsRespawnable;
    public float RespawnTime;
    public float RespawnStartTime;
}
