using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MusicScene : MonoBehaviour
{
    [SerializeField] private string _additiveScene;

    void OnEnable()
    {
        if (SceneManager.GetActiveScene().name != _additiveScene)
        {
            SceneManager.LoadScene(_additiveScene, LoadSceneMode.Additive);
        }
    }
}
