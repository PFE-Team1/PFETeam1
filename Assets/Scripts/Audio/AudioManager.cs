using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Audio;
using Unity.VisualScripting;

public class AudioManager : MonoBehaviour
{
    public static AudioManager Instance { get; private set; }

    [Header("Déplacement")]
    public AK.Wwise.Event FOL_Pas;
    public AK.Wwise.Event FOL_Saut;
    public AK.Wwise.Event FOL_Atterissage;

    [Header("Camera")]
    public AK.Wwise.Event SFX_Zoom;
    public AK.Wwise.Event SFX_Dezoom;

    [Header("Clone")]
    public AK.Wwise.Event SFX_CreateClone;
    public AK.Wwise.Event SFX_SwitchClone;
    public AK.Wwise.Event CameraShake;

    [Header("Painting")]
    public AK.Wwise.Event SFX_ApparitionToile;
    public AK.Wwise.Event SFX_DisparitionToile;
    public AK.Wwise.Event SFX_DécalageToile;
    public AK.Wwise.Event SFX_GrabToile;
    public AK.Wwise.Event SFX_PoseToile;
    public AK.Wwise.Event SFX_ConnexionToile;
    public AK.Wwise.Event SFX_SwitchToile;

    [Header("Mur")]
    public AK.Wwise.Event SFX_OuvertureMur;
    public AK.Wwise.Event SFX_Scintillement;
    public AK.Wwise.Event SFX_ReformationToile;
    public AK.Wwise.Event SFX_Déchirure;

    [Header ("UI")]
    public AK.Wwise.Event SUI_PressAnyKey;
    public AK.Wwise.Event SUI_CliqueValidationBouton;
    public AK.Wwise.Event SUI_SurvolBouton;
    public AK.Wwise.Event SUI_Pause;
    public AK.Wwise.Event SUI_Play;
    public AK.Wwise.Event SFX_RestartLevel;

    [Header ("Musique")]
    public AK.Wwise.Event MSC_Menu;
    public AK.Wwise.Event MSC_Niveau1_Globale;
    public AK.Wwise.Event MSC_Niveau2_Globale;
    public AK.Wwise.Event AMB_NiveauTuto;
    public AK.Wwise.Event AMB_Niveau15;
    public enum AudioEventType
    {
        FOL_Pas,
        FOL_Saut,
        FOL_Atterissage,
        SFX_Zoom,
        SFX_Dezoom,
        SFX_CreateClone,
        SFX_SwitchClone,
        CameraShake,
        SFX_ApparitionToile,
        SFX_DisparitionToile,
        SFX_DécalageToile,
        SFX_GrabToile,
        SFX_PoseToile,
        SFX_ConnexionToile,
        SFX_SwitchToile,
        SFX_OuvertureMur,
        SFX_Scintillement,
        SFX_ReformationToile,
        SFX_Déchirure,
        SUI_PressAnyKey,
        SUI_CliqueValidationBouton,
        SUI_SurvolBouton,
        SUI_Pause,
        SUI_Play,
        SFX_RestartLevel,
        MSC_Menu,
        MSC_Niveau1_Globale,
        MSC_Niveau2_Globale,
        AMB_NiveauTuto,
        AMB_Niveau15,
        None
    }

    public void PlayAudioEvent(AudioEventType eventType, GameObject gameObject)
    {
        switch (eventType)
        {
            case AudioEventType.FOL_Pas:
                FOL_Pas.Post(gameObject);
                break;
            case AudioEventType.FOL_Saut:
                FOL_Saut.Post(gameObject);
                break;
            case AudioEventType.FOL_Atterissage:
                FOL_Atterissage.Post(gameObject);
                break;
            case AudioEventType.SFX_Zoom:
                SFX_Zoom.Post(gameObject);
                break;
            case AudioEventType.SFX_Dezoom:
                SFX_Dezoom.Post(gameObject);
                break;
            case AudioEventType.SFX_CreateClone:
                SFX_CreateClone.Post(gameObject);
                break;
            case AudioEventType.SFX_SwitchClone:
                SFX_SwitchClone.Post(gameObject);
                break;
            case AudioEventType.CameraShake:
                CameraShake.Post(gameObject);
                break;
            case AudioEventType.SFX_ApparitionToile:
                SFX_ApparitionToile.Post(gameObject);
                break;
            case AudioEventType.SFX_DisparitionToile:
                SFX_DisparitionToile.Post(gameObject);
                break;
            case AudioEventType.SFX_DécalageToile:
                SFX_DécalageToile.Post(gameObject);
                break;
            case AudioEventType.SFX_GrabToile:
                SFX_GrabToile.Post(gameObject);
                break;
            case AudioEventType.SFX_PoseToile:
                SFX_PoseToile.Post(gameObject);
                break;
            case AudioEventType.SFX_ConnexionToile:
                SFX_ConnexionToile.Post(gameObject);
                break;
            case AudioEventType.SFX_SwitchToile:
                SFX_SwitchToile.Post(gameObject);
                break;
            case AudioEventType.SFX_OuvertureMur:
                SFX_OuvertureMur.Post(gameObject);
                break;
            case AudioEventType.SFX_Scintillement:
                SFX_Scintillement.Post(gameObject);
                break;
            case AudioEventType.SFX_ReformationToile:
                SFX_ReformationToile.Post(gameObject);
                break;
            case AudioEventType.SFX_Déchirure:
                SFX_Déchirure.Post(gameObject);
                break;
            case AudioEventType.SUI_PressAnyKey:
                SUI_PressAnyKey.Post(gameObject);
                break;
            case AudioEventType.SUI_CliqueValidationBouton:
                SUI_CliqueValidationBouton.Post(gameObject);
                break;
            case AudioEventType.SUI_SurvolBouton:
                SUI_SurvolBouton.Post(gameObject);
                break;
            case AudioEventType.SUI_Pause:
                SUI_Pause.Post(gameObject);
                break;
            case AudioEventType.SUI_Play:
                SUI_Play.Post(gameObject);
                break;
            case AudioEventType.SFX_RestartLevel:
                SFX_RestartLevel.Post(gameObject);
                break;
            case AudioEventType.MSC_Menu:
                MSC_Menu.Post(gameObject);
                break;
            case AudioEventType.MSC_Niveau1_Globale:
                MSC_Niveau1_Globale.Post(gameObject);
                break;
            case AudioEventType.MSC_Niveau2_Globale:
                MSC_Niveau2_Globale.Post(gameObject);
                break;
            case AudioEventType.AMB_NiveauTuto:
                AMB_NiveauTuto.Post(gameObject);
                break;
            case AudioEventType.AMB_Niveau15:
                AMB_Niveau15.Post(gameObject);
                break;
            default:
                Debug.LogWarning("Audio event type not recognized.");
                break;
        }
    }



    void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
            return;
        }
    }
}
