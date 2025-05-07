using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class ToolTipManager : MonoBehaviour
{
    public bool InsideZone = false;
    public float Speed = 1f;
    public Image KeyIcon;

    private CanvasGroup CanvasGroup;

    private void Start()
    {
        CanvasGroup = GetComponent<CanvasGroup>();
        CanvasGroup.alpha = 0;
        CanvasGroup.transform.DOLocalMoveY(4, 2f).SetLoops(-1, LoopType.Yoyo).SetEase(Ease.InOutSine);
    }

    private void Update()
    {
        if (InsideZone)
        {
            CanvasGroup.alpha = Mathf.MoveTowards(CanvasGroup.alpha, 1, Speed * Time.deltaTime);
        }
        else
        {
            CanvasGroup.alpha = Mathf.MoveTowards(CanvasGroup.alpha, 0, Speed * Time.deltaTime);
        }
    }
}
