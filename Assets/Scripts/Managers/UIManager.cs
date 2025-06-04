using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using DG.Tweening;
using NaughtyAttributes;

public class UIManager : MonoBehaviour
{
    public static UIManager Instance;
    public RectTransform UpDownLetterBox;
    public RectTransform LeftRightLetterBox;
    private RectTransform _canvasRectTransform;

    void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
        }
        else Destroy(this.gameObject);
    }

    private void Start()
    {
        _canvasRectTransform = GetComponent<RectTransform>();

        if (UpDownLetterBox != null)
        {
            float currentRight = UpDownLetterBox.offsetMax.x;
            UpDownLetterBox.anchorMin = new Vector2(UpDownLetterBox.anchorMin.x, 0f);
            UpDownLetterBox.anchorMax = new Vector2(UpDownLetterBox.anchorMax.x, 1f);
            UpDownLetterBox.offsetMin = new Vector2(UpDownLetterBox.offsetMin.x, 0f);
            UpDownLetterBox.offsetMax = new Vector2(currentRight, 0f);
        }

        if (LeftRightLetterBox != null)
        {
            float currentTop = LeftRightLetterBox.offsetMax.y;
            float currentBottom = LeftRightLetterBox.offsetMin.y;
            LeftRightLetterBox.anchorMin = new Vector2(0f, LeftRightLetterBox.anchorMin.y);
            LeftRightLetterBox.anchorMax = new Vector2(1f, LeftRightLetterBox.anchorMax.y);
            LeftRightLetterBox.offsetMin = new Vector2(0f, currentBottom);
            LeftRightLetterBox.offsetMax = new Vector2(0f, currentTop);
        }
    }
    public Tween TweenUpDownLetterBoxHeight(float ratio, float duration = 1f, Ease ease = Ease.OutQuad)
    {
        if (UpDownLetterBox == null || _canvasRectTransform == null) return null;

        // Calculer la hauteur cible basée sur le ratio
        float canvasHeight = _canvasRectTransform.rect.height;
        float targetHeight = canvasHeight * Mathf.Clamp01(ratio);

        // Calculer les nouveaux offsets pour centrer la letterbox
        float offsetFromCenter = (canvasHeight - targetHeight) * 0.5f;

        return DOTween.To(
            () => new Vector2(UpDownLetterBox.offsetMin.y, UpDownLetterBox.offsetMax.y),
            (value) => {
                UpDownLetterBox.offsetMin = new Vector2(UpDownLetterBox.offsetMin.x, value.x);
                UpDownLetterBox.offsetMax = new Vector2(UpDownLetterBox.offsetMax.x, -value.y);
            },
            new Vector2(offsetFromCenter, offsetFromCenter),
            duration
        ).SetEase(ease);
    }

    public Tween TweenOutUpDownLetterBox(float duration = 1f, Ease ease = Ease.OutQuad)
    {
        if (UpDownLetterBox == null) return null;

        return DOTween.To(
            () => new Vector2(UpDownLetterBox.offsetMin.y, UpDownLetterBox.offsetMax.y),
            (value) => {
                UpDownLetterBox.offsetMin = new Vector2(UpDownLetterBox.offsetMin.x, value.x);
                UpDownLetterBox.offsetMax = new Vector2(UpDownLetterBox.offsetMax.x, value.y);
            },
            new Vector2(0f, 0f), // Position normale : pleine hauteur
            duration
        ).SetEase(ease);
    }

    public Tween TweenLeftRightLetterBoxWidth(float ratio, float duration = 1f, Ease ease = Ease.OutQuad)
    {
        if (LeftRightLetterBox == null || _canvasRectTransform == null) return null;

        // Calculer la largeur cible basée sur le ratio
        float canvasWidth = _canvasRectTransform.rect.width;
        float targetWidth = canvasWidth * Mathf.Clamp01(ratio);

        // Calculer les nouveaux offsets pour centrer la letterbox
        float offsetFromCenter = (canvasWidth - targetWidth) * 0.5f;

        return DOTween.To(
            () => new Vector2(LeftRightLetterBox.offsetMin.x, LeftRightLetterBox.offsetMax.x),
            (value) => {
                LeftRightLetterBox.offsetMin = new Vector2(value.x, LeftRightLetterBox.offsetMin.y);
                LeftRightLetterBox.offsetMax = new Vector2(-value.y, LeftRightLetterBox.offsetMax.y);
            },
            new Vector2(offsetFromCenter, offsetFromCenter),
            duration
        ).SetEase(ease);
    }
    public Tween TweenOutLeftRightLetterBox(float duration = 1f, Ease ease = Ease.OutQuad)
    {
        if (LeftRightLetterBox == null) return null;

        return DOTween.To(
            () => new Vector2(LeftRightLetterBox.offsetMin.x, LeftRightLetterBox.offsetMax.x),
            (value) => {
                LeftRightLetterBox.offsetMin = new Vector2(value.x, LeftRightLetterBox.offsetMin.y);
                LeftRightLetterBox.offsetMax = new Vector2(value.y, LeftRightLetterBox.offsetMax.y);
            },
            new Vector2(0f, 0f), // Position normale : pleine largeur
            duration
        ).SetEase(ease);
    }


    // create naughty attributes buttons to test the letterbox effects
    [Button("Test UpDown LetterBox")]
    public void TestUpDownLetterBox()
    {
        TweenUpDownLetterBoxHeight(0.7f, 1f, Ease.OutQuad);
    }
    [Button("Test Out UpDown LetterBox")]
    public void TestOutUpDownLetterBox()
    {
        TweenOutUpDownLetterBox(1f, Ease.OutQuad);
    }
    [Button("Test LeftRight LetterBox")]
    public void TestLeftRightLetterBox()
    {
        TweenLeftRightLetterBoxWidth(0.7f, 1f, Ease.OutQuad);
    }
    [Button("Test Out LeftRight LetterBox")]
    public void TestOutLeftRightLetterBox()
    {
        TweenOutLeftRightLetterBox(1f, Ease.OutQuad);
    }
}