using UnityEditor;
using UnityEngine;

public class LineRendererTool : MonoBehaviour
{
    [MenuItem("Tools/Reset LineRenderer Z Positions")]
    public static void ResetLineRendererZPositions()
    {
        // Find all LineRenderer components in the scene  
        LineRenderer[] lineRenderers = FindObjectsOfType<LineRenderer>();

        foreach (LineRenderer lineRenderer in lineRenderers)
        {
            int positionCount = lineRenderer.positionCount;
            Vector3[] positions = new Vector3[positionCount];

            // Get current positions  
            lineRenderer.GetPositions(positions);

            // Set Z to 0 for all points  
            for (int i = 0; i < positionCount; i++)
            {
                positions[i].z = 0;
            }

            // Apply updated positions  
            lineRenderer.SetPositions(positions);
        }

        Debug.Log("All LineRenderer Z positions have been reset to 0.");
    }

    // Create a naughty attributes button
    [NaughtyAttributes.Button("Reset LineRenderer Z Positions")]
    public void NaughtyResetLineRendererZPositions()
    {
        ResetLineRendererZPositions();
    }
}
