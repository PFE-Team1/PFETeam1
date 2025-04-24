using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DoorMaterialInstance : MonoBehaviour
{
    private Material _material;
    [SerializeField]private Renderer _renderer;
    // Start is called before the first frame update
    void Awake()
    {
        _material = _renderer.material;
    }
    
    IEnumerator InversingPath()
    {
        yield return new WaitForSeconds(1);
        Vector4 vector = _material.GetVector("_Trail_Speed");
        Vector4 newVector=new Vector4();
        float timer = 3;
        while (timer > 0)
        {
            float val = Mathf.Lerp(-1, 1, timer / 3);
            newVector = new Vector4(vector.x*val, 0, 0, 0);
            _material.SetVector("_Trail_Speed", newVector);
            timer -= Time.deltaTime;
            yield return null;
        }
        yield return null;
    }

public void InversePath()
    {
        StartCoroutine(InversingPath());
    }
}
