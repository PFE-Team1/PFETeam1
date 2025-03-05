using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerStateMachine : MonoBehaviour
{
    private Vector2 _velocity;
    public Vector2 Velocity
    {
        get { return _velocity; }
        set { _velocity = value; }
    }

    //public TemplateState StartState => stateIdle;
    //public TemplateState CurrentState { get; private set; }
    //public TemplateState PreviousState { get; private set; }

    public void ChangeState(PlayerState state)
    {
    }
}
