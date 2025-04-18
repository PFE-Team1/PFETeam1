using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UIElements;
using System.Linq;

[InitializeOnLoad]
public static class ToolbarDropdown
{
    private static int selectedSceneIndex = -1;
    private static string[] sceneNames;
    private static string[] scenePaths;
    private static IMGUIContainer dropdownContainer;

    static ToolbarDropdown()
    {
        EditorApplication.update += OnEditorUpdate;
    }

    static void OnEditorUpdate()
    {
        if (dropdownContainer == null)
        {
            AddDropdownToToolbar();
        }
    }

    static void AddDropdownToToolbar()
    {
        LoadScenesFromBuildSettings();

        if (sceneNames == null || sceneNames.Length == 0)
            return;

        dropdownContainer = new IMGUIContainer(() =>
        {
            EditorGUI.BeginChangeCheck();
            selectedSceneIndex = EditorGUILayout.Popup(selectedSceneIndex, sceneNames, GUILayout.Width(200));

            if (EditorGUI.EndChangeCheck())
            {
                if (selectedSceneIndex >= 0 && selectedSceneIndex < scenePaths.Length)
                {
                    if (EditorSceneManager.SaveCurrentModifiedScenesIfUserWantsTo())
                    {
                        EditorSceneManager.OpenScene(scenePaths[selectedSceneIndex]);
                    }
                }
            }
        });

        if (EditorWindow.HasOpenInstances<SceneView>())
        {
            var editorWindow = EditorWindow.GetWindow<SceneView>();
            var root = editorWindow.rootVisualElement;

            if (root != null)
            {
                if (!root.Contains(dropdownContainer))
                {
                    root.Add(dropdownContainer);
                }
            }
        }
    }

    static void LoadScenesFromBuildSettings()
    {
        var scenes = EditorBuildSettings.scenes;
        sceneNames = scenes.Select(s => System.IO.Path.GetFileNameWithoutExtension(s.path)).ToArray();
        scenePaths = scenes.Select(s => s.path).ToArray();

        if (sceneNames.Length > 0)
        {
            selectedSceneIndex = 0;
        }
    }
}
