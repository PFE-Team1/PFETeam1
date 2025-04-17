using NaughtyAttributes;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Parrallaxe : MonoBehaviour
{

    [SerializeField] private bool _vertical;
    [SerializeField] private bool _horizontal;
    private Camera _mainCamera;
    [SerializeField]private BoxCollider2D _bounds;
    [SerializeField]private Transform _removed;
    #region Layers

    [SerializeField] private List<Layer> _layers;
#if UNITY_EDITOR
    [Button(enabledMode: EButtonEnableMode.Editor)]
    private void AddLayer()
    {
        GameObject newLayerObject = new GameObject();
        newLayerObject.transform.parent = transform;
        if(_layers[_layers.Count - 1]?.layer)
        {
            newLayerObject.name = _layers[_layers.Count - 1].layer.name + "1";
        }
        else
        {
            newLayerObject.name = "new layer uwu";
        }
        Layer newLayer = new Layer(newLayerObject, _layers[_layers.Count - 1].name + "1");
        _layers.Add(newLayer);
    }
    [Button(enabledMode: EButtonEnableMode.Editor)]
    private void RemoveLayer()
    {
        Layer oldLayer = _layers[_layers.Count - 1];
        GameObject oldLayerObject = oldLayer.layer;
        _layers.RemoveAt(_layers.Count - 1);
        foreach(Transform child in oldLayerObject.transform)
        {
            child.SetParent(_removed);
        }
        DestroyImmediate(oldLayerObject);
    }
#endif
    #endregion
    private Vector2 _startPos;
    void Start()
    {
        _mainCamera=FindObjectOfType<Camera>();
        _startPos = transform.position;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if (SettingsManager.Instance.WantParallax == false) return;
        float distX = 0;
        float distY = 0;
        if (_vertical)
        {
            distY = transform.position.y-_mainCamera.transform.position.y ;
            if (distY > _bounds.size.y / 2) distY = _bounds.size.y / 2;
            if (distY <1- _bounds.size.y / 2) distY = 1-_bounds.size.y / 2;
        }
        if (_horizontal)
        {
            distX = transform.position.x - _mainCamera.transform.position.x;
            if (distX > _bounds.size.x / 2) distX = _bounds.size.x / 2;
            if (distX <1- _bounds.size.x / 2) distX = 1-_bounds.size.x / 2;
        }
        float currentFallOff = 0;
        foreach(Layer currentLayer in _layers)
        {
            currentLayer.layer.transform.position = new Vector2(_startPos.x + distX * currentLayer.strengthX * (1-currentFallOff), _startPos.y + distY * currentLayer.strengthY * (1-currentFallOff));
        }

    }


}
[System.Serializable]
public class Layer
{
     public string name;
     public GameObject layer;
     public float strengthY=0.1f;
     public float strengthX = 0.1f;

    public Layer(GameObject gameobject,string lName)
    {
        name = lName;
        layer = gameobject;
        strengthY = 0.1f;
        strengthX = 0.1f;
    }
}
