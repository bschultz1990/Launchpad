; #INDEX# ========================================================================================================================
; Title .........: _PopUpMenu
; AutoIt Version : 3.3.0.0+
; Language ......: English
; Description ...: For Creation and handling of popup context menus
; ================================================================================================================================

; #VERSION_INFO# =================================================================================================================
; Current version: 1.3
; ==============================================================================
; Version .......: 1.3
; Released ......: 26/09/2009 23:57:17
;   * fixed: Bug when holding down the hotkey setting off the function multiple times. (MrCreator)
;   * Added: New example showing the OnShow Functionality
;   * Added: Google-code project page for organizing the downloads easier!
; ==============================================================================
; Version .......: 1.2
; Released ......: 26/09/2009 19:44:07
;   * Added: OnShow option. Gives the ability to run a function before the menu shows (to update etc)
;   * fixed: OnEvent handling (now uses Dummy control) (Wraithdu)
;   * fixed: OnEvent mode still setting Msg-loop array (Wraithdu)
;   * fixed: Sleep (10) added to GetMsg function (MrCreator)
;   * fixed: some variable warnings from Au3Check (Wraithdu)
;   * fixed: OnEvent Functions with 1 or 0 parameters.
;   * fixed: OnShow can run both global and menu specific functions. (Wraithdu)
; ==============================================================================
; Version .......: 1.1
; Released ......: 26/09/2009 12:38:05
;   * Added: OnEvent mode
;   * Added: SetOption function ("OnEventMode" and "DataSeperatorChar")
;   * fixed: Clicking off now hides the menu (Wraithdu fixed, Yashieds found)
;   * fixed: Handling of Msg-Loop functions (Wraithdu)
; ==============================================================================
; Version .......: 1.0
; Released ......: 25/09/2009 11:23:27
;   * INITIAL RELEASE!!!!
; ================================================================================================================================

; #CURRENT# ======================================================================================================================
; _PopUpMenuCreate
; _PopUpMenuDelete
; _PopUpMenuDeleteAll
; _PopUpMenuCreateMenu
; _PopUpMenuCreateMenuItem
; _PopUpMenuDeleteMenu
; _PopUpMenuDeleteMenuItem
; _PopUpMenuGetMsg
; _PopUpMenuGetCount
; _PopUpMenuSetOnEventMode
; _PopUpMenuItemSetOption
; ================================================================================================================================

; #INTERNAL_USE_ONLY# ============================================================================================================
; __PopupMenuStart
; __PopUpMenuGetIndexFromHotkey
; __PopUpMenuGetIndexFromHWnd
; __PopUpMenu_WM_COMMAND
; __PopUpMenu_OnEventFunction
; __ArrayDelete
; ================================================================================================================================

; #OUT_DATED# ====================================================================================================================
; __PopUpMenuResetEvent
; ================================================================================================================================

; #VARIABLES# ====================================================================================================================
Global $POPUP_MENU_INFO[1][3] ; hotkey, label, menu
$POPUP_MENU_INFO[0][0] = 0
$POPUP_MENU_INFO[0][1] = GUICreate("", 0, 0, -200, -200, 0x80000000, 0x00000080) ; $WS_POPUP, $WS_EX_TOOLWINDOW
Global $DUMMY = GUICtrlCreateDummy()
GUICtrlSetOnEvent($DUMMY, "__PopUpMenu_OnEventFunction")
GUIRegisterMsg(0x0111, "__PopUpMenu_WM_COMMAND")
GUISetState()
Global $POPUP_MENU_EVENT[1][3]
Global $POPUP_MENU_ONEVENT[1][3]
$POPUP_MENU_ONEVENT[0][0] = 0 ; default is not on event
Global $POPUP_MENU_LASTUSED = 0
Global $POPUP_MENU_DATASEPERATOR = "|"
Global $POPUP_MENU_ONSHOW[1]
Global $OLDMODE = -1
; ================================================================================================================================

; #FUNCTION# =====================================================================================================================
; Name...........: _PopUpMenuCreate
; Description ...: Creates the context menu
; Syntax.........: _PopupMenuCreate ($sHotKey)
; Parameters ....: $sHotKey        - The hotkey to bring up the context menu
; Return values .: Success         - The handle to the newly created context menu
;                  Failure         - Returns 0, this is becouse the Hotkey cannot be set.
; Author ........: Mat
; Modified.......:
; Remarks .......:
; Related .......: _PopUpMenuDelete
; Link ..........;
; Example .......; Yes
; ================================================================================================================================

Func _PopupMenuCreate($sHotKey)
    Local $nCur = GUISwitch($POPUP_MENU_INFO[0][1])
    If $POPUP_MENU_INFO[0][0] <> 0 Then
        For $i = 1 To $POPUP_MENU_INFO[0][0]
            If $sHotKey = $POPUP_MENU_INFO[$i][0] Then Return _PopUpMenuDelete($sHotKey)
        Next
    EndIf
    $POPUP_MENU_INFO[0][0] += 1
    ReDim $POPUP_MENU_INFO[$POPUP_MENU_INFO[0][0] + 1][3]
    $POPUP_MENU_INFO[$POPUP_MENU_INFO[0][0]][0] = $sHotKey
    $POPUP_MENU_INFO[$POPUP_MENU_INFO[0][0]][1] = GUICtrlCreateLabel("", 0, 0, 0, 0)
    $POPUP_MENU_INFO[$POPUP_MENU_INFO[0][0]][2] = GUICtrlCreateContextMenu($POPUP_MENU_INFO[$POPUP_MENU_INFO[0][0]][1])
    ReDim $POPUP_MENU_EVENT[$POPUP_MENU_INFO[0][0] + 1][3]
    ReDim $POPUP_MENU_ONSHOW[$POPUP_MENU_INFO[0][0] + 1]
    $POPUP_MENU_LASTUSED = $POPUP_MENU_INFO[$POPUP_MENU_INFO[0][0]][2]
    GUISwitch($nCur)
    If HotKeySet($sHotKey, "__PopUpMenuStart") = 0 Then
        ReDim $POPUP_MENU_INFO[$POPUP_MENU_INFO[0][0]][3]
        $POPUP_MENU_INFO[0][0] -= 1
        Return SetError(1, 0, 0)
    EndIf
    Return $POPUP_MENU_INFO[$POPUP_MENU_INFO[0][0]][2]
EndFunc   ;==>_PopupMenuCreate

; #FUNCTION# =====================================================================================================================
; Name...........: _PopUpMenuDelete
; Description ...: Deletes the context menu
; Syntax.........: _PopupMenuDelete ( [$sHotKey] )
; Parameters ....: $sHotKey        - The hotkey whose context menu you want to delete. If -1 (default) then deletes all
; Return values .: Success         - 1
;                  Failure         - 0
; Author ........: Mat
; Modified.......:
; Remarks .......:
; Related .......: _PopUpMenuCreate
; Link ..........;
; Example .......; Yes
; ================================================================================================================================

Func _PopUpMenuDelete($sHotKey = -1)
    If $sHotKey = -1 Then Return _PopUpMenuDeleteAll()
    Local $i = __PopUpMenuGetIndexFromHotkey($sHotKey)
    If $i = -1 Then Return SetError(1, 0, 0)
    HotKeySet($sHotKey)
    __ArrayDelete($POPUP_MENU_INFO, $i)
    Return 1
EndFunc   ;==>_PopUpMenuDelete

; #FUNCTION# =====================================================================================================================
; Name...........: _PopUpMenuDeleteAll
; Description ...: Deletes all the current context menus
; Syntax.........: _PopupMenuDeleteAll ()
; Parameters ....: none
; Return values .: 1
; Author ........: Mat
; Modified.......:
; Remarks .......:
; Related .......: _PopUpMenuDelete
; Link ..........;
; Example .......; Yes
; ================================================================================================================================

Func _PopUpMenuDeleteAll()
    For $i = 1 To $POPUP_MENU_INFO[0][0]
        HotKeySet($POPUP_MENU_INFO[$i][0])
    Next
    ReDim $POPUP_MENU_INFO[1][3]
    $POPUP_MENU_INFO[0][0] = 0
    Return 1
EndFunc   ;==>_PopUpMenuDeleteAll

; #FUNCTION# =====================================================================================================================
; Name...........: _PopUpMenuCreateMenu
; Description ...: Creates a sub menu.
; Syntax.........: _PopupMenuCreateMenu ($sText, $hWnd)
; Parameters ....: $sText          - The text for the control to display
;                  $hWnd           - The Handle to the menu (default is last used)
; Return values .: Success         - The handle to the menu.
;                  Failure         - 0 and sets @Error:
;                                    > 1: hWnd parameter invalid
;                                    > 2: Error Creating the menu
; Author ........: Mat
; Modified.......:
; Remarks .......:
; Related .......: _PopUpMenuCreateMenuItem, _PopUpMenuDeleteMenu
; Link ..........;
; Example .......; Yes
; ================================================================================================================================

Func _PopUpMenuCreateMenu($sText, $hWnd = -1)
    If $hWnd = -1 Then $hWnd = $POPUP_MENU_LASTUSED
    Local $i = __PopUpMenuGetIndexFromHWnd($hWnd)
    If $i = -1 Then Return SetError(1, 0, 0)
    Local $temp = GUICtrlCreateMenu($sText, $hWnd)
    $POPUP_MENU_LASTUSED = $temp
    If $temp = 0 Then Return SetError(2, 0, 0)
    If $POPUP_MENU_INFO[$i][UBound($POPUP_MENU_INFO, 2) - 1] <> 0 Then _
            ReDim $POPUP_MENU_INFO[$POPUP_MENU_INFO[0][0] + 1][UBound($POPUP_MENU_INFO, 2) + 1]
    $POPUP_MENU_INFO[$i][UBound($POPUP_MENU_INFO, 2) - 1] = $temp
    Return $temp
EndFunc   ;==>_PopUpMenuCreateMenu

; #FUNCTION# =====================================================================================================================
; Name...........: _PopUpMenuDeleteMenu
; Description ...: Deletes a sub menu.
; Syntax.........: _PopupMenuDeleteMenu ( [$hWnd] )
; Parameters ....: $hWnd           - The Handle to the menu (default is last used)
; Return values .: Success         - 1
;                  Failure         - 0 and sets @Error:
;                                    > 1: hWnd parameter invalid
; Author ........: Mat
; Modified.......:
; Remarks .......: Doesn't delete sub items... but they can not be shown after a call to this function
; Related .......: _PopUpMenuCreateMenu, _PopUpMenuDeleteMenuItem
; Link ..........;
; Example .......; Yes
; ================================================================================================================================

Func _PopUpMenuDeleteMenu($hWnd = -1)
    Local $temp = 0
    If $hWnd = -1 Then $hWnd = $POPUP_MENU_LASTUSED
    Local $i = __PopUpMenuGetIndexFromHWnd($hWnd)
    Local $iExt = @extended
    If $i = -1 Then Return SetError(1, 0, 0)
    If $iExt = -1 Then ; first level menu
        Return _PopUpMenuDelete($POPUP_MENU_INFO[$i][0])
    Else
        $temp = GUICtrlDelete($hWnd)
        $POPUP_MENU_INFO[$i][$iExt] = ""
    EndIf
    Return $temp
EndFunc   ;==>_PopUpMenuDeleteMenu

; #FUNCTION# =====================================================================================================================
; Name...........: _PopUpMenuCreateMenuItem
; Description ...: Creates a menu Item
; Syntax.........: _PopupMenuCreateMenuItem ($sText [, $hWnd] )
; Parameters ....: $sText          - The text for the item to display
;                  $hWnd           - The Handle to the menu (default is last used)
; Return values .: Success         - The handle to the new menu item
;                  Failure         - 0 and sets @Error:
;                                    > 1: hWnd parameter invalid
; Author ........: Mat
; Modified.......:
; Remarks .......:
; Related .......: _PopUpMenuCreateMenu, _PopUpMenuDeleteMenuItem
; Link ..........;
; Example .......; Yes
; ================================================================================================================================

Func _PopUpMenuCreateMenuItem($sText, $hWnd = -1)
    If $hWnd = -1 Then $hWnd = $POPUP_MENU_LASTUSED
    Local $i = __PopUpMenuGetIndexFromHWnd($hWnd)
    If $i = -1 Then Return SetError(1, 0, 0)
    Local $temp = GUICtrlCreateMenuItem($sText, $hWnd)
    If $temp = 0 Then Return SetError(2, 0, 0)
    $POPUP_MENU_LASTUSED = $temp
    If $POPUP_MENU_INFO[$i][UBound($POPUP_MENU_INFO, 2) - 1] <> 0 Then _
            ReDim $POPUP_MENU_INFO[$POPUP_MENU_INFO[0][0] + 1][UBound($POPUP_MENU_INFO, 2) + 1]
    $POPUP_MENU_INFO[$i][UBound($POPUP_MENU_INFO, 2) - 1] = $temp
    Return $temp
EndFunc   ;==>_PopUpMenuCreateMenuItem

; #FUNCTION# =====================================================================================================================
; Name...........: _PopUpMenuDeleteMenuItem
; Description ...: Creates a menu Item
; Syntax.........: _PopupMenuDeleteMenuItem ( [$hWnd] )
; Parameters ....: $hWnd           - The Handle to the menu
; Return values .: Success         - The handle to the new menu item
;                  Failure         - 0 and sets @Error:
;                                    > 1: hWnd parameter invalid
; Author ........: Mat
; Modified.......:
; Remarks .......:
; Related .......: _PopUpMenuCreateMenuItem, _PopUpMenuDeleteMenu
; Link ..........;
; Example .......; Yes
; ================================================================================================================================

Func _PopUpMenuDeleteMenuItem($hWnd = -1)
    If $hWnd = -1 Then $hWnd = $POPUP_MENU_LASTUSED
    Local $i = __PopUpMenuGetIndexFromHWnd($hWnd)
    Local $iExt = @extended
    If $i = -1 Then Return SetError(1, 0, 0)
    Local $temp = GUICtrlDelete($hWnd)
    $POPUP_MENU_INFO[$i][$iExt] = ""
    For $i = 1 to UBound ($POPUP_MENU_ONEVENT, 1) - 1
        If $hWnd = $POPUP_MENU_ONEVENT[$i][0] Then __ArrayDelete ($POPUP_MENU_ONEVENT, $i)
    Next
    Return $temp
EndFunc   ;==>_PopUpMenuDeleteMenuItem

; #FUNCTION# =====================================================================================================================
; Name...........: _PopUpMenuGetMsg
; Description ...: Checks for any event messages
; Syntax.........: _PopUpMenuGetMsg ($hWnd)
; Parameters ....: $hWnd           - The Handle to the menu
; Return values .: Success         - The Message event code (or zero if no message)
;                  Failure         - 0 and sets @Error:
;                                    > 1: hWnd parameter invalid
; Author ........: Mat
; Modified.......: Wraithdu        - Resetting the events after being called
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ================================================================================================================================

Func _PopUpMenuGetMsg($hWnd)
    Sleep(10) ; throttle CPU
    Local $i = __PopUpMenuGetIndexFromHWnd($hWnd)
    If $i = -1 Then Return SetError(1, 0, 0)
    Local $ret = $POPUP_MENU_EVENT[$i][1] ; save return value
    ; reset events
    $POPUP_MENU_EVENT[$i][0] = 0
    $POPUP_MENU_EVENT[$i][1] = 0
    $POPUP_MENU_EVENT[$i][2] = 0
    Return $ret
EndFunc   ;==>_PopUpMenuGetMsg

; #FUNCTION# =====================================================================================================================
; Name...........: _PopUpMenuGetCount
; Description ...: Returns the amount of context menus currently created
; Syntax.........: _PopUpMenuGetCount ()
; Parameters ....: none
; Return values .: Success         - The count
; Author ........: Mat
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ================================================================================================================================

Func _PopUpMenuGetCount()
    Return $POPUP_MENU_INFO[0][0]
EndFunc   ;==>_PopUpMenuGetCount

; #FUNCTION# =====================================================================================================================
; Name...........: _PopUpMenuSetOption
; Description ...: Returns the amount of context menus currently created
; Syntax.........: _PopUpMenuSetOption ($sOption [, $iFlag] )
; Parameters ....: $sOption        - A string Showing the option. Currently supported:
;                                  > OnEventMode       | 1 = OnEventMode, 0 = NOT OnEventMode, -1 = Opposite to current
;                                  > DataSeperatorChar | The character to use when seperating Arguments etc. ("|" = default)
;                  $iFlag           - The flag for the option
; Return values .: Success         - 1
;                  Failure         - 0 And sets @ERROR:
;                                  > 1: Invalid $sOption parameter.
;                                  > 2: Invalid $iFlag parameter.
; Author ........: Mat
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ================================================================================================================================

Func _PopUpMenuSetOption($sOption, $iFlag = -1, $iFlag2 = -1)
    Switch $sOption
        Case "OnEventMode"
            If $iFlag = -1 Then
                If $POPUP_MENU_ONEVENT[0][0] = 1 Then
                    $POPUP_MENU_ONEVENT[0][0] = 0
                Else
                    $POPUP_MENU_ONEVENT[0][0] = 1
                EndIf
            ElseIf ($iFlag = 0) Or ($iFlag = 1) Then
                $POPUP_MENU_ONEVENT[0][0] = $iFlag
            Else
                Return SetError(2, 0, 0)
            EndIf
        Case "DataSeperatorChar"
            If $iFlag = -1 Then Return $POPUP_MENU_DATASEPERATOR
            If StringLen($iFlag) > 1 Then Return SetError(2, 0, 0)
            $POPUP_MENU_DATASEPERATOR = $iFlag
        Case "UseExtendedHotkeys"
            MsgBox(0, "Error", "Functionality Not Built in!")
            Return 0
        Case "RunOnShow"
            If $iFlag = -1 Then ; all
                $POPUP_MENU_ONSHOW[0] = $iFlag2
            Else
               $x = __PopUpMEnuGetIndexFromHotkey ($iFlag)
               If $x = -1 Then Return SetError (1, 0, 0)
               $POPUP_MENU_ONSHOW[$x] = $iFlag2
            EndIf
            Return 1
        Case Else
            Return SetError(1, 0, 0)
    EndSwitch
    Return 1
EndFunc   ;==>_PopUpMenuSetOption

; #FUNCTION# =====================================================================================================================
; Name...........: _PopUpMenuItemSetOnEvent
; Description ...: Sets the event handler when using an item in OnEvent Mode
; Syntax.........: _PopUpMenuItemSetOnEvent ($hWnd, $sFunc, $sArgs)
; Parameters ....: $hWnd           - Handle to the Item. -1 = last used
;                  $sFunc          - The function to call on event
;                  $sArgs          - A string seperated by POPUP_MENU_DATASEPERATOR to show the arguments for the function.
; Return values .: Success         - 1
;                  Failure         - 0 And sets @ERROR:
;                                  > 1: Invalid $hWnd parameter.
; Author ........: Mat
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ================================================================================================================================

Func _PopUpMenuItemSetOnEvent($hWnd, $sFunc, $sArgs)
    If $hWnd = -1 Then $hWnd = $POPUP_MENU_LASTUSED
    For $i = 1 To UBound($POPUP_MENU_ONEVENT, 1) - 1
        If $hWnd = $POPUP_MENU_ONEVENT[$i][0] Then Return __ArrayDelete($POPUP_MENU_ONEVENT, $i)
    Next
    ReDim $POPUP_MENU_ONEVENT[UBound($POPUP_MENU_ONEVENT, 1) + 1][3]
    $POPUP_MENU_ONEVENT[UBound($POPUP_MENU_ONEVENT, 1) - 1][0] = $hWnd
    $POPUP_MENU_ONEVENT[UBound($POPUP_MENU_ONEVENT, 1) - 1][1] = $sFunc
    $POPUP_MENU_ONEVENT[UBound($POPUP_MENU_ONEVENT, 1) - 1][2] = $sArgs
EndFunc   ;==>_PopUpMenuItemSetOnEvent

; #INTERNAL_USE_ONLY#=============================================================================================================
; Name...........: __PopupMenuStart
; Description ...: Sends the open context menu message on hotkey pressed
; Syntax.........: __PopupMenuStart ()
; Parameters ....: none
; Return values .: none
; Author ........: Mat
; Modified.......: Wraithdu        - SetForeGroundWindow, means clicking off the menu hides it.
;                  MrCreator       - Makes sure that holding down the hotkey doesn't have side affects
; Remarks .......: do NOT run except from a hotkey, as it uses the @HOTKEYPRESED macro
; Related .......:
; Link ..........;
; Example .......; Yes
; ================================================================================================================================

Func __PopupMenuStart()
    Local $x = __PopUpMenuGetIndexFromHotkey(@HotKeyPressed)
    HotkeySet (@HotKeyPressed)
    If $x = -1 Then Return SetError (1, 0, 0)
    If $POPUP_MENU_ONSHOW[$x] <> "" Then
        If Not StringInStr ($POPUP_MENU_ONSHOW[$x], $POPUP_MENU_DATASEPERATOR) Then
            Call ($POPUP_MENU_ONSHOW[0])
        Else
           $temp = StringSplit ($POPUP_MENU_ONSHOW[$x], $POPUP_MENU_DATASEPERATOR)
           $sTemp = $temp[1]
           $temp = __ArrayDelete ($temp, 1)
           $temp[0] = "CallArgArray"
           Call ($sTemp, $temp)
        EndIf
    EndIf
    If $POPUP_MENU_ONSHOW[0] <> "" Then
        If Not StringInStr ($POPUP_MENU_ONSHOW[0], $POPUP_MENU_DATASEPERATOR) Then
            Call ($POPUP_MENU_ONSHOW[0])
        Else
           $temp = StringSplit ($POPUP_MENU_ONSHOW[0], $POPUP_MENU_DATASEPERATOR)
           $sTemp = $temp[1]
           $temp = __ArrayDelete ($temp, 1)
           $temp[0] = "CallArgArray"
           Call ($sTemp, $temp)
        EndIf
    EndIf
    DllCall("user32.dll", "int", "SetForegroundWindow", "hwnd", $POPUP_MENU_INFO[0][1])
    DllCall("user32.dll", "ptr", "SendMessage", _
            "hwnd", ControlGetHandle($POPUP_MENU_INFO[0][1], _
            "", $POPUP_MENU_INFO[$x][1]), _
            "int", 0x007B, _
            "int", $POPUP_MENU_INFO[$x][1], _
            "int", 0)
    HotkeySet (@HotKeyPressed, "__PopupMenuStart")
EndFunc   ;==>__PopupMenuStart

; #INTERNAL_USE_ONLY#=============================================================================================================
; Name...........: __PopupMenu_WM_COMMAND
; Description ...: The Message handler
; Syntax.........: __PopupMenu_WM_COMMAND ($hWnd, $msgID, $l, $r)
; Parameters ....: Standard windows message params.
; Return values .: none
; Author ........: Mat
; Modified.......: Wraithdu        - Uses Dummy Control method
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ================================================================================================================================

Func __PopUpMenu_WM_COMMAND($hWnd, $msgID, $l, $r)
    #forceref $hWnd, $msgID, $l, $r
    If $hWnd <> $POPUP_MENU_INFO[0][1] Then Return "GUI_RUNDEFMSG"
    Local $i = __PopUpMenuGetIndexFromHwnd($l)
    If $POPUP_MENU_ONEVENT[0][0] Then ; on event mode
        $OLDMODE = Opt("GUIOnEventMode", 1) ; change to OnEventMode temporarily, save old state
        GUICtrlSendToDummy($DUMMY, $l) ; send trigger to Dummy control with control ID
    Else ; getmsg mode
        $POPUP_MENU_EVENT[$i][0] = $hWnd
        $POPUP_MENU_EVENT[$i][1] = $l
    EndIf
    Return "GUI_RUNDEFMSG"
EndFunc   ;==>__PopUpMenu_WM_COMMAND

; #INTERNAL_USE_ONLY#=============================================================================================================
; Name...........: __PopUpMenu_OnEventFunction
; Description ...: The OnEvent Mode Function Handler
; Syntax.........: __PopUpMenu_OnEventFunction()
; Parameters ....: none
; Return values .: none
; Author ........: Wraithdu
; Modified.......:
; Remarks .......: Used to make sure WM_COMMAND returns quickly, whilst this does the dirty work!
; Related .......:
; Link ..........;
; Example .......;
; ================================================================================================================================

Func __PopUpMenu_OnEventFunction()
    Local $temp
    Opt("GUIOnEventMode", $OLDMODE) ; switch back to the old GUI mode
    Local $param = GUICtrlRead($DUMMY) ; get control ID
    For $i = 1 To UBound($POPUP_MENU_ONEVENT, 1) - 1
        If $POPUP_MENU_ONEVENT[$i][0] <> $param Then ContinueLoop
        If StringInStr ($POPUP_MENU_ONEVENT[$i][2], $POPUP_MENU_DATASEPERATOR) Then
           $temp = StringSplit($POPUP_MENU_ONEVENT[$i][2], $POPUP_MENU_DATASEPERATOR)
           $temp[0] = "CallArgArray"
           Call($POPUP_MENU_ONEVENT[$i][1], $temp)
           ExitLoop
        ElseIf $POPUP_MENU_ONEVENT[$i][2] = "" Then
           Call ($POPUP_MENU_ONEVENT[$i][1])
        Else
           Call ($POPUP_MENU_ONEVENT[$i][1], $POPUP_MENU_ONEVENT[$i][2])
        EndIf
    Next
EndFunc   ;==>__OnEventFunction

; #INTERNAL_USE_ONLY#=============================================================================================================
; Name...........: __PopupMenuGetIndexFromHotkey
; Description ...: Returns the index of the item using the given hotkey
; Syntax.........: __PopupMenuGetIndexFromHotkey ($sHotkey)
; Parameters ....: $sHotkey        - The hotkey to search for
; Return values .: Success         - The index
;                  Failure         - -1, and @ERROR is set to 1
; Author ........: Mat
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ================================================================================================================================

Func __PopUpMenuGetIndexFromHotkey($sHotKey)
    For $i = 1 To $POPUP_MENU_INFO[0][0]
        If $sHotKey = $POPUP_MENU_INFO[$i][0] Then Return $i
    Next
    Return SetError(1, 0, -1)
EndFunc   ;==>__PopUpMenuGetIndexFromHotkey

; #INTERNAL_USE_ONLY#=============================================================================================================
; Name...........: __PopupMenuGetIndexFromHWnd
; Description ...: Returns the index of the item using the given handle
; Syntax.........: __PopupMenuGetIndexFromHWnd ($hWnd)
; Parameters ....: $sHotkey        - The handle to search for
; Return values .: Success         - The index
;                  Failure         - -1, and @ERROR is set to 1
; Author ........: Mat
; Modified.......:
; Remarks .......: @EXTENDED is set to the sub index, if it exists. If not it is set to -1.
; Related .......:
; Link ..........;
; Example .......; Yes
; ================================================================================================================================

Func __PopUpMenuGetIndexFromHWnd($hWnd)
    For $i = 1 To $POPUP_MENU_INFO[0][0]
        If $hWnd = $POPUP_MENU_INFO[$i][2] Then Return SetExtended(-1, $i)
        For $x = 3 To UBound($POPUP_MENU_INFO, 2) - 1 ; sub menus + items
            If $hWnd = $POPUP_MENU_INFO[$i][$x] Then Return SetExtended($x, $i)
        Next
    Next
    Return SetError(1, 0, 1)
EndFunc   ;==>__PopUpMenuGetIndexFromHWnd

; #INTERNAL_USE_ONLY#=============================================================================================================
; Name...........: __ArrayDelete
; Description ...: Deletes the specified element from the given array.
; Syntax.........: __ArrayDelete ($avArray, $iElement)
; Parameters ....: $avArray        - Array to modify
;                  $iElement       - Element to delete
; Return values .: Success         - New size of the array
;                  Failure         - 0, sets @error to:
;                                  > 1: $avArray is not an array
;                                  > 3: $avArray has too many dimensions (only up to 2D supported)
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - array passed ByRef
;                  Ultima - 2D arrays supported, reworked function (no longer needs temporary array; faster when deleting from end)
; Remarks .......: If the array has one element left (or one row for 2D arrays), it will be set to "" after _ArrayDelete() is used on it.
; Related .......: _ArrayAdd, _ArrayInsert, _ArrayPop, _ArrayPush
; Link ..........;
; Example .......; Yes
; ================================================================================================================================

Func __ArrayDelete($avArray, $iElement)
    If Not IsArray($avArray) Then Return SetError(1, 0, 0)
    Local $iUBound = UBound($avArray, 1) - 1
    If Not $iUBound Then
        $avArray = ""
        Return 0
    EndIf
    If $iElement < 0 Then $iElement = 0
    If $iElement > $iUBound Then $iElement = $iUBound
    Switch UBound($avArray, 0)
        Case 1
            For $i = $iElement To $iUBound - 1
                $avArray[$i] = $avArray[$i + 1]
            Next
            ReDim $avArray[$iUBound]
        Case 2
            Local $iSubMax = UBound($avArray, 2) - 1
            For $i = $iElement To $iUBound - 1
                For $j = 0 To $iSubMax
                    $avArray[$i][$j] = $avArray[$i + 1][$j]
                Next
            Next
            ReDim $avArray[$iUBound][$iSubMax + 1]
        Case Else
            Return SetError(3, 0, 0)
    EndSwitch
    Return $avArray
EndFunc   ;==>__ArrayDelete
