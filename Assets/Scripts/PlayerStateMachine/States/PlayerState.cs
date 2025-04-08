using UnityEngine;

public abstract class PlayerState
{
    public PlayerStateMachine StateMachine { get; private set; }

    protected float _timeSinceEnteredState = 0;
    protected InputsManager _inputsManager => StateMachine.InputsManager;
    protected PlayerMovementParameters _playerMovementParameters => StateMachine.PlayerMovementParameters;
    protected void ChangeState(PlayerState state) => StateMachine.ChangeState(state);
    public void StateEnter(PlayerState state)
    {
        _timeSinceEnteredState = 0;
        OnStateEnter(StateMachine.PreviousState);
    }
    public void StateExit(PlayerState nextState) => OnStateExit(nextState);

    public void Init(PlayerStateMachine stateMachine)
    {
        StateMachine = stateMachine;
        OnStateInit();
    }
    public void StateUpdate()
    {
        if (_playerMovementParameters == null)
        {
            Debug.LogWarning("You forgot playerMovementParameters Scriptable object ! ");
            return;
        } 
        
        OnStateUpdate();

    }

    protected abstract void OnStateInit();
    protected abstract void OnStateEnter(PlayerState previousState);
    protected abstract void OnStateExit(PlayerState nextState);
    protected abstract void OnStateUpdate();
}
