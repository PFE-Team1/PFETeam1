using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.VFX;

public class VFXManager : MonoBehaviour
{
    // Start is called before the first frame update
    private List<GameObject> _visualEffects=new List<GameObject>();
    void Start()
    {
        
    }
    // Update is called once per frame
    void Update()
    {
        
    }
    public void PlayVFXAt(Vector3 where,int id)
    {
        if (id>=_visualEffects.Count) return;
        GameObject vfx=Instantiate(_visualEffects[id], where, transform.rotation);
        vfx.GetComponent<VisualEffect>().Play();
    }
}
