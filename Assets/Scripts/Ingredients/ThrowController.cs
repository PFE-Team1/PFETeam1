using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ThrowController : MonoBehaviour
{
    [SerializeField] private GameObject _throwableParent;
    [SerializeField] private float _throwMaxForce;
    [SerializeField] private float _throwForce;
    Clone playerC;
    GameObject nearestObject;
    bool _isInRange = false;

    void OnTriggerEnter(Collider other)
    {
        if (other.GetComponent<Grabbable>() != null)
        {
            _isInRange = true;
            nearestObject = other.gameObject;
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.GetComponent<Grabbable>() != null)
        {
            _isInRange = false;
            nearestObject = null;
        }
    }

    void Awake()
    {
        playerC = GetComponentInParent<Clone>();
    }

    void Update()
    {
        
        if (_isInRange && playerC.IsInteracting)
        {
            playerC.IsInteracting = false;
            if (playerC.heldObject == null)
            {
                GrabItem(nearestObject);
            }
            else if (playerC.heldObject != null)
            {
                Vector3 direction = (Camera.main.transform.position - _throwableParent.transform.position).normalized;
                ThrowItem(playerC.heldObject, SetDirection());
            }
        }
    }

    public Vector3 SetDirection()
    {
        return Vector3.zero;
    }

    public void GrabItem(GameObject item)
    {
        item.GetComponent<Grabbable>().IsGrabbed = true;
        item.GetComponent<Rigidbody>().isKinematic = true;
        item.GetComponent<Collider>().enabled = false;
        item.transform.SetParent(_throwableParent.transform);
        item.transform.localPosition = Vector3.zero;
        playerC.heldObject = item;
    }

    public void ThrowItem(GameObject throwableItem, Vector3 direction)
    {
        throwableItem.GetComponent<Grabbable>().IsGrabbed = false;
        throwableItem.GetComponent<Collider>().enabled = true;
        throwableItem.transform.SetParent(null);
        Rigidbody rb = throwableItem.GetComponent<Rigidbody>();
        rb.isKinematic = false;
        rb.AddForce(direction * _throwForce, ForceMode.Impulse);
        playerC.heldObject = null;
    }
}
