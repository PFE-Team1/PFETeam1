using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class UIManager : MonoBehaviour
{
    public static UIManager Instance;
    void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
        }
        else Destroy(this.gameObject);
    }

    public void Restartlevel()
    {
        Debug.Log("Restarting level...");
        SceneManager.LoadSceneAsync(SceneManager.GetActiveScene().buildIndex);
    }
    private void Update()
    {
        if (InputsManager.instance.InputRestarting)
        {
            Restartlevel();
        }
    }
}
