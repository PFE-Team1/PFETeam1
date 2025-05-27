
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Classe de base abstraite pour toutes les actions de jeu
public abstract class AGameAction
{
    public string ActionName { get; protected set; }
    public bool IsCompleted { get; protected set; }
    public bool IsCancelled { get; protected set; }

    // Events
    public event Action<AGameAction> OnActionStarted;
    public event Action<AGameAction> OnActionCompleted;
    public event Action<AGameAction> OnActionCancelled;

    protected AGameAction(string actionName)
    {
        ActionName = actionName;
        IsCompleted = false;
        IsCancelled = false;
    }

    // Méthode abstraite à implémenter dans les classes dérivées
    public abstract IEnumerator Execute();

    // Méthodes protégées pour notifier les changements d'état
    protected virtual void NotifyStarted()
    {
        OnActionStarted?.Invoke(this);
    }

    protected virtual void NotifyCompleted()
    {
        IsCompleted = true;
        OnActionCompleted?.Invoke(this);
    }

    protected virtual void NotifyCancelled()
    {
        IsCancelled = true;
        OnActionCancelled?.Invoke(this);
    }

    // Méthode virtuelle pour annuler l'action
    public virtual void Cancel()
    {
        if (!IsCompleted && !IsCancelled)
        {
            NotifyCancelled();
        }
    }

    // Reset pour réutiliser l'action
    public virtual void Reset()
    {
        IsCompleted = false;
        IsCancelled = false;
    }
}