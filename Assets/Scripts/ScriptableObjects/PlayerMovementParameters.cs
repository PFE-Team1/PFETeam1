using UnityEngine;


[CreateAssetMenu(fileName = "Data", menuName = "ScriptableObjects/PlayerMovementParameters", order = 1)]
public class PlayerMovementParameters : ScriptableObject
{
    #region Jump

    [Header("Jump")]

    [Range(0, 16f)]
    [Tooltip("Force de saut")] public float jumpMaxHeight = 5f;
    [Range(0, 6)]
    [Tooltip("Time to reach jumpheight")] public float jumpDuration = 5;
    [Range(0, 10f)]
    [Tooltip("Saut Min")] public float minJump = 5;
    [Range(0, 20)]
    [Tooltip("% of jumpforce subtracted to run speed")] public float inertieLoss = 5f;

    [Range(0, 6)]
    [Tooltip("Air Acceleration time")] public float jumpAccelerationTime = 5;
    [Range(0, 6)]
    [Tooltip("Air Acceleration time")] public float jumpDecelerationTime = 5;
    [Range(0, 50)]
    [Tooltip("Air max Speed X")] public float jumpMaxSpeedX = 5;

    [Range(0, 3)]
    [Tooltip("Jump Buffer")] public float jumpBuffer = 2f;

    //[Range(0, 10)]
    //[Tooltip("Temps alloué au joueur pour sauter alors qu'il n'est plus sur la plateforme")] public float CoyoteWindow = 5f;

    #endregion

    #region Fall

    [Header("Fall")]
    [Range(0, 20)]
    [Tooltip("Fall speed")] public float fallDuration = 5;
    [Range(0, 50)]
    [Tooltip("Fall speed maximale")] public float maxFallSpeed = 5;
    [Range(0, 6)]
    [Tooltip("Fall speed acceleration time")] public float fallAccelerationTime = 5;
    [Range(0, 6)]
    [Tooltip("Fall speed acceleration time")] public float fallDecelerationTime = 5;
    [Range(0, 50)]
    [Tooltip("fall max X Speed")] public float fallMaxSpeedX = 5;


    #endregion

    #region Run
    [Header("Run")]
    [Range(0, 50)]
    [Tooltip("Vitesse maximale horizontale du joueur")] public float maxSpeed = 5;
    [Range(0, 10)]
    [Tooltip("Temps que prend le joueur a Accélerer")] public float accelerationTime = 5;
    [Range(0, 10)]
    [Tooltip("Temps que prend le joueur a Décélérer")] public float decelerationTime = 5;
    #endregion


}