using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class pathTransformGameAction : AGameAction
{
    [Header("Path Settings")]
    [SerializeField]
    private Transform targetTransform;
    [SerializeField]
    private List<Waypoint> waypoints = new List<Waypoint>();

    public override ActionEndCondition EndCondition => ActionEndCondition.ConditionMet;

    private float _currentWaypointTime = 0f;
    private int _currentWaypointIndex = 0;
    private Vector3 _startPosition;

    protected override void OnEnd()
    {
    }

    protected override void OnExecute()
    {
        print("Executing Path Transform Game Action");
        if (targetTransform != null)
        {
            _startPosition = targetTransform.position;
        }
    }

    protected override void OnUpdate(float deltaTime)
    {
        print(_currentWaypointTime + " " + _currentWaypointIndex + " " + waypoints.Count);
        if (targetTransform == null || waypoints.Count == 0)
        {
            Debug.LogWarning("Target Transform or Waypoints are not set.");
            return;
        }
        if (_currentWaypointIndex >= waypoints.Count)
        {
            _ConditionMet = true; // All waypoints have been processed  
            return;
        }
        Waypoint currentWaypoint = waypoints[_currentWaypointIndex];
        _currentWaypointTime += deltaTime;

        // Handle delay before moving to the next waypoint  
        if (_currentWaypointTime < currentWaypoint.delayBeforeNext)
        {
            return;
        }

        // Check if we have reached the current waypoint  
        float timeSinceStart = _currentWaypointTime - currentWaypoint.delayBeforeNext;
        if (timeSinceStart >= currentWaypoint.timeToReach)
        {
            // Move to the next waypoint  
            targetTransform.position = currentWaypoint.transform.position;
            _currentWaypointTime = 0f;
            _currentWaypointIndex++;
            if (_currentWaypointIndex < waypoints.Count)
            {
                _startPosition = targetTransform.position;
            }
        }
        else
        {
            // Interpolate position based on acceleration curve  
            float t = timeSinceStart / currentWaypoint.timeToReach;
            float accelerationFactor = currentWaypoint.accelerationCurve.Evaluate(t);
            targetTransform.position = Vector3.Lerp(_startPosition, currentWaypoint.transform.position, accelerationFactor);
        }
    }

    [Serializable]
    class Waypoint
    {
        public Transform transform;
        public float timeToReach;
        public float delayBeforeNext = 0f;
        public AnimationCurve accelerationCurve;
    }
}
