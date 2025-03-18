using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerControllerTest : MonoBehaviour
{
    private GameObject _heldObject;
    public GameObject heldObject { get => _heldObject; set => _heldObject = value; }

    CharacterController controller;

    void Start()
    {
        controller = GetComponent<CharacterController>();
    }

    void Update()
    {
        float moveX = Input.GetAxis("Horizontal") * Time.deltaTime * 5;
        float moveY = Input.GetAxis("Vertical") * Time.deltaTime * 5;
        controller.Move(new Vector3(moveX, moveY, 0));
    }
}
