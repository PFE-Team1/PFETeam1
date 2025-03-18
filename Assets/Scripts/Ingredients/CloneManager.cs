using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;


public class CloneManager : MonoBehaviour
{
    // poura être utiliser pour appliquer un état à tout les personnages en même temps ou d'autres choses dans le futur.
    [SerializeField] List<Clone> _characters=new List<Clone>();
    [SerializeField] int _currentPlayer = 0;
    
    public List<Clone> Characters { get => _characters; set => _characters = value; }

    public static CloneManager instance;
    private void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
        else Destroy(this);
    }

    public void Switch(int charID)
    {
        if (_characters.Count <= 0)
        {
            return;
        }
        charID++;
        if (charID >= _characters.Count)
        {
            charID = 0;
        }
        _currentPlayer = charID;
        foreach (Clone c in _characters)
        {
            if (c.CharID != charID)
            {
                c.gameObject.GetComponentInChildren<BoxCollider>().enabled = true;
                c.Switchup(false);
            }
            else
            {
                c.gameObject.GetComponentInChildren<BoxCollider>().enabled = false;
                c.Switchup(true);
            }
        }
    }
}
