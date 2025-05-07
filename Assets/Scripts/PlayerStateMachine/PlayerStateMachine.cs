using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using CollisionHelper;
using Unity.IO.LowLevel.Unsafe;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UIElements;
using Color = UnityEngine.Color;

public class PlayerStateMachine : MonoBehaviour
{
    #region PublicVariables

    #region InspectorVariables

    public bool DebugMode = true;
    public PlayerMovementParameters BasePlayerMovementParameters;
    public RuntimeAnimatorController BaseAnimator;
    public RuntimeAnimatorController AnimatorWithPaint;

    #endregion
    #region NonInspectorVariables
    [HideInInspector]
    public CollisionDetector.CollisionInfo CollisionInfo;
    [HideInInspector]
    public Vector2 Velocity;
    [HideInInspector]
    public bool IsMovementLocked;
    [HideInInspector]
    public InputsManager InputsManager { get; private set; }
    [HideInInspector]
    public PlayerMovementParameters PlayerMovementParameters;
    [HideInInspector] 
    public bool IsJumpInputEaten = false;
    [HideInInspector]
    public float JumpBuffer = 0f;
    [HideInInspector]
    public Animator Animator;
    [HideInInspector]
    public MeshRenderer MeshRenderer;
    [HideInInspector]
    public bool IsCarrying = false;
    #endregion
    #endregion
    #region PrivateVariables
    private CharacterController _CharacterController => GetComponent<CharacterController>();
    private SphereCollider _SphereCollider;
    #endregion
    #region States

    #region privateStates
    private IdlePlayerState _idleState { get; } = new IdlePlayerState();
    private FallingPlayerState _fallingState { get; } = new FallingPlayerState();
    private RunningPlayerState _runningState { get; } = new RunningPlayerState();
    private JumpingPlayerState _jumpingState { get; } = new JumpingPlayerState();

    private cloneState _cloneState { get; } = new cloneState();
    private paintingGrabState _paintingGrabState { get; } = new paintingGrabState();
    private paintingDropState _paintingDropState { get; } = new paintingDropState();

    private JumpStartPlayerState _jumpStartState { get; } = new JumpStartPlayerState();
    #endregion

    #region Accessors
    public IdlePlayerState IdleState => _idleState;
    public FallingPlayerState FallingState => _fallingState;
    public RunningPlayerState RunningState => _runningState;
    public JumpingPlayerState JumpingState => _jumpingState;

    public JumpStartPlayerState JumpStartState => _jumpStartState;

    public cloneState CloneState => _cloneState;
    public paintingGrabState PaintingGrabState => _paintingGrabState;
    public paintingDropState PaintingDropState => _paintingDropState;
    #endregion
    public PlayerState[] AllStates => new PlayerState[]
    {
        _idleState,
        _fallingState,
        _runningState,
        _jumpingState,
        _cloneState,
        _jumpStartState,
        _paintingGrabState,
        _paintingDropState
    };

    #endregion

    #region CurrentStates
    private PlayerState StartState => _idleState;
    public PlayerState CurrentState { get; set; }
    [HideInInspector]
    public PlayerState PreviousState { get; set; }

    #endregion

    Coroutine coroutine = null;
    [SerializeField] private float walkingTime = 0.25f;

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
        debugText += "Current Profile Name: " + PlayerMovementParameters.name + "\n";
        debugText += "Current State: " + CurrentState.GetType().Name + "\n";
        debugText += "Move X: " + InputsManager.MoveX + "\n";
        debugText += "Velocity: " + Velocity.ToString("F2") + "\n";
        debugText += "Jump Buffer: " + JumpBuffer.ToString("F2") + "\n";
        debugText += "\n";
        debugText += "Gauche: " + CollisionInfo.isCollidingLeft + "\n";
        debugText += "Droite: " + CollisionInfo.isCollidingRight + "\n";
        debugText += "Haut: " + CollisionInfo.isCollidingAbove + "\n";
        debugText += "Bas: " + CollisionInfo.isCollidingBelow + "\n";
        debugText += "\n";
        debugText += "IsCarrying: " + IsCarrying + "\n";
        GUI.Label(new Rect(20, 20, 200, 300), debugText, style);
    }
    #endregion

    private void Start()
    {
        Debug.developerConsoleVisible = true;

        InputsManager = InputsManager.instance;
        MeshRenderer = GetComponentInChildren<MeshRenderer>();
        Animator = GetComponentInChildren<Animator>();
        _InitAllStates();
        _InitStateMachine();
    }

    private void _InitStateMachine()
    {
        PlayerMovementParameters = BasePlayerMovementParameters;
        CollisionDetector.InitializeCollisionTracking(gameObject);
        ChangeState(StartState);
    }
    private void Update()
    {
        // R�initialiser les collisions horizontales � chaque frame
        CollisionDetector.ResetFrameCollisions(gameObject);
        // Mettre � jour l'entr�e de l'utilisateur
        UpdateJumpBuffer();
        UpdateAnimator();
    }
    private void FixedUpdate()
    {
        // Obtenir l'�tat actuel des collisions
        CollisionInfo = CollisionDetector.GetCollisionInfo(gameObject);


        // Appliquer le mouvement et obtenir les flags de collision
        CollisionFlags collisionFlags = _CharacterController.Move(Velocity * Time.fixedDeltaTime);

        // IMPORTANT: Mettre � jour les informations de collision bas�es sur les flags
        CollisionDetector.UpdateCollisionFlags(gameObject, collisionFlags);

        // Mettre � jour l'information de collision apr�s le mouvement
        CollisionInfo = CollisionDetector.GetCollisionInfo(gameObject);

        // Mise � jour de l'�tat actuel
        CurrentState.StateUpdate();

        switch (CurrentState)
        {
            case RunningPlayerState _:
                if (coroutine == null)
                {
                    coroutine = StartCoroutine(CloneWalk());
                }
                break;
        }
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

    IEnumerator CloneWalk()
    {
        AudioManager.Instance.FOL_Pas.Post(gameObject);
        yield return new WaitForSeconds(walkingTime);
        coroutine = null;
    }

    private void UpdateJumpBuffer()
    {
        if (!InputsManager.InputJumping)
        {
            IsJumpInputEaten = true;
        }

        if (InputsManager.InputJumping && IsJumpInputEaten)
        {
            IsJumpInputEaten = false;
            JumpBuffer = PlayerMovementParameters.jumpBuffer;
        }

        JumpBuffer = Mathf.Clamp(JumpBuffer - Time.deltaTime, 0, PlayerMovementParameters.jumpBuffer);
    }

    private void UpdateAnimator()
    {
        Animator.SetFloat("VelocityX", Mathf.Abs(Velocity.x));
        Animator.SetFloat("VelocityY", Velocity.y);
        Animator.SetBool("Grounded", CollisionInfo.isCollidingBelow);

        if (Velocity.x != 0)
        {

            // mulitply x scale by sign of velocity
            Vector3 scale = MeshRenderer.transform.localScale;
            scale.x = Mathf.Sign(Velocity.x) * Mathf.Abs(scale.x);
            MeshRenderer.transform.localScale = scale;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (CurrentState != CloneState) return;
        if (other.CompareTag("Player") && other.gameObject != gameObject)
        {
            IsCarrying = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (CurrentState != CloneState) return;
        if (other.CompareTag("Player") && other.gameObject != gameObject)
        {
            IsCarrying = false;
        }
    }

}
