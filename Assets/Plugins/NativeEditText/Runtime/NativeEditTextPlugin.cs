using System;
using System.Collections.Generic;
using LitJson;
using UnityEngine;

public class NativeEditTextPlugin : MonoBehaviour
{
    private const String GameObjectName = "NativeEditTextPlugin";
    private static NativeEditTextPlugin _instance = null;
    private static bool _isDestroyed = false;

    private INativeEditText _platform = null;
    private bool _isInitialized = false;

    private Dictionary<int, NativeInputProcessor> _processors;
    private int _counter;

    public static NativeEditTextPlugin Instance
    {
        get
        {
            return _instance;
        }
    }

    private void Awake()
    {
        DontDestroyOnLoad(gameObject);
        _instance = this;
        _instance.Initialize();
    }

    private void Initialize()
    {
        if (_isInitialized)
            return;
        _isInitialized = true;

        gameObject.name = GameObjectName;

#if UNITY_EDITOR
        _platform = gameObject.AddComponent<NativeEditTextEditor>();
#elif UNITY_ANDROID
        _platform = gameObject.AddComponent<NativeEditTextAndroid>();
#elif UNITY_IOS
        _platform = gameObject.AddComponent<NativeEditTextiOS>();
#else
        Debug.LogError("This platform is not supported.");
#endif
    }

    private void OnDestroy()
    {
        if (this == _instance)
        {
            _instance = null;
            _isDestroyed = true;
        }
    }

    public void ProcessData(string data)
    {
        Debug.Log("Plugins receive data: " + data);
        try
        {
            var info = JsonMapper.ToObject(data);
            int id = (int)info["ID"];
            if (_processors.ContainsKey(id))
            {
                NativeInputProcessor plugin = _processors[id];
                plugin.ProcessData(info);
            }
            else
            {
                Debug.LogError(string.Format("{0} plugin does not exists", id));
            }
        }
        catch (Exception e)
        {
            Debug.LogError(string.Format("NativeEditTextPlugin receive error: {0}, stack: {1}", e.Message, e.StackTrace));
        }
    }

    internal int Register(NativeInputField nativeEditText)
    {
        // 为InputField创建Processor
        var processor = new NativeInputProcessor()
        {
            InputField = nativeEditText
        };
        nativeEditText.processor = processor;
        // 创建原生层控件

        // 添加进Dic
        _counter++;
        _processors.Add(_counter, processor);
        return _counter;
    }

    internal void UnRegister(int ID)
    {
        if (_processors.ContainsKey(ID))
        {
            // 销毁原生层控件
            _processors.Remove(ID);
        }
    }
}