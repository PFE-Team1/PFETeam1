using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using CollisionHelper;
using Unity.IO.LowLevel.Unsafe;
using Unity.VisualScripting;
using UnityEditorInternal;
using UnityEngine;
using UnityEngine.UIElements;
using Color = UnityEngine.Color;

public class PlayerStateMachine : MonoBehaviour
{
    #region PublicVariables

    #region InspectorVariables

    public bool DebugMode = true;
    public PlayerMovementParameters PlayerMovementParameters;

    #endregion
    #region NonInspectorVariables
    [HideInInspector]
    public CollisionDetector.CollisionInfo CollisionInfo;
    [HideInInspector]
    public Vector2 Velocity;
    [HideInInspector]
    public InputsManager InputsManager { get; private set; }
    #endregion
    #endregion
    #region PrivateVariables
    private CharacterController _CharacterController => GetComponent<CharacterController>();
    #endregion
    #region States

    #region privateStates
    private IdlePlayerState _idleState { get; } = new IdlePlayerState();
    private FallingPlayerState _fallingState { get; } = new FallingPlayerState();
    #endregion

    #region Accessors
    public IdlePlayerState IdleState => _idleState;
    public FallingPlayerState FallingState => _fallingState;
    #endregion
    public PlayerState[] AllStates => new PlayerState[]
    {
        _idleState,
        _fallingState,
    };

    #endregion

    #region CurrentStates
    private PlayerState StartState => _idleState;
    private PlayerState CurrentState { get; set; }
    private PlayerState PreviousState { get; set; }

    #endregion

    #region Debug
    void OnGUI()
    {
        if (InputsManager == null || !DebugMode) return;

        GUIStyle style = new GUIStyle();
        style.normal.textColor = Color.white;
        style.fontSize = 14;
        style.fontStyle = FontStyle.Bold;

        // Cr�er le fond
        GUI.backgroundColor = new Color(0, 0, 0, 0.7f);
        GUI.Box(new Rect(10, 10, 200, 160), "");

        string debugText = "";
        debugText += "Current State: " + CurrentState.GetType().Name + "\n";
        debugText += "Move X: " + InputsManager.MoveX + "\n";
        debugText += "Velocity: " + Velocity.ToString("F2") + "\n";
        debugText += "\n";
        debugText += "Gauche: " + CollisionInfo.isCollidingLeft + "\n";
        debugText += "Droite: " + CollisionInfo.isCollidingRight + "\n";
        debugText += "Haut: " + CollisionInfo.isCollidingAbove + "\n";
        debugText += "Bas: " + CollisionInfo.isCollidingBelow + "\n";
        GUI.Label(new Rect(20, 20, 200, 140), debugText, style);
    }
    #endregion

    private void Start()
    {
        InputsManager = InputsManager.Instance;
        _InitAllStates();
        _InitStateMachine();
    }

    private void _InitStateMachine()
    {
        CollisionDetector.InitializeCollisionTracking(gameObject);
        ChangeState(StartState);
    }
    private void Update()
    {
        // R�initialiser les collisions horizontales � chaque frame
        CollisionDetector.ResetFrameCollisions(gameObject);
    }
    private void FixedUpdate()
    {
        // Obtenir l'�tat actuel des collisions
        CollisionInfo = CollisionDetector.GetCollisionInfo(gameObject);

        // Mise � jour de l'�tat actuel
        CurrentState.StateUpdate();

        // Appliquer le mouvement et obtenir les flags de collision
        CollisionFlags collisionFlags = _CharacterController.Move(Velocity * Time.fixedDeltaTime);

        // IMPORTANT: Mettre � jour les informations de collision bas�es sur les flags
        CollisionDetector.UpdateCollisionFlags(gameObject, collisionFlags);

        // Mettre � jour l'information de collision apr�s le mouvement
        CollisionInfo = CollisionDetector.GetCollisionInfo(gameObject);
    }

    private void _InitAllStates()
    {
        foreach (var state in AllStates)
        {
            state.Init(this);
        }
    }
    public void ChangeState(PlayerState state)
    {
        if (CurrentState != null)
        {
            CurrentState.StateExit(state);
        }
        PreviousState = CurrentState;
        CurrentState = state;
        if (CurrentState != null)
        {
            CurrentState.StateEnter(state);
        }
    }
}
