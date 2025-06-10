using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static AudioManager;

public class playSoundGameAction : AGameAction
{
    [Header("Sound Settings")]
    [SerializeField]
    private AudioEventType audioEventType = AudioEventType.None;

    protected override void OnEnd()
    {
    }

    protected override void OnExecute()
    {
        AudioManager audioManager = AudioManager.Instance;
        if (audioManager == null)
        {
            Debug.LogWarning("AudioManager instance is null. Please ensure it is initialized before executing this action.");
            return;
        }
        if (audioEventType == AudioEventType.None)
        {
            Debug.LogWarning("AudioEventType is set to None. Please select a valid audio event type.");
            return;
        }
        audioManager.PlayAudioEvent(audioEventType, gameObject);

    }
    protected override void OnUpdate(float deltaTime)
    {
    }
}
