using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using TMPro;

public class ShakeSetting : MonoBehaviour
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
        SetShake();
        currentChoiceIndex = SettingsManager.Instance.WantScreenShake ? 1 : 0;
        textDisplay.text = textChoices[currentChoiceIndex];
    }

    public void SetShake()
    {
        SettingsManager.Instance.WantScreenShake = !SettingsManager.Instance.WantScreenShake;
    }
}
