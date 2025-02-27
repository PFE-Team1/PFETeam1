using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class Clone : MonoBehaviour
{
    [SerializeField] private List<GameObject> _clones;
    [SerializeField] private int _currentClone = 0;
    [SerializeField] private int _charID;
    [SerializeField] private GameObject _spawnPoint;//temp

    public int CharID { get => _charID;}

    private void Start()
    {
        _charID = CloneManager.instance.Characters.Count;
        CloneManager.instance.Characters.Add(this);
    }
    public void Cloned(GameObject spawnPoint)
    {
            if (_currentClone < _clones.Count)//condition à changer.
            {
                GameObject instantiatedClone = Instantiate(_clones[_currentClone], _spawnPoint.transform.position, _spawnPoint.transform.rotation);
                _currentClone++;
            }
        
    }
    public void Switch(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            CloneManager.instance.Switch(_charID);

        }
    }
}
