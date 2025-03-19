using UnityEngine;

namespace CollisionHelper
{
    public static class CollisionDetector
    {
        // Structure pour stocker les résultats de détection
        public struct CollisionInfo
        {
            public bool isCollidingLeft;
            public bool isCollidingRight;
            public bool isCollidingAbove;
            public bool isCollidingBelow;
            public Vector3 lastNormal; // Normale de la dernière collision détectée
        }

        // Dictionnaire pour stocker les informations de collision par GameObject
        private static System.Collections.Generic.Dictionary<int, CollisionInfo> collisionData = new System.Collections.Generic.Dictionary<int, CollisionInfo>();

        // Méthode pour initialiser le suivi des collisions pour un GameObject
        public static void InitializeCollisionTracking(GameObject gameObject)
        {
            if (gameObject == null) return;

            int instanceID = gameObject.GetInstanceID();
            if (!collisionData.ContainsKey(instanceID))
            {
                collisionData[instanceID] = new CollisionInfo();

                // Ajouter le composant de suivi s'il n'existe pas déjà
                if (gameObject.GetComponent<CollisionTracker>() == null)
                {
                    gameObject.AddComponent<CollisionTracker>();
                }
            }
        }

        // Méthode pour mettre à jour l'état de collision à partir des flags du CharacterController
        public static void UpdateCollisionFlags(GameObject gameObject, CollisionFlags flags)
        {
            if (gameObject == null) return;

            int instanceID = gameObject.GetInstanceID();
            if (!collisionData.ContainsKey(instanceID))
            {
                InitializeCollisionTracking(gameObject);
            }

            CollisionInfo info = collisionData[instanceID];

            // Mettre à jour les collisions verticales
            info.isCollidingBelow = (flags & CollisionFlags.Below) != 0;
            info.isCollidingAbove = (flags & CollisionFlags.Above) != 0;

            // Sauvegarder les informations mises à jour - TRÈS IMPORTANT
            collisionData[instanceID] = info;
        }

        // Méthode pour mettre à jour les informations de collision horizontale
        public static void UpdateCollisionNormal(GameObject gameObject, Vector3 normal)
        {
            if (gameObject == null) return;

            int instanceID = gameObject.GetInstanceID();
            if (!collisionData.ContainsKey(instanceID))
            {
                InitializeCollisionTracking(gameObject);
            }

            CollisionInfo info = collisionData[instanceID];

            // Sauvegarder la normale de collision
            info.lastNormal = normal;

            // Mettre à jour les collisions horizontales basées sur la normale
            if (normal.x > 0.7f)
            {
                info.isCollidingLeft = true;
                Debug.Log("CollisionDetector: Contact à gauche détecté pour " + gameObject.name);
            }

            if (normal.x < -0.7f)
            {
                info.isCollidingRight = true;
                Debug.Log("CollisionDetector: Contact à droite détecté pour " + gameObject.name);
            }

            // Sauvegarder les informations mises à jour - TRÈS IMPORTANT
            collisionData[instanceID] = info;
        }

        // Méthode pour réinitialiser les collisions à chaque frame (IMPORTANT)
        public static void ResetFrameCollisions(GameObject gameObject)
        {
            if (gameObject == null) return;

            int instanceID = gameObject.GetInstanceID();
            if (!collisionData.ContainsKey(instanceID))
            {
                InitializeCollisionTracking(gameObject);
                return;
            }

            // Récupérer les données actuelles
            CollisionInfo info = collisionData[instanceID];

            // Réinitialiser les collisions horizontales (elles seront mises à jour par OnControllerColliderHit)
            info.isCollidingLeft = false;
            info.isCollidingRight = false;

            // Sauvegarder les informations mises à jour - TRÈS IMPORTANT
            collisionData[instanceID] = info;
        }

        // Méthode pour obtenir les informations de collision
        public static CollisionInfo GetCollisionInfo(GameObject gameObject)
        {
            if (gameObject == null) return new CollisionInfo();

            int instanceID = gameObject.GetInstanceID();
            if (!collisionData.ContainsKey(instanceID))
            {
                InitializeCollisionTracking(gameObject);
            }

            return collisionData[instanceID];
        }

        // Classe interne pour suivre les collisions du CharacterController
        private class CollisionTracker : MonoBehaviour
        {
            private CharacterController controller;

            private void Start()
            {
                controller = GetComponent<CharacterController>();
                if (controller == null)
                {
                    Debug.LogError("CollisionTracker requires a CharacterController component!");
                    Destroy(this);
                }
            }

            private void OnControllerColliderHit(ControllerColliderHit hit)
            {
                // Mettre à jour les informations de collision avec la normale
                UpdateCollisionNormal(gameObject, hit.normal);
            }
        }
    }
}