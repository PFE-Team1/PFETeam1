using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.VFX;

public class VFXManager : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField]private List<GameObject> _visualEffects=new List<GameObject>();
    private List<GameObject> _activeEffects=new List<GameObject>();
    public static VFXManager instance;
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
    public void PlayJumpVFXAt(Vector3 where)
    {
        GameObject vfx=Instantiate(_visualEffects[0], where, transform.rotation);
        StartCoroutine(StopVFX(vfx));
    }
    IEnumerator  StopVFX(GameObject vfx)
    {
        yield return new WaitForSeconds(1);
        Destroy(vfx);
        yield return null;
    }

}
