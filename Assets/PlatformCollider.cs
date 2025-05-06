using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(LineRenderer))]
public class LineToMeshCollider : MonoBehaviour
{
    public float width = 0.2f;
    public float depth = 1f;

    void Start()
    {
        LineRenderer line = GetComponent<LineRenderer>();
        Vector3[] positions = new Vector3[line.positionCount];
        line.GetPositions(positions);

        Mesh mesh = BuildExtrudedMesh(positions, width, depth);

        MeshCollider collider = gameObject.AddComponent<MeshCollider>();
        collider.sharedMesh = mesh;
        collider.convex = false; // laisser en false pour une forme précise
    }

    Mesh BuildExtrudedMesh(Vector3[] points, float width, float depth)
    {
        List<Vector3> vertices = new List<Vector3>();
        List<int> triangles = new List<int>();

        int count = points.Length;

        // Étape 1 : créer les bords gauche et droite du ruban
        for (int i = 0; i < count; i++)
        {
            Vector3 forward = Vector3.zero;

            if (i < count - 1)
                forward += points[i + 1] - points[i];
            if (i > 0)
                forward += points[i] - points[i - 1];

            forward.Normalize();
            Vector3 left = Vector3.Cross(forward, Vector3.forward).normalized;

            vertices.Add(points[i] + left * (width / 2)); // top surface left
            vertices.Add(points[i] - left * (width / 2)); // top surface right
        }

        int offset = vertices.Count;

        // Étape 2 : créer les mêmes vertices décalés sur Z
        for (int i = 0; i < count; i++)
        {
            vertices.Add(vertices[i * 2] + Vector3.back * depth);     // bottom left
            vertices.Add(vertices[i * 2 + 1] + Vector3.back * depth); // bottom right
        }

        // Étape 3 : triangles top
        for (int i = 0; i < count - 1; i++)
        {
            int tl = i * 2;
            int tr = i * 2 + 1;
            int bl = (i + 1) * 2;
            int br = (i + 1) * 2 + 1;

            // Face supérieure
            triangles.Add(tl);
            triangles.Add(bl);
            triangles.Add(tr);

            triangles.Add(tr);
            triangles.Add(bl);
            triangles.Add(br);
        }

        // Étape 4 : triangles inférieurs
        for (int i = 0; i < count - 1; i++)
        {
            int tl = offset + i * 2;
            int tr = offset + i * 2 + 1;
            int bl = offset + (i + 1) * 2;
            int br = offset + (i + 1) * 2 + 1;

            // Face inférieure (inversée)
            triangles.Add(tr);
            triangles.Add(bl);
            triangles.Add(tl);

            triangles.Add(br);
            triangles.Add(bl);
            triangles.Add(tr);
        }

        // Étape 5 : côtés latéraux
        for (int i = 0; i < count - 1; i++)
        {
            int i0 = i * 2;
            int i1 = i0 + 1;
            int i2 = i0 + 2;
            int i3 = i0 + 3;

            int b0 = offset + i0;
            int b1 = offset + i1;
            int b2 = offset + i2;
            int b3 = offset + i3;

            // Left side
            triangles.Add(i0);
            triangles.Add(b2);
            triangles.Add(b0);
            triangles.Add(i0);
            triangles.Add(i2);
            triangles.Add(b2);

            // Right side
            triangles.Add(i1);
            triangles.Add(b1);
            triangles.Add(b3);
            triangles.Add(i1);
            triangles.Add(b3);
            triangles.Add(i3);
        }

        Mesh mesh = new Mesh();
        mesh.SetVertices(vertices);
        mesh.SetTriangles(triangles, 0);
        mesh.RecalculateNormals();
        mesh.RecalculateBounds();
        return mesh;
    }
}
