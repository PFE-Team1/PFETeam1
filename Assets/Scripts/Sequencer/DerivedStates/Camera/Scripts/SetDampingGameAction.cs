using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public class SetDampingGameAction : AGameAction
{
    [SerializeField] private float _duration;
    [SerializeField] private float _xDamp;
    [SerializeField] private float _yDamp;
    public override ActionEndCondition EndCondition => ActionEndCondition.ConditionMet;

    private void Start()
    {
    }

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
        float currentDampingX = virtualCamera.GetCinemachineComponent<CinemachineTransposer>().m_XDamping;
        float currentDampingY = virtualCamera.GetCinemachineComponent<CinemachineTransposer>().m_YDamping;
        float newDampingX = Mathf.Lerp(currentDampingX, _xDamp, deltaTime / _duration);
        float newDampingY = Mathf.Lerp(currentDampingY, _yDamp, deltaTime / _duration);
        virtualCamera.GetCinemachineComponent<CinemachineTransposer>().m_XDamping = newDampingX;
        virtualCamera.GetCinemachineComponent<CinemachineTransposer>().m_YDamping = newDampingY;
        _ConditionMet = (Mathf.Approximately(newDampingX, _xDamp) || Mathf.Abs(currentDampingX - _xDamp) < 0.1f) && (Mathf.Approximately(newDampingY, _yDamp) || Mathf.Abs(currentDampingY - _yDamp) < 0.1f);
    }
}
