using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestScan : MonoBehaviour
{
    public void OnClickStart()
    {
        QRCodeScanning._Instance.Scan();
    }

    public void OnClickStop()
    {
        QRCodeScanning._Instance.Stop();
    }
}
