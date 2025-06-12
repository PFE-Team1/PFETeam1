using Cinemachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class lerpCameraOrthoSizeGameAction : AGameAction
{
    [Header("Action Settings")]
    [SerializeField]
    [Tooltip("The target orthographic size to lerp to.")]
    private float targetOrthoSize = 5f;
    [SerializeField]
    [Tooltip("The duration over which to lerp the orthographic size.")]
    private float duration = 1f;
    public override ActionEndCondition EndCondition => ActionEndCondition.ConditionMet;
    protected override void OnEnd()
    {
    }

    protected override void OnExecute()
    {
    }
    protected override void OnUpdate(float deltaTime)
    {
        if (CameraManager.Instance == null)
        {
            Debug.LogWarning("CameraManager instance is null. Please ensure it is initialized before executing this action.");
            return;
        }
        CinemachineVirtualCamera virtualCamera = CameraManager.Instance.GetCurrentCamera();
        if (virtualCamera == null)
        {
            Debug.LogWarning("Main camera is not set in CameraManager. Please ensure it is assigned.");
            return;
        }
        float currentOrthoSize = virtualCamera.m_Lens.OrthographicSize;
        float newOrthoSize = Mathf.Lerp(currentOrthoSize, targetOrthoSize, deltaTime / duration);
        virtualCamera.m_Lens.OrthographicSize = newOrthoSize;
        _ConditionMet = Mathf.Approximately(newOrthoSize, targetOrthoSize) || Mathf.Abs(currentOrthoSize - targetOrthoSize) < 0.1f;
    }
}
