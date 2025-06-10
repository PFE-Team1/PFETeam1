using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;


public class CloneManager : MonoBehaviour
{
    // poura �tre utiliser pour appliquer un �tat � tout les personnages en m�me temps ou d'autres choses dans le futur.
    [SerializeField] List<Clone> _characters = new List<Clone>();
    [SerializeField] int _currentPlayer = 0;

    public List<Clone> Characters { get => _characters; set => _characters = value; }
    public int CurrentPlayer { get => _currentPlayer; }

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
        AudioManager.Instance.SFX_SwitchClone.Post(gameObject);
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
        foreach (Clone c in _characters)
        {
            PlayerStateMachine playerStateMachine = c.GetComponent<PlayerStateMachine>();
            if (c.CharID != charID)
            {
                playerStateMachine.ChangeState(playerStateMachine.CloneState);
                c.gameObject.GetComponent<BoxCollider>().enabled = true;
                c.gameObject.GetComponentInChildren<UICurrentPlayer>().CanvasGroup.DOFade(0, 0.5f);
                c.Switchup(false);
            }
            else
            {
                playerStateMachine.ChangeState(playerStateMachine.IdleState);
                c.gameObject.GetComponent<UICurrentPlayer>().CanvasGroup.DOFade(1, 0.5f);
                c.gameObject.GetComponentInChildren<BoxCollider>().enabled = false;
            }
        }
        _currentPlayer = charID;
    }
    private bool Skip(int charID)
    {
        Debug.Log($"Skip {charID}");
        bool mustSkip = true;
        if (_characters[charID].isActiveAndEnabled)
        {
            mustSkip = false;
        }
        return mustSkip;
    }

    public PlayerStateMachine GetCurrentStateMachine()
    {
        if (_characters.Count == 0) return null;
        PlayerStateMachine currentStateMachine = _characters[_currentPlayer].GetComponent<PlayerStateMachine>();
        if (currentStateMachine == null)
        {
            Debug.LogError("Current player does not have a PlayerStateMachine component.");
            return null;
        }
        else
        {
            return currentStateMachine;
        }
    }
}
