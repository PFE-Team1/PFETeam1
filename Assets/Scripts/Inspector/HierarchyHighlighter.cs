using UnityEngine;

public class HierarchyHighlighter : MonoBehaviour 
{
    public Sprite sprite;
    public bool highlight = true;
    public Color backgroundColor = Color.black;
    public Color textColor = Color.white;
    public TextAnchor textAlignement = TextAnchor.MiddleLeft;
    public Font font;
    public int paddingLeft = 0;
    public int paddingRight = 0;
    public int paddingTop = 0;
    public int paddingBottom = 0;
}