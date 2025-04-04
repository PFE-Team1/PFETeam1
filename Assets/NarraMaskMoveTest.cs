using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NarraMaskMoveTest : MonoBehaviour
{
    Camera _cam;
   [SerializeField]float x;
   [SerializeField]float oldX=-1000000;
   [SerializeField]float diff;
    // Start is called before the first frame update
    void Start()
    {
        _cam = FindObjectOfType<Camera>();
        x = transform.position.x + _cam.transform.position.x;
    }

    // Update is called once per frame
    void Update()
    {

        if (x < transform.position.x + _cam.transform.position.x && oldX < transform.position.x + _cam.transform.position.x)
        {
            diff = x - (transform.position.x + _cam.transform.position.x);
            if (diff > 0)
            {
                return;
            }
            transform.position = new Vector3(transform.position.x+Mathf.Abs(diff), transform.position.y, transform.position.z);
            oldX = x;
        }
        x = transform.position.x + _cam.transform.position.x;


    }
}
