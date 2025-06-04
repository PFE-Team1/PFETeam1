using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UIElements;

public class UIToolTipZone : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField]
    private Sprite KeyboardIcon;
    [SerializeField]
    private Sprite ControllerIcon;
    [SerializeField]
    private bool ShouldDestroyOnExit = false;

    private InputsManager _inputsManager;
    private List<GameObject> _CollidingGameObjects;
    private ToolTipManager _toolTipManager;
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
        _toolTipManager = other.GetComponentInChildren<ToolTipManager>();
        if (!_CollidingGameObjects.Contains(other.gameObject))
        {
            _CollidingGameObjects.Add(other.gameObject);
        }

        if (_toolTipManager != null)
        {
            _toolTipManager.InsideZone = true;
            _toolTipManager.KeyboardIcon = KeyboardIcon;
            _toolTipManager.ControllerIcon = ControllerIcon;

        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (ShouldDestroyOnExit)
        {
            EventManager.instance.OnInput.RemoveAllListeners();
            Destroy(gameObject);
            return;
        }
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
        foreach (GameObject gameObject in _CollidingGameObjects.Where(gameObject => gameObject != null))
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
        foreach (GameObject gameObject in _CollidingGameObjects.Where(gameObject=>gameObject!=null))
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
