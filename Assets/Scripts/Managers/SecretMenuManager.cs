using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SecretMenuManager : MonoBehaviour
{

    [SerializeField] GameObject MenuSecret;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.L))
        {
            Debug.Log("Appui sur L");
            ToggleSecretMenu();
        }
    }

    void ToggleSecretMenu()
    {
        Debug.Log("appel de fct");
        if (MenuSecret.active)
        {
            MenuSecret.SetActive(false);
        } else
        {
            MenuSecret.SetActive(true);
        }
    }
}
