using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;


public class CloneManager : MonoBehaviour
{
    // poura �tre utiliser pour appliquer un �tat � tout les personnages en m�me temps ou d'autres choses dans le futur.
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
        bool mustSkip = true;
        if (_characters.Count <= 1)
        {
            return;
        }
        
        while (mustSkip == true)
        {
            charID++;
            if (charID >= _characters.Count)
            {
                charID = 0;
            }
            mustSkip = Skip(charID);
        }
        _characters[charID].Switchup(true);
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
            }
        }
    }
    private bool Skip(int charID)
    {
        bool mustSkip = true;
        if (_characters[charID].transform.parent.gameObject.activeInHierarchy)
        {
            mustSkip = false;
        }
        return mustSkip;
    }
}
