using System;
using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using ZXing;

/// <summary>
/// 二维码扫描识别类
/// </summary>
public class QRCodeScanning : MonoBehaviour
{
    public static QRCodeScanning _Instance;
    private void Awake() => _Instance = this;

    public Color32[] data;
    private bool isScan;
    public RawImage cameraTexture;
    public Text txtQRcode;
    private WebCamTexture webCameraTexture;
    private BarcodeReader barcodeReader;
    private float timer = 0;

    public void RequestAndroidPermission(string permission, Action<string> callback)
    {
#if UNITY_ANDROID
        var callbacks = new UnityEngine.Android.PermissionCallbacks();
        callbacks.PermissionDenied += (string permissionName) =>
        {
            callback("PermissionDenied");
        };
        callbacks.PermissionGranted += (string permissionName) =>
        {
            callback("PermissionGranted");
        };
        callbacks.PermissionDeniedAndDontAskAgain += (string permissionName) =>
        {
            callback("PermissionDeniedAndDontAskAgain");
        };
        UnityEngine.Android.Permission.RequestUserPermission(permission, callbacks);
#endif
    }

    void InitDevice()
    {
        barcodeReader = new BarcodeReader();
        RequestAndroidPermission(UnityEngine.Android.Permission.Microphone, (str) =>
        {
            if (str == "PermissionGranted")
            {
                StartCoroutine(StartScan());
            }
        });
    }

    IEnumerator StartScan()
    {
        yield return new WaitForSeconds(1);
#if UNITY_ANDROID
        if (UnityEngine.Android.Permission.HasUserAuthorizedPermission(UnityEngine.Android.Permission.Microphone))
        {
            Debug.Log("有权限");
            WebCamDevice[] devices = WebCamTexture.devices;
            string devicename = devices[0].name;
            webCameraTexture = new WebCamTexture(devicename, 400, 300);
            cameraTexture.texture = webCameraTexture;
            webCameraTexture.Play();
            isScan = true;
        }
        else
        {
            Debug.Log("没权限");
        }
#endif
    }

    void Update()
    {
        if (isScan)
        {
            timer += Time.deltaTime;

            if (timer > 0.5f) //0.5秒扫描一次
            {
                StartCoroutine(ScanQRcode());
                timer = 0;
            }
        }
    }

    IEnumerator ScanQRcode()
    {
        data = webCameraTexture.GetPixels32();
        DecodeQR(webCameraTexture.width, webCameraTexture.height);
        yield return new WaitForEndOfFrame();
    }

    private void DecodeQR(int width, int height)
    {
        var br = barcodeReader.Decode(data, width, height);
        if (br != null)
        {
            txtQRcode.text = br.Text;
            isScan = false;
            webCameraTexture.Stop();

            Application.OpenURL(txtQRcode.text);
        }
    }

    public void Scan()
    {
        InitDevice();
    }

    public void Stop()
    {
        isScan = false;
        webCameraTexture.Stop();
    }
}
