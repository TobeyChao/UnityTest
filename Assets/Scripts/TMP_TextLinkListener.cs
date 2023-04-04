using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;

public class TMP_TextLinkListener : MonoBehaviour, IPointerClickHandler
{
    public TextMeshProUGUI textMeshProUGUI;
    private Camera uiCamera;

    public delegate void OnTMP_TextLinkClick(string LinkID, string LinkText);

    private OnTMP_TextLinkClick onTMP_TextLinkClick;

    public void OnClick(Camera camera, OnTMP_TextLinkClick callback)
    {
        uiCamera = camera;
        onTMP_TextLinkClick = callback;
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (uiCamera == null || onTMP_TextLinkClick == null)
        {
            return;
        }
        Vector3 pos = new Vector3(eventData.position.x, eventData.position.y, 0);
        int linkIndex = TMP_TextUtilities.FindIntersectingLink(textMeshProUGUI, pos, uiCamera); //--UIÏà»ú
        if (linkIndex > -1)
        {
            TMP_LinkInfo linkInfo = textMeshProUGUI.textInfo.linkInfo[linkIndex];
            onTMP_TextLinkClick?.Invoke(linkInfo.GetLinkID(), linkInfo.GetLinkText());
        }
    }
}
