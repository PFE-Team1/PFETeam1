using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class AutoScrollToSelected : MonoBehaviour
{
    public ScrollRect scrollRect;
    public float padding = 20f; // Marge en pixels pour éviter bord à bord
    public float smoothSpeed = 10f; // Vitesse de scroll

    RectTransform content;
    RectTransform viewport;

    void Awake()
    {
        content = scrollRect.content;
        viewport = scrollRect.viewport;
    }

    void Update()
    {
        GameObject selected = EventSystem.current.currentSelectedGameObject;
        Debug.Log($"Selected GameObject: {selected?.name}");

        if (selected == null || !selected.transform.IsChildOf(content))
            return;

        RectTransform selectedRect = selected.GetComponent<RectTransform>();
        if (selectedRect == null)
            return;

        // Convertir la position de l'élément sélectionné dans le viewport
        Vector3 worldPos = selectedRect.position;
        Vector3 localPos = viewport.InverseTransformPoint(worldPos);

        float viewportHeight = viewport.rect.height;

        // Bord supérieur et inférieur de l'élément sélectionné
        float elementTop = localPos.y + selectedRect.rect.height / 2;
        float elementBottom = localPos.y - selectedRect.rect.height / 2;

        float upperBound = viewportHeight / 2 - padding;
        float lowerBound = -viewportHeight / 2 + padding;

        float delta = 0f;

        if (elementTop > upperBound)
            delta = elementTop - upperBound;
        else if (elementBottom < lowerBound)
            delta = elementBottom - lowerBound;

        if (Mathf.Abs(delta) > 0.01f)
        {
            // Scroll proportionnel au contenu
            float scrollDelta = delta / (content.rect.height - viewport.rect.height);
            scrollRect.verticalNormalizedPosition -= scrollDelta * Time.unscaledDeltaTime * smoothSpeed;
        }
    }
}
