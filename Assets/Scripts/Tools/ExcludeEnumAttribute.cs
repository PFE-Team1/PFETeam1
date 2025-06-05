using UnityEngine;
using System;

public class ExcludeEnumAttribute : PropertyAttribute
{
    public int[] excludedValues;

    public ExcludeEnumAttribute(params object[] excludedEnumValues)
    {
        excludedValues = new int[excludedEnumValues.Length];
        for (int i = 0; i < excludedEnumValues.Length; i++)
        {
            excludedValues[i] = (int)excludedEnumValues[i];
        }
    }
}