using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UICurrentPlayer : MonoBehaviour
{
    public CanvasGroup CanvasGroup;

    private Image image;
    private void Awake()
    {
        CanvasGroup.alpha = 0;
        image = GetComponentInChildren<Image>();
        if (image == null)
        {
            Debug.LogWarning("No Image component found on the player, can't switch profile");
            return;
        }
        CanvasGroup.transform.DOLocalMoveY(4, 2f).SetLoops(-1, LoopType.Yoyo).SetEase(Ease.InOutSine);
    }
}
