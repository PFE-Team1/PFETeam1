using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Door : MonoBehaviour
{
    [SerializeField] private Collider _collider;
    [SerializeField] private SpriteRenderer _sprite;
    [SerializeField] private Door _otherDoor;
    [SerializeField] private GameObject _vfxOpen;
    [SerializeField] private GameObject _groundOpen;

    public Door OtherDoor { get => _otherDoor; set => _otherDoor = null; }

    public void Open()
    {
        _collider.isTrigger = true;
        _sprite.enabled = false;
        _vfxOpen.SetActive(true);
        _groundOpen.SetActive(true);
    }
    public  void Close()
    {
        _collider.isTrigger = false;
        _sprite.enabled = true;
        _vfxOpen.SetActive(false);
        _groundOpen.SetActive(false);

    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Door")&&other!=_collider )
        {
            _otherDoor = other.GetComponentInChildren<Door>();
            //_otherDoor.Open();
            Open();
        }
        if (other.CompareTag("Player"))
        {
            other.GetComponent<SpriteRenderer>().sortingLayerName = "Inter";
            other.transform.parent=null;
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            other.GetComponent<SpriteRenderer>().sortingLayerName = "Default";
            other.GetComponent<Clone>().ChangeParent();
        }
    }
}
