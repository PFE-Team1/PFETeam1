using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StopFallParticles : AGameAction
{
    private ParticleSystem _fallParticle;

    private void Start()
    {
        
    }

    protected override void OnEnd()
    {
    }

    protected override void OnExecute()
    {
        Transform _fallParticlesGameObject = CloneManager.instance.Characters[CloneManager.instance.CurrentPlayer].gameObject.transform.Find("FallParticles");
        if (_fallParticlesGameObject == null)
        {
            Debug.LogError("Le gameObject qui doit contenir le particle system est vide");
        }
        _fallParticle = _fallParticlesGameObject.gameObject.GetComponent<ParticleSystem>();
        if (_fallParticle == null)
        {
            Debug.LogError("Le particle system est vide");
        }
        else
        {
            _fallParticle.Stop();
        }
    }
    protected override void OnUpdate(float deltaTime)
    {
    }
}
