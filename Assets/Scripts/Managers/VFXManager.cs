using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.VFX;

public class VFXManager : MonoBehaviour
{
    // Start is called before the first frame update
    private List<GameObject> _visualEffects=new List<GameObject>();
    private List<GameObject> _activeEffects=new List<GameObject>();
    public VFXManager instance;
    private void Awake()
    {
        if (instance != null && instance != this)
        {
            Destroy(this.gameObject);
            return;
        }
        else
        {
            instance = this;
        }
    }
    public void PlayVFXAt(Vector3 where, int id, string name)
    {
        if (id>=_visualEffects.Count) return;
        GameObject vfx=Instantiate(_visualEffects[id], where, transform.rotation);
        vfx.GetComponent<VisualEffect>().Play();
        _activeEffects.Add(vfx);
    }
    public void StopVFX(string name)
    {
        foreach(GameObject effectToRemove in _activeEffects)
        {
            if (effectToRemove.name == name)
            {
                _activeEffects.Remove(effectToRemove);
                Destroy(effectToRemove);
            }
        }
    }
}
