using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Audio;
using Unity.VisualScripting;

public class AudioManager : MonoBehaviour
{
    public static AudioManager Instance { get; private set; }

    [SerializeField] private UnityEvent MSC_Niveau1;

    void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
        }
        else
        {
            Destroy(gameObject);
            return;
        }
    }

    void Start()
    {
        MSC_Niveau1.Invoke();
    }

    public void PlaySound(AudioClip clip)
    {
        GameObject audioObject = Instantiate(new GameObject());
        audioObject.name = clip.name;
        AudioSource audioSource = audioObject.AddComponent<AudioSource>();
        audioSource.clip = clip;
        audioSource.Play();
        StartCoroutine(DestroySound(audioObject));
    }

    IEnumerator DestroySound(GameObject audioObject)
    {
        yield return new WaitForSeconds(audioObject.GetComponent<AudioSource>().clip.length);
        Destroy(audioObject);
    }

    public void PlaySoundLoop(AudioClip clip)
    {
        GameObject audioObject = Instantiate(new GameObject());
        AudioSource audioSource = audioObject.AddComponent<AudioSource>();
        audioSource.clip = clip;
        audioSource.loop = true;
        audioSource.Play();
    }
}
