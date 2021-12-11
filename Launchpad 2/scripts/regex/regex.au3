; Regular expression test

#include <Array.au3>
#include <AutoItConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>

Global $regexAMZ = "P01-[A-Za-z0-9]{7}-[A-Za-z0-9]{7}-[A-Za-z0-9]{7}|P01-[A-Za-z0-9]{7}-[A-Za-z0-9]{7}"
Global $regexCRD = "\d{11}"
Global $regexPPL = "[A-Za-z0-9]{17}"


If (StringRegExp($memo, $regexAMZ, 0, 1) = 1) Then
    $amzMemo = StringRegExp($memo, $regexAMZ, 1)
    GUICtrlSetData($statusBar,"Amazon Payments: "&$amzMemo[0] )

    ElseIf(StringRegExp($memo, $regexCRD, 0, 1) = 1) Then
        $crdMemo = StringRegExp($memo, $regexCRD, 1)
        GUICtrlSetData($statusBar,"Card: "&$crdMemo[0])
    ElseIf(StringRegExp($memo, $regexPPL, 0, 1)= 1) Then
        $pplMemo = StringRegExp($memo, $regexPPL, 1)
        GUICtrlSetData($statusBar,"PayPal: " &$pplMemo[0])
    Else
        GUICtrlSetData($statusBar,"No match.")
EndIf