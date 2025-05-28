using UnityEngine;
using AK.Wwise; // Nécessaire pour Wwise

public class ZoneDetection : MonoBehaviour
{
    [Header("Paramètres Wwise")]
    [SerializeField] private AK.Wwise.Event ambianceEvent; // Événement Wwise à jouer
    [SerializeField] private bool showDebugGizmos = true; // Pour visualiser la zone et le point de son

    private Transform player; // Référence au joueur trouvée automatiquement
    private GameObject ambianceFollower;
    private Collider2D zoneCollider; // Collider 2D de la zone
    private bool isPlayerInside = false; // Suivi de l'état du joueur
    private bool hasPlayedSound = false;
    private Vector2 currentSoundPosition;

    private void Start()
    {
        // Vérifie que la zone a bien un collider 2D et qu'il est en mode Trigger
        zoneCollider = GetComponent<Collider2D>();
        if (zoneCollider == null)
        {
            Debug.LogError($"⚠️ Aucun Collider2D trouvé sur {gameObject.name}. Ajoute-en un !");
            return;
        }
        if (!zoneCollider.isTrigger)
        {
            Debug.LogWarning($"⚠️ Le Collider2D de {gameObject.name} devrait être un Trigger !");
        }

        // Crée un GameObject pour l'audio qui suivra le joueur ou se clampera à la zone
        ambianceFollower = new GameObject($"{gameObject.name}_AmbianceFollower");
        DontDestroyOnLoad(ambianceFollower);
    }

    private void Update()
    {
        if (player == null)
        {
            // Cherche spécifiquement le PlayerWithAnimator(Clone)
            GameObject playerObj = GameObject.Find("PlayerWithAnimator(Clone)");
            if (playerObj != null)
            {
                player = playerObj.transform;
                Debug.Log("PlayerWithAnimator(Clone) trouvé");
                
                if (!hasPlayedSound && ambianceEvent != null)
                {
                    ambianceEvent.Post(ambianceFollower);
                    hasPlayedSound = true;
                    Debug.Log($"🎵 Événement Wwise attaché à l'ambianceFollower");
                }
            }
        }

        UpdateSoundPosition();
    }

    private void UpdateSoundPosition()
    {
        if (player == null || ambianceFollower == null) return;

        if (isPlayerInside)
        {
            // Si le joueur est dans la zone, le son le suit directement
            currentSoundPosition = player.position;
        }
        else
        {
            // Si le joueur est hors de la zone, on clampe le son à la limite de la trigger box
            currentSoundPosition = zoneCollider.ClosestPoint((Vector2)player.position);
        }

        // Met à jour la position du son
        ambianceFollower.transform.position = new Vector3(currentSoundPosition.x, currentSoundPosition.y, 0f);
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.name == "PlayerWithAnimator(Clone)")
        {
            isPlayerInside = true;
            Debug.Log($"📍 PlayerWithAnimator(Clone) entré dans {gameObject.name}");
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.gameObject.name == "PlayerWithAnimator(Clone)")
        {
            isPlayerInside = false;
            Debug.Log($"🏞️ PlayerWithAnimator(Clone) sorti de {gameObject.name}");
        }
    }

    private void OnDrawGizmos()
    {
        if (!showDebugGizmos) return;

        // Dessine la position du son en mode debug
        if (Application.isPlaying && ambianceFollower != null)
        {
            Gizmos.color = Color.yellow;
            Gizmos.DrawWireSphere(currentSoundPosition, 0.5f);
        }
    }
}
