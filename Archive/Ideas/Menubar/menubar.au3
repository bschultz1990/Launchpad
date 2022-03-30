#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>

$hGUI = GUICreate("Test", 250, 250)

$mFilemenu = GUICtrlCreateMenu("File")
$mAboutitem = GUICtrlCreateMenuItem("About", $mFilemenu)
$btnGithub = GUICtrlCreateLabel("https://github.com/bschultz1990/Launchpad/")
$mExititem = GUICtrlCreateMenuItem("Exit", $mFilemenu)
GUISetState()

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE, $mExititem
            Exit
        Case $mAboutitem
            MsgBox($MB_SYSTEMMODAL, "About", "Ben S. https://github.com/bschultz1990/Launchpad/")
    EndSwitch
WEnd