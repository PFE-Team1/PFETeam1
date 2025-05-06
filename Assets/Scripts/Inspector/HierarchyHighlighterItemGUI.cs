using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
#if UNITY_EDITOR
[InitializeOnLoad]
public class HierarchyHighlighterItemGUI
{
    private static Dictionary<Color, Texture2D> _colorsToTexturesDict = new Dictionary<Color, Texture2D>();

    static HierarchyHighlighterItemGUI()
    {
        EditorApplication.hierarchyWindowItemOnGUI += HierarchyWindowItem_CB;
    }

    private static void HierarchyWindowItem_CB(int selectionID, Rect selectionRect)
    {
        if (Event.current.type != EventType.Repaint) return;

        Object o = EditorUtility.InstanceIDToObject(selectionID);
        GameObject go = o as GameObject;
        if (null != go && go.activeSelf)
        {
            HierarchyHighlighter h = go.GetComponent<HierarchyHighlighter>();
            if ((h != null) && (h.highlight))
            {
                if (Event.current.type == EventType.Repaint)
                {
                    GUIStyle boxStyle = new GUIStyle();
                    boxStyle.normal.background = MakeTex1x1(h.backgroundColor);
                    GUI.backgroundColor = h.backgroundColor;
                    GUI.Box(selectionRect, "", boxStyle);
                    GUI.backgroundColor = Color.white;

                    if (h.sprite != null)
                    {
                        Rect spriteRect = new Rect(selectionRect.x, selectionRect.y, selectionRect.height, selectionRect.height);
                        GUI.DrawTexture(spriteRect, h.sprite.texture, ScaleMode.ScaleToFit);
                        selectionRect.x += selectionRect.height + 2;
                        selectionRect.width -= selectionRect.height + 2;
                    }

                    GUIStyle textStyle = new GUIStyle();
                    textStyle.normal.textColor = h.textColor;
                    textStyle.font = h.font;
                    textStyle.alignment = h.textAlignement;
                    textStyle.padding.left = h.paddingLeft;
                    textStyle.padding.right = h.paddingRight;
                    textStyle.padding.top = h.paddingTop;
                    textStyle.padding.bottom = h.paddingBottom;
                    textStyle.fontStyle = FontStyle.Bold;
                    GUI.Label(selectionRect, go.name, textStyle);
                }
            }
        }
    }

    private static Texture2D MakeTex1x1(Color col)
    {
        if (_colorsToTexturesDict.TryGetValue(col, out var cachedTexture))
        {
            return cachedTexture;
        }

        return MakeTex(1, 1, col);
    }

    public static Texture2D MakeTex(int width, int height, Color col)
    {
        if (_colorsToTexturesDict.TryGetValue(col, out var cachedTexture))
        {
            return cachedTexture;
        }

        Texture2D result = new Texture2D(width, height, TextureFormat.ARGB32, false);
        Color32[] pix = new Color32[width * height];
        Color32 color32 = col;
        for (int i = 0; i < pix.Length; ++i)
        {
            pix[i] = color32;
        }
        result.SetPixels32(pix);
        result.Apply();

        _colorsToTexturesDict[col] = result;
        return result;
    }
}
#endif