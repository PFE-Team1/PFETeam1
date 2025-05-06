using UnityEngine;

namespace KeyIconHelper
{
    [System.Serializable]
    public class KeyIcon
    {
        public string keyName;
        public Sprite KeyboardIcon;
        public Sprite ControllerIcon;

        public KeyIcon()
        {
        }

        public KeyIcon(string keyName, Sprite keyboardIcon, Sprite controllerIcon)
        {
            this.keyName = keyName;
            this.KeyboardIcon = keyboardIcon;
            this.ControllerIcon = controllerIcon;
        }
    }
}
