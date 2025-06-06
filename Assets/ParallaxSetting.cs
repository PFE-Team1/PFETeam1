using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using TMPro;

public class ParallaxSetting : MonoBehaviour
{
    [SerializeField] private string[] textChoices;
    private int currentChoiceIndex = 0;
    [SerializeField] private TextMeshProUGUI textDisplay;

    void Start()
    {
        textDisplay.text = textChoices[currentChoiceIndex];
    }

    public void ChangeSetting()
    {
        SetParallax();
        currentChoiceIndex = SettingsManager.Instance.WantParallax ? 1 : 0;
        textDisplay.text = textChoices[currentChoiceIndex];
    }

    public void SetParallax()
    {
        SettingsManager.Instance.WantParallax = !SettingsManager.Instance.WantParallax;
    }
}
