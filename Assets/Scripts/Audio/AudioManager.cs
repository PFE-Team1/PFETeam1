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
