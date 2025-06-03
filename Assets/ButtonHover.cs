using System.Collections;
using System.Collections.Generic;
using UnityEngine.EventSystems;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System;

public class ButtonHover : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
{
    [SerializeField] private Sprite clearButtonImage;
    [SerializeField] private Image[] choiceImage;
    Sprite selectedButtonImage;
    Image currentButtonImage;
    TextMeshProUGUI[] buttonText;

    void Start()
    {
        selectedButtonImage = GetComponentInChildren<Image>().sprite;
        currentButtonImage = GetComponentInChildren<Image>();
        buttonText = GetComponentsInChildren<TextMeshProUGUI>();
        if (selectedButtonImage == null)
        {
            Debug.LogWarning("Aucun composant Image trouvé sur cet objet.");
        }
        currentButtonImage.sprite = clearButtonImage;
        foreach (TextMeshProUGUI text in buttonText)
        {
            if (text != null)
            {
                text.color = new Color32(87, 77, 66, 255);
            }
        }
        foreach (Image image in choiceImage)
        {
            if (image != null)
            {
                image.color = new Color32(87, 77, 66, 255);
            }
        }
    }
    public void OnPointerEnter(PointerEventData eventData)
    {
        if (selectedButtonImage != null)
        {
            currentButtonImage.sprite = selectedButtonImage;
        }
        if (buttonText != null)
        {
            foreach (TextMeshProUGUI text in buttonText)
            {
                if (text != null)
                {
                    text.color = new Color32(234, 215, 190, 255);
                }
            }
        }
        if (choiceImage != null)
        {
            foreach (Image image in choiceImage)
            {
                if (image != null)
                {
                    image.color = new Color32(234, 215, 190, 255);
                }
            }
        }
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        if (selectedButtonImage != null)
        {
            currentButtonImage.sprite = clearButtonImage;
        }
        if (buttonText != null)
        {
            foreach (TextMeshProUGUI text in buttonText)
            {
                if (text != null)
                {
                    text.color = new Color32(87, 77, 66, 255);
                }
            }
        }
        if (choiceImage != null)
        {
            foreach (Image image in choiceImage)
            {
                if (image != null)
                {
                    image.color = new Color32(87, 77, 66, 255);
                }
            }
        }
    }
}
