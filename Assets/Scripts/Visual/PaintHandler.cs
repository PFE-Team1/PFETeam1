using Spine;
using Spine.Unity;
using UnityEngine;

public class PaintHandler : MonoBehaviour
{
    [SerializeField] public SkeletonPartsRenderer BodyPartRenderer;
    [SerializeField] public SkeletonPartsRenderer ArmPartRenderer;
    [HideInInspector] public SkeletonMecanim SkeletonMecanim;

    private Spine.AnimationState spineAnimationState;

    // to capture event "Footstep" when it's placed outside of folders
    void Grab()
    {
    }
    void Clonecreation()
    {
    }

    void Dooropening()
    {
    }

    void Place()
    {
    }

    void Pushbutton()
    {
    }
}