using UnityEngine;


[CreateAssetMenu(fileName = "Data", menuName = "ScriptableObjects/PlayerMovementParameters", order = 1)]
public class PlayerMovementParameters : ScriptableObject
{
    #region Jump

    [Header("Jump")]

    [Range(0, 10f)]
    [Tooltip("Force de saut")] public float jumpMaxHeight = 5f;
    [Range(0, 10)]
    [Tooltip("Time to reach jumpheight")] public float jumpDuration = 5;
    [Range(0, 10f)]
    [Tooltip("Saut Min")] public float minJump = 5;
    [Range(0, 10)]
    [Tooltip("% of jumpforce subtracted to run speed")] public float inertieLoss = 5f;

    [Range(0, 10)]
    [Tooltip("Air Acceleration time")] public float JumpAccelerationTime = 5;
    [Range(0, 10)]
    [Tooltip("Air max Speed X")] public float airMaxSpeedX = 5;

    [Range(0, 10)]
    [Tooltip("Jump Buffer")] public float jumpBuffer = 5f;

    [Range(0, 10)]
    [Tooltip("Temps alloué au joueur pour sauter alors qu'il n'est plus sur la plateforme")] public float CoyoteWindow = 5f;

    #endregion

    #region Fall

    [Header("Fall")]
    [Range(0, 10)]
    [Tooltip("Fall speed")] public float fallDuration = 5;
    [Range(0, 10)]
    [Tooltip("Fall speed maximale")] public float maxFallSpeed = 5;
    [Range(0, 10)]
    [Tooltip("Fall speed acceleration time")] public float fallAccelerationTime = 5;
    [Range(0, 10)]
    [Tooltip("fall max X Speed")] public float fallMaxSpeedX = 5;
    [Range(0, 10)]
    [Tooltip("fall max X Speed")] public float instantFallingTurnAround = 5;
    [Tooltip("should the player instantly stop when releasing X inputs")] public bool instantXStop = true;
    [Tooltip("instantly turn around in the air ?")] public bool instantTurnAroundInAir = true;


    #endregion

    #region Run
    [Header("Run")]
    [Range(0, 10)]
    [Tooltip("Vitesse maximale horizontale du joueur")] public float maxSpeed = 5;
    [Range(0, 10)]
    [Tooltip("Temps que prend le joueur a Accélerer")] public float accelerationTime = 5;
    [Range(0, 10)]
    [Tooltip("Temps que prend le joueur a Décélérer")] public float decelerationTime = 5;
    #endregion


}