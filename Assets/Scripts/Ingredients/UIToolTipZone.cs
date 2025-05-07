using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIToolTipZone : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField]
    public string KeyName;

    private InputsManager _inputsManager;
    private List<GameObject> _CollidingGameObjects;
    void Start()
    {
        _inputsManager = InputsManager.instance;
        _CollidingGameObjects = new List<GameObject>();
        if (_inputsManager == null)
        {
            Debug.LogWarning("No InputsManager found in the scene, can't switch profile");
            return;
        }
        // Récupère le box collider, si il n'est pas la, return et warn l'utilisateur
        BoxCollider boxCollider = GetComponent<BoxCollider>();
        if (boxCollider == null)
        {
            Debug.LogWarning("No BoxCollider found on the player, can't switch profile");
            return;
        }
    }
    private void OnTriggerEnter(Collider other)
    {
        // Trouve dans les objets de l'enfant le premier ToolTipManager
        ToolTipManager toolTipManager = other.GetComponentInChildren<ToolTipManager>();
        if (!_CollidingGameObjects.Contains(other.gameObject))
        {
            _CollidingGameObjects.Add(other.gameObject);
        }

        if (toolTipManager != null)
        {
            toolTipManager.InsideZone = true;
            toolTipManager.KeyIcon.sprite = _inputsManager.UIKeyIconsSet.GetKeyIcon(KeyName).KeyboardIcon;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        ToolTipManager toolTipManager = other.GetComponentInChildren<ToolTipManager>();
        if (_CollidingGameObjects.Contains(other.gameObject))
        {
            _CollidingGameObjects.Remove(other.gameObject);
        }
        if (toolTipManager != null)
        {
            toolTipManager.InsideZone = false;
        }
    }

    private void OnDestroy()
    {
        foreach (GameObject gameObject in _CollidingGameObjects)
        {
            ToolTipManager toolTipManager = gameObject.GetComponentInChildren<ToolTipManager>();
            if (toolTipManager != null)
            {
                toolTipManager.InsideZone = false;
            }
        }
        _CollidingGameObjects.Clear();
    }

    private void OnDisable()
    {
        foreach (GameObject gameObject in _CollidingGameObjects)
        {
            ToolTipManager toolTipManager = gameObject.GetComponentInChildren<ToolTipManager>();
            if (toolTipManager != null)
            {
                toolTipManager.InsideZone = false;
            }
        }
        _CollidingGameObjects.Clear();
    }
}
