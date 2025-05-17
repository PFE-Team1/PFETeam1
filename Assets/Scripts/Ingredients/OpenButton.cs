using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
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


    private void Start()
    {
        _isRespawning = false;
        _spriteRenderer = GetComponent<SpriteRenderer>();
        _sprite = _spriteRenderer.sprite;
        foreach (ObectToDestroy toRemove in _objectsToRemove)
        {
            if (toRemove.IsRespawnable)
            {
                toRemove.respawnable = toRemove.ObjectToRemove.AddComponent<RespawnableWall>();
                if (toRemove.IsParent)
                {
                   toRemove.Colliders.AddRange(toRemove.ObjectToRemove.GetComponentsInChildren<Collider>().Where(collide=>collide.gameObject!=toRemove.ObjectToRemove));
                   toRemove.Renderers.AddRange(toRemove.ObjectToRemove.GetComponentsInChildren<Renderer>().Where(collide=>collide.gameObject!=toRemove.ObjectToRemove));
                }
                else
                {
                    toRemove.Colliders.Add(toRemove.ObjectToRemove.GetComponent<Collider>());
                    toRemove.Renderers.Add(toRemove.ObjectToRemove.GetComponent<Renderer>());
                }
            }
            if (toRemove.RespawnTime+toRemove.RespawnStartTime > hightestRespawnTime)
            {
                hightestRespawnTime = toRemove.RespawnTime + toRemove.RespawnStartTime;
            }
            
        }
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
                foreach(ObectToDestroy toRemove in _objectsToRemove)
                {
                    for (int i = 0; i < toRemove.Colliders.Count; i++)
                    {
                        toRemove.Colliders[i].enabled = false;
                        toRemove.Renderers[i].enabled = false;
                    }
                        if (toRemove.IsRespawnable == true)
                    {
                        _coroutines.Add(StartCoroutine(Rebuilding(toRemove)));
                    }
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
            destroyed.currentTime = time;

            //Shader de resolve progressif sur la durée (time/respawnTime)
            yield return null;
        }
        while (destroyed.respawnable.IsRepawnBlocked)
        {
            print("feur");
            yield return null;
        }
        for (int i = 0; i < destroyed.Colliders.Count; i++)
        {
            destroyed.Colliders[i].enabled = true;
            destroyed.Renderers[i].enabled = true;
        }
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
}
[Serializable]
public class ObectToDestroy
{
    public  GameObject ObjectToRemove;
    public bool IsRespawnable;
    public bool IsParent;
    public float RespawnTime;
    public float RespawnStartTime;
    public float currentTime;
    public RespawnableWall respawnable;
    public List<Collider> Colliders=new List<Collider>();
    public List<Renderer> Renderers=new List<Renderer>();
}
