using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Xml;


public class LanguageManager : MonoBehaviour
{
    public static LanguageManager instance;
    [SerializeField] private TMP_Dropdown _languageDropDown;
    [SerializeField] private TextAsset _languageFile;
    [SerializeField] private string _desiredLanguage;
    public string DesiredLanguage { get => _desiredLanguage; set => _desiredLanguage = value; }

    void Awake()
    {
        if (instance == null)
        {
            instance = this;
            DontDestroyOnLoad(gameObject);
        }
    }

    public string Find_Key(string key)
    {
        string value;
        string[] languages = _languageFile.text.Split('\n')[0].Split(',');
        foreach (var keys in _languageFile.text.Split('\n'))
        {
            if (keys.Split(',')[1] == key)
            {
                value = keys.Split(',')[Array.IndexOf(languages, _desiredLanguage)];
                return value;
            }
        }
        value = "Key not found";
        return value;
    }

    public void SetAllTextToLanguage()
    {
        _desiredLanguage = _languageDropDown.options[_languageDropDown.value].text;
        foreach (var text in FindObjectsByType<TextUpdater>(FindObjectsSortMode.None))
        {
            if (text.GetComponent<TextUpdater>() != null)
            {
                text.GetComponent<TextUpdater>().UpdateText();
            }
        }
    }
}
