using UnityEngine;

public abstract class AGameAction : MonoBehaviour
{
    [Header("Action Settings")]
    [SerializeField] protected float duration = 1f;
    [SerializeField] protected ActionStartCondition startCondition = ActionStartCondition.WaitForPrevious;

    [Header("Delay Settings")]
    [SerializeField] protected float delayAmount = 0f; // D�lai en secondes pour DelayAfterPrevious et DelayFromStart

    protected float _currentTime = 0f;
    protected bool _isFinished = false;
    protected bool _hasStarted = false;

    public float Duration => duration;
    public float DelayAmount => delayAmount;
    public ActionStartCondition StartCondition => startCondition;

    public virtual void Execute()
    {
        if (_hasStarted) return;

        _hasStarted = true;
        _currentTime = 0f;
        _isFinished = false;

        OnExecute();

        if (duration <= 0f)
        {
            _isFinished = true;
        }
    }

    public virtual void ActionUpdate(float deltaTime)
    {
        if (!_hasStarted || _isFinished) return;

        _currentTime += deltaTime;

        OnUpdate(deltaTime);

        if (_currentTime >= duration)
        {
            _isFinished = true;
            OnActionFinished();
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
        _currentTime = 0f;
        OnReset();
    }

    public virtual void Skip()
    {
        if (!_hasStarted) return;

        _currentTime = duration;
        _isFinished = true;
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

    // M�thodes abstraites � impl�menter
    protected abstract void OnExecute();
    protected abstract void OnUpdate(float deltaTime);
    protected abstract void OnEnd();

    // M�thodes virtuelles optionnelles
    protected virtual void OnReset() { }
    protected virtual void OnSkip() { }
    protected virtual void OnActionFinished() { }

    public enum ActionStartCondition
    {
        WaitForPrevious,        // Attendre que l'action pr�c�dente se termine
        DelayAfterPrevious,     // Attendre delayAmount secondes apr�s la fin de l'action pr�c�dente
        Simultaneous,           // Se lancer en m�me temps que l'action pr�c�dente
        DelayFromStart          // Se lancer delayAmount secondes apr�s le d�but de la premi�re action
    }
}