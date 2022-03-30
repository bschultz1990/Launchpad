#include <GuiConstants.au3>

Global $Flag = 1

$hGui = GUICreate(":-)", 240, 120)

$URL_Label = GUICtrlCreateLabel("Welcome to AutoIT forum", 60, 40, 130, 16)
GUICtrlSetCursor(-1, 0)
;GUICtrlSetBkColor(-1, 0xFF0000)

GUISetState()

While 1
    $msg = GUIGetMsg()
    
    Switch $msg
    Case $GUI_EVENT_CLOSE
        ExitLoop
    Case $GUI_EVENT_MOUSEMOVE
        $aCurPos = GUIGetCursorInfo()
        
        If $aCurPos[4] = $URL_Label And $Flag = 1 Then
            GUICtrlSetColor($URL_Label, 0xFF0000)
            GUICtrlSetFont($URL_Label, Default, Default, 2)
            $Flag = 0
        ElseIf $aCurPos[4] <> $URL_Label And $Flag = 0 Then
            GUICtrlSetColor($URL_Label, 0x000000)
            GUICtrlSetFont($URL_Label, Default)
            $Flag = 1
        EndIf
    Case $URL_Label
        ShellExecute("http://www.autoitscript.com/forum")
    EndSwitch
WEnd