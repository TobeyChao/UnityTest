using UnityEngine;
using System.Collections;

/// <summary>
/// InputField
/// </summary>
public class NativeInputField : MonoBehaviour
{
    public NativeInputProcessor processor;

    private void Start()
    {
        NativeEditTextPlugin.Instance.Register(this);
    }

    private void OnDestroy()
    {
        NativeEditTextPlugin.Instance.UnRegister(processor.ID);
    }
}