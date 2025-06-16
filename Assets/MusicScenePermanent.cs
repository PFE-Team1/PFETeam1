using UnityEngine;
using System.Collections;

public class MusicScenePermanent : MonoBehaviour
{
    public static MusicScenePermanent instance;
    [SerializeField] private AK.Wwise.Event[] _playMusicEvents;
    [SerializeField] private AK.Wwise.Event[] _stopMusicEvents;
    [SerializeField] private float _transitionDelay = 2f;
    
    private int _currentMusicIndex = 0;
    private Coroutine _musicTransitionCoroutine;

    void Awake()
    {
        if (instance == null)
        {
            instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }
    
    public void StartFirstMusic()
    {
        if (_playMusicEvents.Length > 0 && _currentMusicIndex < _playMusicEvents.Length)
        {
            var playEvent = _playMusicEvents[_currentMusicIndex];
            if (playEvent != null)
            {
                // Ensure the music persists across scenes
                DontDestroyOnLoad(gameObject);
                playEvent.Post(gameObject);
            }
        }
    }

    public void ChangeMusic()
    {
        if (_musicTransitionCoroutine != null)
        {
            StopCoroutine(_musicTransitionCoroutine);
        }
        _musicTransitionCoroutine = StartCoroutine(MusicTransition());
    }

    private IEnumerator MusicTransition()
    {
        if (_stopMusicEvents.Length > 0 && _currentMusicIndex < _stopMusicEvents.Length)
        {
            var stopEvent = _stopMusicEvents[_currentMusicIndex];
            if (stopEvent != null)
            {
                stopEvent.Post(gameObject);
            }
        }
        
        yield return new WaitForSeconds(_transitionDelay);
        
        _currentMusicIndex = (_currentMusicIndex + 1) % _playMusicEvents.Length;

        if (_playMusicEvents.Length > 0)
        {
            _playMusicEvents[_currentMusicIndex].Post(gameObject);
        }
        
        _musicTransitionCoroutine = null;
    }
}
