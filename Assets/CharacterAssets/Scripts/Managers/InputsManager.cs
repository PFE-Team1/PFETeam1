using MoreMountains.Feedbacks;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;


public class InputsManager : MonoBehaviour
{
    // Start is called before the first frame update

    //Input Manager Singleton

    public static InputsManager Instance;
    public PlayerInputManager _playerInputManager => GetComponent<PlayerInputManager>();
    public List<PlayersInputs> playerInputs = new List<PlayersInputs>();
    public GameObject playerPrefab;

    private GameObject lastSelected;
    public class PlayersInputs
    {
        public PlayerInputs _playerInputs;
        public PlayerStateMachine _playerStateMachine;
        
        public PlayersInputs(PlayerInputs playerInputs, PlayerStateMachine playerStateMachine)
        {
            _playerInputs = playerInputs;
            _playerStateMachine = playerStateMachine;
        }
    }
    void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
        }
        else Destroy(this.gameObject);
    }

    void Start()
    {
        _playerInputManager.playerPrefab = playerPrefab;
    }
    public void resetPlayers()
    {
        foreach(PlayerInputs pi in GetComponents<PlayerInputs>())
        {
            Destroy(pi);
        }
    }
}
