using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationManager : MonoBehaviour
{
    [SerializeField] Animator a;
    bool _a;


    private void Start()
    {
        _a = a.GetBool("A");
        Change();
    }

    private IEnumerator Change()
    {
        yield return new WaitForSeconds(1);
        _a = !_a;
        a.SetBool("A",_a);
    }
}
