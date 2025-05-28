using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using TMPro;

public class ButtonValidation : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
{
    private Button button;

    void Awake()
    {
        button = GetComponent<Button>();
        if (button == null)
        {
            Debug.LogWarning("Aucun composant Button trouvé sur cet objet.");
        }
    }

    public void OnButtonClick()
    {
        AudioManager.Instance.SUI_CliqueValidationBouton.Post(gameObject);
    }

    void Start()
    {
        if (button != null)
        {
            button.onClick.AddListener(OnButtonClick);
        }
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        AudioManager.Instance.SUI_SurvolBouton.Post(gameObject);
        gameObject.GetComponentInChildren<TextMeshProUGUI>().color = new Color32(234, 215, 190, 255);
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        gameObject.GetComponentInChildren<TextMeshProUGUI>().color = new Color32(87, 77, 66, 255);
    }
}
    