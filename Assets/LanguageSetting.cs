using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class LanguageSetting : MonoBehaviour
{
    [SerializeField] private string[] supportedLanguages = { "English", "French", "Spanish" };
    private int currentChoiceIndex = 0;
    [SerializeField] private TextMeshProUGUI textDisplay;

    void Start()
    {
        currentChoiceIndex = GetLanguageIndex(LanguageManager.instance.DesiredLanguage);
        textDisplay.text = supportedLanguages[currentChoiceIndex];
    }

    public void ChangeSetting()
    {
        SetLanguage();
        currentChoiceIndex = GetLanguageIndex(LanguageManager.instance.DesiredLanguage);
        textDisplay.text = supportedLanguages[currentChoiceIndex];
    }

    public void SetLanguage()
    {
        currentChoiceIndex = (currentChoiceIndex + 1) % supportedLanguages.Length;
        LanguageManager.instance.DesiredLanguage = supportedLanguages[currentChoiceIndex];
        LanguageManager.instance.SetAllTextToLanguage();
    }

    private int GetLanguageIndex(string language)
    {
        for (int i = 0; i < supportedLanguages.Length; i++)
        {
            if (supportedLanguages[i] == language)
                return i;
        }
        return 0; // Default to English
    }
}
