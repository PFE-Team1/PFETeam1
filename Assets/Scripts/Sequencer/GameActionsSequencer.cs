using System.Collections.Generic;
using UnityEngine;

public class GameActionsSequencer : MonoBehaviour
{
    private List<AGameAction> _gameActionsList;
    private List<ActionExecutionData> _actionExecutionData;
    private int _currentGameActionIndex = 0;
    private bool _isRunning = false;
    private float _sequenceStartTime = 0f;

    [Header("AutoPlay")]
    public ActionTrigger actionTrigger = ActionTrigger.AutoStart;
    [SerializeField]
    [ConditionalField("actionTrigger", ActionTrigger.Trigger, ActionTrigger.Trigger)]
    private bool canBeReTriggered = false;

    // Structure pour stocker les données d'exécution de chaque action
    private class ActionExecutionData
    {
        public AGameAction action;
        public bool hasBeenExecuted = false;
        public bool isActive = false;
        public float delayTimer = 0f;
        public float actionStartTime = 0f;
        public bool isWaitingForDelay = false;
    }

    private void Awake()
    {
        _gameActionsList = new List<AGameAction>(GetComponentsInChildren<AGameAction>());
        _InitializeExecutionData();
    }

    private void _InitializeExecutionData()
    {
        _actionExecutionData = new List<ActionExecutionData>();

        for (int i = 0; i < _gameActionsList.Count; i++)
        {
            var data = new ActionExecutionData
            {
                action = _gameActionsList[i]
            };
            _actionExecutionData.Add(data);
        }
    }

    private void Start()
    {
        if (actionTrigger == ActionTrigger.AutoStart)
        {
            Play();
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (actionTrigger == ActionTrigger.Trigger && !_isRunning)
        {
            //destroy the trigger
            if(!canBeReTriggered) Destroy(gameObject.GetComponent<BoxCollider>());
            Play();
        }
    }

    private void Update()
    {
        _UpdateActions();
    }

    private void _UpdateActions()
    {
        if (!_isRunning) return;

        float dt = Time.deltaTime;
        float currentTime = Time.time - _sequenceStartTime;

        // Mettre à jour toutes les actions actives
        for (int i = 0; i < _actionExecutionData.Count; i++)
        {
            var actionData = _actionExecutionData[i];

            // Vérifier si l'action doit démarrer
            if (!actionData.hasBeenExecuted && _ShouldStartAction(i, currentTime))
            {
                _StartAction(i, currentTime);
            }

            // Mettre à jour les actions actives
            if (actionData.isActive)
            {
                actionData.action.ActionUpdate(dt);

                // Vérifier si l'action est terminée
                if (actionData.action.IsFinished())
                {
                    actionData.action.End();
                    actionData.isActive = false;
                }
            }
        }

        // Vérifier si toutes les actions sont terminées
        if (_AreAllActionsFinished())
        {
            Stop();
        }
    }

    private bool _ShouldStartAction(int actionIndex, float currentTime)
    {
        var actionData = _actionExecutionData[actionIndex];
        var action = actionData.action;

        // Si l'action a déjà été exécutée, ne pas la redémarrer
        if (actionData.hasBeenExecuted) return false;

        // Première action : démarre toujours immédiatement
        if (actionIndex == 0) return true;

        var previousActionData = _actionExecutionData[actionIndex - 1];

        switch (action.StartCondition)
        {
            case AGameAction.ActionStartCondition.WaitForPrevious:
                return previousActionData.hasBeenExecuted && !previousActionData.isActive;

            case AGameAction.ActionStartCondition.DelayAfterPrevious:
                if (!previousActionData.hasBeenExecuted || previousActionData.isActive)
                    return false;

                if (!actionData.isWaitingForDelay)
                {
                    actionData.isWaitingForDelay = true;
                    actionData.delayTimer = 0f;
                    return false;
                }

                actionData.delayTimer += Time.deltaTime;
                return actionData.delayTimer >= action.DelayAmount;

            case AGameAction.ActionStartCondition.Simultaneous:
                return previousActionData.hasBeenExecuted;

            case AGameAction.ActionStartCondition.DelayFromStart:
                if (actionIndex == 0) return true;

                var firstActionData = _actionExecutionData[0];
                if (!firstActionData.hasBeenExecuted) return false;

                float timeSinceFirstAction = currentTime - firstActionData.actionStartTime;
                return timeSinceFirstAction >= action.DelayAmount;

            default:
                return false;
        }
    }

    private void _StartAction(int actionIndex, float currentTime)
    {
        var actionData = _actionExecutionData[actionIndex];

        actionData.action.Execute();
        actionData.hasBeenExecuted = true;
        actionData.isActive = true;
        actionData.actionStartTime = currentTime;

        Debug.Log($"Action {actionIndex} started at time {currentTime} with condition {actionData.action.StartCondition}");
    }

    private bool _AreAllActionsFinished()
    {
        foreach (var actionData in _actionExecutionData)
        {
            if (!actionData.hasBeenExecuted || actionData.isActive)
                return false;
        }
        return true;
    }

    public void Play()
    {
        if (_isRunning) return;
        if (_gameActionsList.Count == 0) return;

        _ResetAllActions();
        _currentGameActionIndex = 0;
        _isRunning = true;
        _sequenceStartTime = Time.time;
    }

    private void _ResetAllActions()
    {
        foreach (var actionData in _actionExecutionData)
        {
            actionData.hasBeenExecuted = false;
            actionData.isActive = false;
            actionData.delayTimer = 0f;
            actionData.actionStartTime = 0f;
            actionData.isWaitingForDelay = false;
        }
    }

    public void Stop()
    {
        if (!_isRunning) return;

        // Terminer toutes les actions actives
        foreach (var actionData in _actionExecutionData)
        {
            if (actionData.isActive)
            {
                actionData.action.End();
                actionData.isActive = false;
            }
        }

        _currentGameActionIndex = 0;
        _isRunning = false;

        Debug.Log("Sequence stopped");
    }

    public bool IsRunning()
    {
        return _isRunning;
    }

    public bool IsEmpty()
    {
        return _gameActionsList.Count == 0;
    }

    // Méthodes utilitaires pour debug
    public void SkipToNextAction()
    {
        if (!_isRunning) return;

        // Forcer la fin de l'action courante
        for (int i = 0; i < _actionExecutionData.Count; i++)
        {
            var actionData = _actionExecutionData[i];
            if (actionData.isActive)
            {
                actionData.action.End();
                actionData.isActive = false;
                break;
            }
        }
    }

    public int GetCurrentActionIndex()
    {
        for (int i = 0; i < _actionExecutionData.Count; i++)
        {
            if (_actionExecutionData[i].isActive)
                return i;
        }
        return -1;
    }
    public enum ActionTrigger
    {
        AutoStart,
        Trigger,
    }
}