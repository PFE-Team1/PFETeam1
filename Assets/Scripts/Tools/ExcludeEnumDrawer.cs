#if UNITY_EDITOR
using UnityEditor;
using System.Linq;
using System.Collections.Generic;
using UnityEngine;

[CustomPropertyDrawer(typeof(ExcludeEnumAttribute))]
public class ExcludeEnumDrawer : PropertyDrawer
{
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        ExcludeEnumAttribute excludeAttribute = (ExcludeEnumAttribute)attribute;

        if (property.propertyType == SerializedPropertyType.Enum)
        {
            // R�cup�rer tous les noms de l'enum
            string[] allEnumNames = property.enumNames;

            // Cr�er des listes pour les valeurs filtr�es
            List<string> filteredNames = new List<string>();
            List<int> filteredIndices = new List<int>();

            // Filtrer les valeurs en excluant celles sp�cifi�es
            for (int i = 0; i < allEnumNames.Length; i++)
            {
                if (!excludeAttribute.excludedValues.Contains(i))
                {
                    filteredNames.Add(allEnumNames[i]);
                    filteredIndices.Add(i);
                }
            }

            // Convertir en arrays
            string[] filteredNamesArray = filteredNames.ToArray();
            int[] filteredIndicesArray = filteredIndices.ToArray();

            // Trouver l'index actuel dans la liste filtr�e
            int currentEnumIndex = property.enumValueIndex;
            int selectedIndex = System.Array.IndexOf(filteredIndicesArray, currentEnumIndex);

            // Si la valeur actuelle est exclue, s�lectionner la premi�re valeur disponible
            if (selectedIndex < 0 && filteredIndicesArray.Length > 0)
            {
                selectedIndex = 0;
                property.enumValueIndex = filteredIndicesArray[0];
            }

            // Afficher le popup avec les valeurs filtr�es
            EditorGUI.BeginChangeCheck();
            selectedIndex = EditorGUI.Popup(position, label.text, selectedIndex, filteredNamesArray);

            if (EditorGUI.EndChangeCheck() && selectedIndex >= 0 && selectedIndex < filteredIndicesArray.Length)
            {
                property.enumValueIndex = filteredIndicesArray[selectedIndex];
            }
        }
        else
        {
            EditorGUI.LabelField(position, label.text, "ExcludeEnum attribute can only be used with enums.");
        }
    }
}
#endif