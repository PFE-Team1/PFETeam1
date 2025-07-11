using Spine;
using Spine.Unity;
using UnityEngine;

public class PaintHandler : MonoBehaviour
{
    [SerializeField] public SkeletonPartsRenderer BodyPartRenderer;
    [SerializeField] public SkeletonPartsRenderer ArmPartRenderer;
    [HideInInspector] public SkeletonMecanim SkeletonMecanim;
    [HideInInspector] public PaintingController CurrentPaintingController;

    private Spine.AnimationState spineAnimationState;


    public void ChangeLayer(int LayerID)
    {
        ArmPartRenderer.MeshRenderer.sortingLayerID = LayerID;
        BodyPartRenderer.MeshRenderer.sortingLayerID = LayerID;
    }

    public void ChangeSortingorder(int sortingOrder)
    {
        ArmPartRenderer.MeshRenderer.sortingOrder = sortingOrder+1;
        BodyPartRenderer.MeshRenderer.sortingOrder = sortingOrder-1;
    }

    // to capture event "Footstep" when it's placed outside of folders
    void Grab()
    {
        if (CurrentPaintingController != null)
        {
            CurrentPaintingController.GrabPainting();
        }
    }
    void Clonecreation()
    {
    }

    void Dooropening()
    {
    }

    void Place()
    {
        if (CurrentPaintingController != null)
        {
            CurrentPaintingController.DropPainting();
        }
    }

    void Pushbutton()
    {
    }

    void Footstep()
    {
        AudioManager.Instance.FOL_Pas.Post(gameObject);
    }
}