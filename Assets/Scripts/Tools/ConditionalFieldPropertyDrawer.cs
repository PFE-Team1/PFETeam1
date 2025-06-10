// Fichier 2: ConditionalFieldAttribute.cs
using System;
using UnityEditor;
using UnityEngine;
using UnityEditor;

// Attribut personnalisé pour l'affichage conditionnel
public class ConditionalFieldAttribute : PropertyAttribute
{
    public string FieldName { get; }
    public object[] CompareValues { get; }

    public ConditionalFieldAttribute(string fieldName, params object[] compareValues)
    {
        FieldName = fieldName;
        CompareValues = compareValues;
    }
}

#if UNITY_EDITOR

// Property Drawer personnalisé pour gérer l'affichage conditionnel
[CustomPropertyDrawer(typeof(ConditionalFieldAttribute))]
public class ConditionalFieldPropertyDrawer : PropertyDrawer
{
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        ConditionalFieldAttribute conditionAttribute = (ConditionalFieldAttribute)attribute;
        SerializedProperty conditionProperty = property.serializedObject.FindProperty(conditionAttribute.FieldName);

        if (conditionProperty != null)
        {
            bool showField = false;

            // Vérifier si la valeur actuelle correspond à une des valeurs de comparaison
            foreach (var compareValue in conditionAttribute.CompareValues)
            {
                if (conditionProperty.enumValueIndex == (int)compareValue)
                {
                    showField = true;
                    break;
                }
            }

            if (showField)
            {
                EditorGUI.PropertyField(position, property, label);
            }
        }
        else
        {
            EditorGUI.PropertyField(position, property, label);
        }
    }

    public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
    {
        ConditionalFieldAttribute conditionAttribute = (ConditionalFieldAttribute)attribute;
        SerializedProperty conditionProperty = property.serializedObject.FindProperty(conditionAttribute.FieldName);

        if (conditionProperty != null)
        {
            bool showField = false;

            foreach (var compareValue in conditionAttribute.CompareValues)
            {
                if (conditionProperty.enumValueIndex == (int)compareValue)
                {
                    showField = true;
                    break;
                }
            }

            return showField ? EditorGUIUtility.singleLineHeight : 0f;
        }

        return EditorGUIUtility.singleLineHeight;
    }
}
#endif