using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class AutoScrollToSelected : MonoBehaviour
{
    [SerializeField] private ScrollRect scrollRect;
    [SerializeField] private RectTransform content;
    [SerializeField] private float topMargin = 30f;

    private void Update()
    {
        GameObject selected = EventSystem.current.currentSelectedGameObject;
        if (selected == null || selected.transform.parent != content) return;

        RectTransform selectedRect = selected.GetComponent<RectTransform>();
        if (selectedRect == null) return;

        ScrollToElement(selectedRect);
    }

    private void ScrollToElement(RectTransform target)
    {
        Canvas.ForceUpdateCanvases();

        RectTransform viewport = scrollRect.viewport;

        float contentHeight = content.rect.height;
        float viewportHeight = viewport.rect.height;

        float targetY = Mathf.Abs(target.localPosition.y);

        targetY -= topMargin;

        float normalizedPosition = 1 - Mathf.Clamp01(targetY / (contentHeight - viewportHeight));
        scrollRect.verticalNormalizedPosition = normalizedPosition;
    }

}
