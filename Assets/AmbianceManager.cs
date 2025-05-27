using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AmbianceManager : MonoBehaviour
{
    [SerializeField] private List<AK.Wwise.Event> ambianceEvents;
    private List<GameObject> ambianceObjects = new List<GameObject>();

    public void PlayAmbiance()
    {
        foreach (var ambianceEvent in ambianceEvents)
        {
            if (ambianceEvent != null)
            {
                GameObject ambianceObject = new GameObject($"AmbianceEvent-{ambianceEvent.Name}");
                ambianceObjects.Add(ambianceObject);
                ambianceObject.AddComponent<AkGameObj>();
                ambianceObject.AddComponent<AkAmbient>();
                ambianceObject.GetComponent<AkAmbient>().data = ambianceEvent;
                ambianceObject.GetComponent<AkAmbient>().stopSoundOnDestroy = true;
                ambianceEvent.Post(ambianceObject);
            }
        }
    }

    public void StopAmbiance()
    {
        foreach (var ambianceObject in ambianceObjects)
        {
            Destroy(ambianceObject);
        }
        ambianceObjects.Clear();
    }

}
