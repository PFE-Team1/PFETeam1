using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class ShowLevelGameAction : AGameAction
{
    [Header("Action Settings")]
    [SerializeField] private PaintInOutController _inVFX;
    [SerializeField] private GameObject _level;
    [SerializeField] private  float _VFXDuration;
    protected override void OnExecute()
    {
        _inVFX.DurationIn=_VFXDuration;
        _inVFX.PaintIn(_level);
    }
    protected override void OnUpdate(float deltaTime)
    {

    }
    protected override void OnEnd()
    {
    }
}
