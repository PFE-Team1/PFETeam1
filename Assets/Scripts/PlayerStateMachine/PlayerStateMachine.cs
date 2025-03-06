using System.Collections;
using System.Collections.Generic;
using Unity.IO.LowLevel.Unsafe;
using Unity.VisualScripting;
using UnityEngine;

public class PlayerStateMachine : MonoBehaviour
{
    #region PublicVariables

    public Vector2 Velocity { get; set; }
    public InputsManager InputsManager { get; private set; }

    #endregion

    #region States
    private IdlePlayerState _idleState { get; } = new IdlePlayerState();

    #endregion

    #region CurrentStates
    public PlayerState StartState => _idleState;
    public PlayerState CurrentState { get; private set; }
    public PlayerState PreviousState { get; private set; }

    #endregion

    private void Start()
    {
        InputsManager = InputsManager.Instance;
    }
    void OnGUI()
    {
        if (InputsManager == null) return;
        GUI.Label(new Rect(10, 10, 200, 90), "Move X: " + InputsManager.MoveX);
    }
    public void ChangeState(PlayerState state)
    {
    }
}
