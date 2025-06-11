// Fichier: AGameAction.cs
using UnityEngine;

public abstract class AGameAction : MonoBehaviour
{
    [Header("Debug Settings")]
    [SerializeField]
    protected ActionStartCondition startCondition = ActionStartCondition.WaitForPrevious;

    protected float duration = 0f;

    // Le champ delayAmount ne s'affiche que si startCondition est DelayAfterPrevious ou DelayFromStart
    [SerializeField]
    [ConditionalField("startCondition", ActionStartCondition.DelayAfterPrevious, ActionStartCondition.DelayFromStart)]
    protected float delayAmount = 0f; // Délai en secondes pour DelayAfterPrevious et DelayFromStart

    protected float _currentTime = 0f;
    protected bool _isFinished = false;
    protected bool _hasStarted = false;
    protected bool _ConditionMet = false;
        
    public float Duration => duration;
    public float DelayAmount => delayAmount;
    public virtual ActionStartCondition StartCondition => startCondition;
    public virtual ActionEndCondition EndCondition => ActionEndCondition.TimeLimit; // Par défaut, on utilise TimeLimit pour la condition de fin
    public bool ConditionMet => _ConditionMet;

    public virtual void Execute()
    {
        if (_hasStarted) return;
        _hasStarted = true;
        _currentTime = 0f;
        _isFinished = false;
        OnExecute();
        switch (EndCondition)
        {
            case ActionEndCondition.TimeLimit:
                if (duration <= 0f)
                {
                    _isFinished = true;
                }
                break;
            case ActionEndCondition.ConditionMet:
                _isFinished = _ConditionMet;
                break;
            case ActionEndCondition.Manual:
                break;
            default:
                break;
        }
    }

    public virtual void ActionUpdate(float deltaTime)
    {
        if (!_hasStarted || _isFinished) return;
        _currentTime += deltaTime;
        OnUpdate(deltaTime);
        switch (EndCondition)
        {
            case ActionEndCondition.TimeLimit:
                if (_currentTime >= duration)
                {
                    _isFinished = true;
                    OnActionFinished();
                }
                break;
            case ActionEndCondition.ConditionMet:
                _isFinished = _ConditionMet;
                if (_ConditionMet) OnActionFinished();
                break;
            case ActionEndCondition.Manual:
                break;
            default:
                break;
        }
    }

    public virtual void End()
    {
        if (!_hasStarted) return;
        OnEnd();
        Reset();
    }

    public virtual void Reset()
    {
        _hasStarted = false;
        _isFinished = false;
        _ConditionMet = false;
        _currentTime = 0f;
        OnReset();
    }

    public virtual void Skip()
    {
        if (!_hasStarted) return;
        _currentTime = duration;
        _isFinished = true;
        _ConditionMet = true;
        OnSkip();
        OnActionFinished();
    }

    public bool IsFinished()
    {
        return _isFinished;
    }

    public bool HasStarted()
    {
        return _hasStarted;
    }

    public float GetProgress()
    {
        if (duration <= 0f) return 1f;
        return Mathf.Clamp01(_currentTime / duration);
    }

    public float GetRemainingTime()
    {
        return Mathf.Max(0f, duration - _currentTime);
    }

    // Méthodes abstraites à implémenter
    protected abstract void OnExecute();
    protected abstract void OnUpdate(float deltaTime);
    protected abstract void OnEnd();

    // Méthodes virtuelles optionnelles
    protected virtual void OnReset() { }
    protected virtual void OnSkip() { }
    protected virtual void OnActionFinished() { }

    public enum ActionStartCondition
    {
        WaitForPrevious,        // Attendre que l'action précédente se termine
        DelayAfterPrevious,     // Attendre delayAmount secondes après la fin de l'action précédente
        Simultaneous,           // Se lancer en même temps que l'action précédente
        DelayFromStart,         // Se lancer delayAmount secondes après le début de la première action
    }

    public enum ActionEndCondition
    {
        None,                   // Pas de condition de fin
        TimeLimit,              // Fin après un certain temps
        ConditionMet,           // Fin lorsque la condition est remplie
        Manual,                 // Fin manuelle via une méthode externe
    }
}