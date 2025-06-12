using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
public class FPSCounter : MonoBehaviour
{
    public int avgFrameRate;
    public TextMeshProUGUI display_Text;
    public float updateDelay = 0.5f;
    
    private float timer = 0f;
    private int frameCount = 0;
    private float totalFrameTime = 0f;
    private int lowestFPS = 0;
    private int highestFPS = 0;
    public void Update()
    {
        timer += Time.unscaledDeltaTime;

        if (timer >= updateDelay)
        {
            float current = 1f / Time.unscaledDeltaTime;

            frameCount++;
            totalFrameTime += Time.unscaledDeltaTime;
            float averageFPS = frameCount / totalFrameTime;

            if (lowestFPS == 0 || current < lowestFPS)
                lowestFPS = Mathf.RoundToInt(current);

            if (current > highestFPS)
                highestFPS = Mathf.RoundToInt(current);

            display_Text.text = $"Average FPS: {Mathf.RoundToInt(averageFPS)}\nActual FPS: {Mathf.RoundToInt(current)}\nLowest: {lowestFPS}\nHighest: {highestFPS}";

            avgFrameRate = (int)current;

            timer = 0f;
        }
    }
}