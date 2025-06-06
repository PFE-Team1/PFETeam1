using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Wwise;

public class LevelMusic : MonoBehaviour
{
    [SerializeField] private AK.Wwise.Event levelMusicEvent;
    void Start()
    {
        if (levelMusicEvent != null)
        {
            levelMusicEvent.Post(gameObject);
        }
        else
        {
            Debug.LogWarning("Level music event is not assigned in the inspector.");
        }
    }

    void OnDisable()
    {
        levelMusicEvent.Stop(gameObject);
    }
}
