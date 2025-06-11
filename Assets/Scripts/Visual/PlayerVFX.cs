using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerVFX : MonoBehaviour
{
    [SerializeField] MeshRenderer _playerRenderer;
    [SerializeField]GameObject _jumpVFX;
    [SerializeField]GameObject _landVFX;
    [SerializeField]ParticleSystem _walkVFX;
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
        foreach(GameObject child in AllChilds(jump))
        {
            child.GetComponent<ParticleSystemRenderer>().sortingLayerID = _playerRenderer.sortingLayerID;
        }
        jumpParticles.Play(true);
        StartCoroutine(StopVFXWhenEnded(jump));
    }
    private void StartWalkingVFX()
    {
        _walkVFX.Play(true);
    }
    private void StopWalkingVFX()
    {
        _walkVFX.Stop(true);

    }
    IEnumerator StopVFXWhenEnded(GameObject vfx)
    {
        yield return new WaitForSeconds(vfx.GetComponent<ParticleSystem>().main.duration);
        Destroy(vfx);
        yield break;
    }
    private void PlayLandVFX()
    {

        GameObject land = Instantiate(_landVFX, transform.position + _relativePositionJumpVFX, transform.rotation);
        ParticleSystemRenderer landParticlesRenderer = land.GetComponent<ParticleSystemRenderer>();
        ParticleSystem landParticles = land.GetComponent<ParticleSystem>();
        landParticlesRenderer.sortingLayerID = _playerRenderer.sortingLayerID;
        foreach (GameObject child in AllChilds(land))
        {
            child.GetComponent<ParticleSystemRenderer>().sortingLayerID = _playerRenderer.sortingLayerID;
        }
        landParticles.Play(true);
        StartCoroutine(StopVFXWhenEnded(land));
    }
    private void Enabling()
    {
        EventManager.instance?.OnJump.AddListener(PlayJumpVFX);
        EventManager.instance?.OnLand.AddListener(PlayLandVFX);
        EventManager.instance?.OnStartWalking.AddListener(StartWalkingVFX);
        EventManager.instance?.OnStopWalking.AddListener(StopWalkingVFX);
    }
    private void Disabling()
    {
        EventManager.instance?.OnJump.RemoveListener(PlayLandVFX);
        EventManager.instance?.OnLand.RemoveListener(PlayLandVFX);
        EventManager.instance?.OnStartWalking.RemoveListener(StartWalkingVFX);
        EventManager.instance?.OnStopWalking.RemoveListener(StopWalkingVFX);
    }
    private List<GameObject> AllChilds(GameObject root)
    {
        List<GameObject> result = new List<GameObject>();
        if (root.transform.childCount > 0)
        {
            foreach (Transform VARIABLE in root.transform)
            {
                Searcher(result, VARIABLE.gameObject);
            }
        }
        return result;
    }
    private void Searcher(List<GameObject> list, GameObject root)
    {
        list.Add(root);
        if (root.transform.childCount > 0)
        {
            foreach (Transform VARIABLE in root.transform)
            {
                if (VARIABLE.gameObject.layer != 3)
                    Searcher(list, VARIABLE.gameObject);
            }
        }
    }
}
