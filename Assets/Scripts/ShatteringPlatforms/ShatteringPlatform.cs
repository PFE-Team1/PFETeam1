using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShatteringPlatform : MonoBehaviour
{
    public bool CanRepairItself = true;
    public bool CanShatteringBeCancelled = true;
    public float TimeToShatter = 3f;
    public float TimeToRepair = 6f;

    public float _shatterTimer;
    private bool _isShattering = false;
    private SpriteRenderer _spriterenderer;

    // Make a shattering platform that shatters after a certain time when player is on it
    private void Start()
    {
        _shatterTimer = TimeToShatter;
        _spriterenderer = GetComponent<SpriteRenderer>();
    }

    private void Update()
    {
        if (_isShattering)
        {
            _shatterTimer -= Time.deltaTime;
            if (_shatterTimer <= 0)
            {
                Destroy(gameObject);
            }
        }
        else
        {
            if (CanRepairItself)
            {
                _shatterTimer = Mathf.Clamp(_shatterTimer + Time.deltaTime, 0, TimeToShatter);
            }
        }
        _spriterenderer.color = Color.Lerp(Color.white, Color.black, 1 - (_shatterTimer / TimeToShatter));
    }

    // detect when colliding
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            print("Collided ");
            _isShattering = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            if (CanShatteringBeCancelled)
            {
                _isShattering = false;
            }
        }
    }
}
