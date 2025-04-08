using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;

public class EndProto : MonoBehaviour
{
    private Clone _playerC;
    public bool isInRange;
    private string _sceneToLoad;

    // Start is called before the first frame update
    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            _playerC = other.GetComponent<Clone>();
            isInRange = true;
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            _playerC = null;
            isInRange = false;
        }
    }
    // Update is called once per frame
    void Update()
    {
        if (isInRange)
        {
            if (_playerC.IsInteracting)
            {
                _playerC.IsInteracting = false;
                SceneManager.LoadScene(_sceneToLoad);
            }
        }
    }
}

