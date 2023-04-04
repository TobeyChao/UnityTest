using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DeviceTest : MonoBehaviour
{
    public Text text;
    // Start is called before the first frame update
    void Start()
    {
        string str = "";
        str += "deviceModel: " + SystemInfo.deviceModel + "\n";
        str += "deviceName: " + SystemInfo.deviceName + "\n";
        str += "deviceType: " + SystemInfo.deviceType + "\n";
        str += "deviceUniqueIdentifier: " + SystemInfo.deviceUniqueIdentifier + "\n";
        str += "Screen: width:" + Screen.width + " height:" + Screen.height + "\n";
        str += "Display.main: width:" + Display.main.systemWidth + " height:" + Display.main.systemHeight + "\n";
        text.text = str;
    }
}
