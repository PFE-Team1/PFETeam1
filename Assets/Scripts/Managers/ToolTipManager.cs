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

    public Sprite KeyboardIcon;
    public Sprite ControllerIcon;

    private CanvasGroup CanvasGroup;

    private void Start()
    {
        CanvasGroup = GetComponent<CanvasGroup>();
        CanvasGroup.alpha = 0;
        CanvasGroup.transform.DOLocalMoveY(4, 2f).SetLoops(-1, LoopType.Yoyo).SetEase(Ease.InOutSine);
        EventManager.instance.OnInput.AddListener(ChangeIconDependingOnController);
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

    private void ChangeIconDependingOnController()
    {
        if (KeyboardIcon == null)
        {
            return;
        }
        KeyIcon.sprite = InputsManager.instance.IsKeyboard ? KeyboardIcon : ControllerIcon;
    }
}
