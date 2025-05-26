using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OpenButton : Interactable
{
    [SerializeField] private List<ObectToDestroy> _objectsToRemove = new List<ObectToDestroy>();
    private bool _isRespawning ;
    private bool _pause ;
    private Sprite _sprite ;
    private SpriteRenderer _spriteRenderer ;
    private List<Coroutine> _coroutines=new List<Coroutine>();
    float hightestRespawnTime=0;


    protected override void Start()
    {
        base.Start();
        _isRespawning = false;
        _spriteRenderer = GetComponent<SpriteRenderer>();
        _sprite = _spriteRenderer.sprite;
        foreach (ObectToDestroy toRemove in _objectsToRemove)
        {
            if (toRemove.RespawnTime+toRemove.RespawnStartTime > hightestRespawnTime)
            {
                hightestRespawnTime = toRemove.RespawnTime + toRemove.RespawnStartTime;
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
            destroyed.currentTime = time;
            //Shader de resolve progressif sur la durée (time/respawnTime)
            yield return null;
        }
            destroyed.ObjectToRemove.SetActive(true);//à la place faire le truc du shader qui s'applique(disolve) et enlever la collision

        if (destroyed.RespawnTime + destroyed.RespawnStartTime == hightestRespawnTime)
        {
            _spriteRenderer.sprite = _sprite;
            _isRespawning = false;
        }
        yield return null;
    }
    public void ReStart()
    {
        foreach (ObectToDestroy toRemove in _objectsToRemove)
        {
            Debug.Log(toRemove.currentTime);
            if (toRemove.currentTime <= toRemove.RespawnTime&&toRemove.currentTime>0)
            {
                _coroutines.Add(StartCoroutine(ReStartBuilding(toRemove)));

            }
        }
    }
    IEnumerator ReStartBuilding(ObectToDestroy destroyed)
    {
        float time = destroyed.currentTime;
        yield return new WaitForSeconds(destroyed.RespawnStartTime);
        while (time < destroyed.RespawnTime)
        {
            time += Time.deltaTime;
            destroyed.currentTime = time;
            //Shader de resolve progressif sur la durée (time/respawnTime)
            yield return null;
        }
        destroyed.ObjectToRemove.SetActive(true);//à la place faire le truc du shader qui s'applique(disolve) et enlever la collision

        if (destroyed.RespawnTime + destroyed.RespawnStartTime == hightestRespawnTime)
        {
            _spriteRenderer.sprite = _sprite;
            _isRespawning = false;
        }
        yield return null;
    }

    protected override void Interact()
    {
        if (IsInRange)
        {
            _spriteRenderer.sprite = null;
            _isRespawning = true;
            foreach (ObectToDestroy toRemove in _objectsToRemove)
            {
                toRemove.ObjectToRemove.SetActive(false);//à la place faire le truc du shader qui s'applique(disolve) et enlever la collision
                if (toRemove.IsRespawnable == true)
                {
                    _coroutines.Add(StartCoroutine(Rebuilding(toRemove)));
                }
            }
        }
    }
}
[Serializable]
public class ObectToDestroy
{
    public  GameObject ObjectToRemove;
    public bool IsRespawnable;
    public float RespawnTime;
    public float RespawnStartTime;
    public float currentTime;
}
