using UnityEngine;

public abstract class PlayerState
{
    public PlayerStateMachine StateMachine { get; private set; }
    protected void ChangeState(PlayerState state) => StateMachine.ChangeState(state);
    public void StateEnter(PlayerState previousState) => OnStateEnter(previousState);
    public void StateExit(PlayerState nextState) => OnStateExit(nextState);

    public void StateUpdate()
    {
        OnStateUpdate();
    }

    protected abstract void OnStateInit();
    protected abstract void OnStateEnter(PlayerState previousState);
    protected abstract void OnStateExit(PlayerState nextState);
    protected abstract void OnStateUpdate();
}
