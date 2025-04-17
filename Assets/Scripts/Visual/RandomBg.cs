using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using NaughtyAttributes;

public class RandomBg : MonoBehaviour
{
    [SerializeField] private List<Sprite> _sprites;
    [SerializeField] private float _xSpace;
    [SerializeField] private float _ySpace;
    [SerializeField] private float _minRangeScale;
    [SerializeField] private float _maxRangeScale;
    [SerializeField] private int _spawnChance;
    [SerializeField] private int _xRange;
    [SerializeField] private int _yRange;
    private GameObject _contenant;

    [Button]
    private void BackGround()
    {

        if (_contenant)
        {
            DestroyImmediate(_contenant);
        }
        _contenant = new GameObject();
        _contenant.transform.parent = transform;
        _contenant.transform.localScale = Vector3.one;
        _contenant.transform.name = "contenant";
        for (int i =-_xRange;i<= _xRange; i++)
        {
            for (int j = -_yRange; j <= _yRange; j++)
            {
                int rand = Random.Range(0, 10);
                print(rand);
                if (rand < _spawnChance)
                {
                    int rand2 = Random.Range(0, _sprites.Count);
                    GameObject good = new GameObject();
                    good.transform.parent = _contenant.transform;
                    good.AddComponent<SpriteRenderer>();
                    good.GetComponent<SpriteRenderer>().sprite = _sprites[rand2];
                    good.GetComponent<SpriteRenderer>().sortingOrder=-5;
                    good.transform.position = new Vector2(i * _xSpace, j * _ySpace);
                    float randScale = Random.Range(_minRangeScale, _maxRangeScale)/transform.localScale.x;
                    good.transform.localScale = new Vector2(randScale, randScale);
                    float zRandRota = Random.Range(0, 360);
                    good.transform.RotateAround(good.transform.position,new Vector3(0, 0, 1), zRandRota);

                }
            }
        }
    }

}
