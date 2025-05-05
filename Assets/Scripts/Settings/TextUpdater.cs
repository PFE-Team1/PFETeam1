using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class TextUpdater : MonoBehaviour
{
    [SerializeField] private string _key;
    public string Key { get => _key; set => _key = value; }

    void Start()
    {
        GetComponent<TextMeshProUGUI>().text = LanguageManager.instance.Find_Key(_key);
    }

    public void UpdateText()
    {
        GetComponent<TextMeshProUGUI>().text = LanguageManager.instance.Find_Key(_key);
    }
}
