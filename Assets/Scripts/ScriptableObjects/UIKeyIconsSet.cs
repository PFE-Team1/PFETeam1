using KeyIconHelper;
using System;
using UnityEngine;


[CreateAssetMenu(fileName = "Data", menuName = "ScriptableObjects/UIKeyIconsSet", order = 2)]
public class UIKeyIconsSet : ScriptableObject
{
    #region Jump
    [SerializeField]
    [Tooltip("Icones des touches de saut")]
    public KeyIcon jumpKeyIcons = new KeyIcon("Jump", null, null);
    #endregion

    #region Move

    [SerializeField]
    [Tooltip("Icones des touches de mouvement")]
    public KeyIcon[] MoveKeyIcons = new KeyIcon[]
    {
        new KeyIcon("Move Up", null, null),
        new KeyIcon("Move Down", null, null),
        new KeyIcon("Move Left", null, null),
        new KeyIcon("Move Right", null, null)
    };

    #endregion

    #region Interact

    [SerializeField]
    [Tooltip("Icones des touches d'interaction")]
        public KeyIcon interactKeyIcons = new KeyIcon("Interact", null, null);

    public KeyIcon GetKeyIcon(string keyName)
    {
        foreach (KeyIcon keyIcon in MoveKeyIcons)
        {
            if (keyIcon.keyName == keyName)
            {
                return keyIcon;
            }
        }

        if (keyName == jumpKeyIcons.keyName)
        {
            return jumpKeyIcons;
        }
        else if (keyName == interactKeyIcons.keyName)
        {
            return interactKeyIcons;
        }

        Debug.LogWarning("No KeyIcon found for " + keyName);
        return null;
    }

    #endregion
}