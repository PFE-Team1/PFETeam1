using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerVFX : MonoBehaviour
{
    [SerializeField] MeshRenderer _playerRenderer;
    [SerializeField]GameObject _jumpVFX;
    [SerializeField]Vector3 _relativePositionJumpVFX;
    private void OnEnable()
    {
        Enabling();
    }
    private void OnDisable()
    {
        Disabling();
    }
    public void CanPlayVFX(bool can)
    {
        if (can)
        {
            Enabling();
        }
        else
        {
            Disabling();
        }
    }
    private void PlayJumpVFX()
    {

        GameObject jump=Instantiate(_jumpVFX,transform.position+_relativePositionJumpVFX,transform.rotation);
        ParticleSystemRenderer jumpParticlesRenderer = jump.GetComponent<ParticleSystemRenderer>();
        ParticleSystem jumpParticles = jump.GetComponent<ParticleSystem>();
        jumpParticlesRenderer.sortingLayerID = _playerRenderer.sortingLayerID;
        jumpParticles.Play();
        StartCoroutine(StopVFXWhenEnded(jump));
    }
    IEnumerator StopVFXWhenEnded(GameObject vfx)
    {
        yield return new WaitForSeconds(vfx.GetComponent<ParticleSystem>().main.duration);
        Destroy(vfx);
        yield break;
    }
    private void Enabling()
    {
        EventManager.instance?.OnJump.AddListener(PlayJumpVFX);
    }
    private void Disabling()
    {
        EventManager.instance?.OnJump.RemoveListener(PlayJumpVFX);
    }
}
