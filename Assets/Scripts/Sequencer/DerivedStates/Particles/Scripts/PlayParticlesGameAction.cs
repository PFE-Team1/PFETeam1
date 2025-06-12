using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayParticlesGameAction : AGameAction
{
    [SerializeField]private ParticleSystem _ParticleSystem;

    private void Start()
    {
        
    }

    protected override void OnEnd()
    {
    }

    protected override void OnExecute()
    {
        _ParticleSystem.Play();
    }
    protected override void OnUpdate(float deltaTime)
    {
    }
}
