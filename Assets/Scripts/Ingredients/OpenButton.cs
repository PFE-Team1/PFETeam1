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


    protected override void Start()
    {
        base.Start();
        _isRespawning = false;
        _spriteRenderer = GetComponent<SpriteRenderer>();
        _sprite = _spriteRenderer.sprite;
        foreach (ObectToDestroy toRemove in _objectsToRemove)
        {
            if (toRemove.IsParent)
            {
                toRemove.Colliders.AddRange(toRemove.ObjectToRemove.GetComponentsInChildren<Collider>().Where(collide => collide.gameObject != toRemove.ObjectToRemove && collide.isTrigger == false));
                toRemove.Renderers.AddRange(toRemove.ObjectToRemove.GetComponentsInChildren<Renderer>().Where(collide => collide.gameObject != toRemove.ObjectToRemove));

            }
            else
            {
                List<Collider> coll = toRemove.ObjectToRemove.GetComponents<Collider>().Where(collide=>collide.isTrigger==false).ToList();
                toRemove.Colliders.AddRange(coll);
                toRemove.Renderers.Add(toRemove.ObjectToRemove.GetComponent<Renderer>());
            }
            if (toRemove.IsRespawnable)
            {
                toRemove.respawnable = toRemove.ObjectToRemove.AddComponent<RespawnableWall>();

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
                    toRemove.ObjectToRemove.SetActive(false);//� la place faire le truc du shader qui s'applique(disolve) et enlever la collision
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
        float time = destroyed.currentTime;
        yield return new WaitForSeconds(destroyed.RespawnStartTime);
        while (time < destroyed.RespawnTime)
        {
            time += Time.deltaTime;
            destroyed.currentTime = time;

            //Shader de resolve progressif sur la dur�e (time/respawnTime)
            yield return null;
        }
        while (destroyed.respawnable.IsRepawnBlocked)
        {
            if (_isRespawning) 
            {
                _spriteRenderer.sprite = null;
                _isRespawning = true;
            }
            time += Time.deltaTime;
            yield return null;
        }
        for (int i = 0; i < destroyed.Colliders.Count; i++)
        {
            destroyed.Colliders[i].enabled = true;
            destroyed.Renderers[i].enabled = true;
        }
        if (destroyed.RespawnTime + destroyed.RespawnStartTime == hightestRespawnTime||time>hightestRespawnTime)
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
                _coroutines.Add(StartCoroutine(Rebuilding(toRemove)));

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
            //Shader de resolve progressif sur la dur�e (time/respawnTime)
            yield return null;
        }
        destroyed.ObjectToRemove.SetActive(true);//� la place faire le truc du shader qui s'applique(disolve) et enlever la collision

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
