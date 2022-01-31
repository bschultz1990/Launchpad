
#include "PopUpMenu.au3"

_PopUpMenuSetOption ("OnEventMode", 1)
_PopUpMenuSetOption ("RunOnShow", -1, "_UpdateList")

Global $ahItems[1]

Global $hMenu = _PopUpMenuCreate ("{PAUSE}")
   Global $hList = _PopUpMenuCreateMenu ("Windows...", $hMenu)
_PopUpMenuCreateMenuItem ("Exit", $hMenu)
   _PopUpMenuItemSetOnEvent (-1, "_Exit", "")

While 1
WEnd

Func _UpdateList ()
   $aList = _WinListEx ()
   For $i = 1 To UBound ($ahItems) - 1
      _PopUpMenuDeleteMenuItem ($ahItems[$i])
   Next
   ReDim $ahItems[$aList[0][0] + 1]
   For $i = 1 to $aList[0][0]
      $ahItems[$i] = _PopUpMenuCreateMenuItem ($aList[$i][0], $hList)
         If $aList[$i][2] Then GUICtrlSetState ($ahItems[$i], 1)
         _PopUpMenuItemSetOnEvent ($ahItems[$i], "SetOnTop", $aList[$i][0])
   Next
EndFunc ; ==> _UpdateList

Func SetOnTop ($hWnd)
   MsgBox (0, "", $hWnd)
   If IsOnTop ($hWnd) Then
      WinSetOnTop ($hWnd, "", 0)
   Else
      WinSetOnTop ($hWnd, "", 1)
   EndIf
EndFunc ; ==> SetOnTop

Func _WinListEx ()
   $aList = WinList ()
   Local $aTemp[1][4]
      $aTemp[0][0] = 0
   For $i = 1 to $aList[0][0]
      If $aList[$i][0] = "" Then ContinueLoop
      If BitAnd (WinGetState ($aList[$i][1], ""), 2) = 0 Then ContinueLoop
      $aTemp[0][0] += 1
      ReDim $aTemp[UBound ($aTemp, 1) + 1][4]
      $aTemp[UBound ($aTemp, 1) - 1][0] = $aList[$i][0]
      $aTemp[UBound ($aTemp, 1) - 1][1] = $aList[$i][1]
      $aTemp[UBound ($aTemp, 1) - 1][2] = IsOnTop ($aList[$i][1])
   Next
   Return $aTemp
EndFunc ; ==> _WinListEx

Func IsOnTop ($hWnd)
   $aRet = DllCall("User32.dll", "int", "GetWindowLong", "hwnd", $hWnd, "int", 0xFFFFFFEC) ; Get Window Ex Style
   Return BitAnd ($aRet[0], 0x00000008) <> 0
EndFunc ; ==> IsOnTop

Func _Exit ()
   Exit
EndFunc ; ==> _Exit
