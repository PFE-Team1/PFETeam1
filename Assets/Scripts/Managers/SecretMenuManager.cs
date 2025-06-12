using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SecretMenuManager : MonoBehaviour
{
    [SerializeField] GameObject MenuSecret;

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.L))
        {
            ToggleSecretMenu();
        }
    }

    void ToggleSecretMenu()
    {
        if (MenuSecret.activeSelf)
        {
            MenuSecret.SetActive(false);
        } else
        {
            MenuSecret.SetActive(true);
        }
    }
}
