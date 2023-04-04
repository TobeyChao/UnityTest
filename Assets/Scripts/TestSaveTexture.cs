using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class SaveTexture : MonoBehaviour
{
    public Image image;

    void Start()
    {
        NativeGallery.SaveImageToGallery(image.sprite.texture, "nihao", "nihao.png");
    }

    public void OnClickDownload()
    {
        var req = UnityWebRequestTexture.GetTexture("https://img2018.cnblogs.com/i-beta/1725907/201911/1725907-20191120151023359-681945768.png");
        var op = req.SendWebRequest();
        op.completed += Op_completed;
    }

    private void Op_completed(AsyncOperation obj)
    {
        if (obj.isDone)
        {
            NativeGallery.SaveImageToGallery( image.sprite.texture, "nihao", "lalala.png");
        }
    }
}
