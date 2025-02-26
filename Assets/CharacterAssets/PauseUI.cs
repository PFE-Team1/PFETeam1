using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PauseUI : MonoBehaviour
{
    public void UnpauseLaSequence()
    {
        ManagerManager.Instance.PreRoundSequence.TogglePause();
    }

}
