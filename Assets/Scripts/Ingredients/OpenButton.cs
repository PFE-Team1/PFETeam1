using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class OpenButton : Interactable
{
    [SerializeField] private List<ObectToDestroy> _objectsToRemove = new List<ObectToDestroy>();
    [SerializeField] private float disolveDuration;
    private bool _isRespawning ;
    private bool _pause ;
    private Sprite _sprite ;
    private SpriteRenderer _spriteRenderer ;
    private List<Coroutine> _coroutines=new List<Coroutine>();
    float hightestRespawnTime=0;
    bool _cantInterract;


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
    IEnumerator Rebuilding(ObectToDestroy destroyed)
    {
        float time = destroyed.currentTime;
        yield return new WaitForSeconds(destroyed.RespawnStartTime);
        while (time < destroyed.RespawnTime)
        {
            while (destroyed.respawnable.IsRepawnBlocked)
            {
                yield return null;
            }         
            for (int i = 0; i < destroyed.Colliders.Count; i++)
            {
                destroyed.Renderers[i].material.SetFloat("_Disolve_Cursor2", -1.2f + (time / destroyed.RespawnTime)*2.2f);
            }
            time += Time.deltaTime;
            destroyed.currentTime = time;
            yield return null;
        }

        for (int i = 0; i < destroyed.Colliders.Count; i++)
        {
            destroyed.Colliders[i].enabled = true;
            destroyed.Renderers[i].material.SetFloat("_Disolve_Cursor2", 0);
        }
        if (destroyed.RespawnTime + destroyed.RespawnStartTime == hightestRespawnTime||time>hightestRespawnTime)
        {
            _spriteRenderer.sprite = _sprite;
            _isRespawning = false;
            _cantInterract = false;
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

    protected override void Interact()
    {
        if (!_cantInterract)
        {
            if (IsInRange)
            {
                _cantInterract = true;
                _spriteRenderer.sprite = null;
                _isRespawning = true;
                foreach (ObectToDestroy toRemove in _objectsToRemove)
                {

                    for (int i = 0; i < toRemove.Colliders.Count; i++)
                    {
                        toRemove.currentTime = 0;
                        toRemove.Colliders[i].enabled = false;
                        StartCoroutine(Disolve(toRemove.Renderers[i]));
                    }
                    if (toRemove.IsRespawnable == true)
                    {
                        _coroutines.Add(StartCoroutine(Rebuilding(toRemove)));
                    }

                }
            }
        }
    }
    IEnumerator Disolve(Renderer renderer)
    {
        float timer = 0;
        Material mat = renderer.material;
        while (timer < disolveDuration)
        {
            mat.SetFloat("_Disolve_Cursor2", 1- (timer / disolveDuration)*2.2f);
            timer += Time.deltaTime;
            yield return null;
        }
        mat.SetFloat("_Disolve_Cursor2", -1.2f);
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
