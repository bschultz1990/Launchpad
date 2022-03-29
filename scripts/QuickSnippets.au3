_PopUpMenuSetOption ("OnEventMode", 1)

Global $hMenu = _PopUpMenuCreate ("^`")
Global $Oos = _PopUpMenuCreateMenuItem ("Out of Stock", $hMenu)
Global $Fraud = _PopUpMenuCreateMenuItem ("Fraud?", $hMenu)
Global $Backordered = _PopUpMenuCreateMenuItem ("Backordered", $hMenu)
Global $BadAddress = _PopUpMenuCreateMenuItem ("Bad Address", $hMenu)
Global $BadAddressContacted = _PopUpMenuCreateMenuItem ("Bad Address, Contacted", $hMenu)
Global $EmailTracking = _PopUpMenuCreateMenuItem ("Email, Tracking", $hMenu)
Global $EmailShippingChange = _PopUpMenuCreateMenuItem ("Email, Shipping Change", $hMenu)
Global $ExitButton = _PopUpMenuCreateMenuItem ("Change Initials", $hMenu)

Global $OosText = "Item out of stock. Order and payment entered."
Global $FraudText = "Potential fraud. Order and payment entered."
Global $BoText = "Item backordered. Order and payment entered."
Global $BadAddressText = "Hello! We're processing your Pellethead order and your shipping address () is showing undeliverable via USPS. Since this is such a light order, do you have an alternate address or a PO box we could use? Please reply to this message at your earliest convenience so we can get this order rolling for you. Thanks!"
Global $BadAddressContactedText = "Contacted customer about bad address. Order and payment entered."
Global $EmailTrackingText = "Hello! Thanks for reaching out! Your tracking number is below and order attached. I just created the label, so it might take up to 1 business day to show movement."
Global $EmailShippingChangeText = "Hello! I'm contacting you in regard to your recent Pellethead.com order. The shipping service you requested (First Class Mail International) was not available for your package.  USPS was giving an estimate as far out as 999 days. However, we managed to upgrade you to FedEx International Ground at no extra cost. Your tracking number is below. It may take a day to show movement, as the label just got created. Thank you in advance for understanding and hope you have a great rest of day."

Global $InitialsCounter = 0

;~ EVENTS SECTION
_PopUpMenuItemSetOnEvent ($Oos, "Oos", "")
_PopUpMenuItemSetOnEvent ($Fraud, "Fraud", "")
_PopUpMenuItemSetOnEvent ($Backordered, "Backordered", "")
_PopUpMenuItemSetOnEvent ($BadAddress, "BadAddress", "")
_PopUpMenuItemSetOnEvent ($BadAddressContacted, "BadAddressContacted", "")
_PopUpMenuItemSetOnEvent ($EmailTracking, "EmailTracking", "")
_PopUpMenuItemSetOnEvent ($EmailShippingChange, "EmailShippingChange", "")
_PopUpMenuItemSetOnEvent ($ExitButton, "ChangeInitials", "")

While 1
WEnd

;~ FUNCTIONS SECTION

Func Oos()
    InitialsCheck()
    ClipPut($OosText & $SigDate)
    _ToolTip("Text copied!", 1500)
EndFunc

Func Fraud()
    InitialsCheck()
    ClipPut($FraudText & $SigDate)
    _ToolTip("Text copied!", 1500)
EndFunc

Func Backordered()
    InitialsCheck()
    ClipPut($BoText & $SigDate)
    _ToolTip("Text copied!", 1500)
EndFunc

Func BadAddress()
    InitialsCheck()
    ClipPut($BadAddressText & $SigDate)
    _ToolTip("Text copied!", 1500)
EndFunc

Func BadAddressContacted()
    InitialsCheck()
    ClipPut($BadAddressContactedText & $SigDate)
    _ToolTip("Text copied!", 1500)
EndFunc

Func EmailTracking()
    InitialsCheck()
    ClipPut($EmailTrackingText & $SigDate)
    _ToolTip("Text copied!", 1500)
Endfunc

Func EmailShippingChange()
    InitialsCheck()
    ClipPut($EmailshippingChangeText & $SigDate)
    _ToolTip("Text copied!", 1500)
EndFunc

Func InitialsCheck()
    If $InitialsCounter = 0 Then
    Global $Initials = InputBox("Initials", "Enter your initials", "", "", 200, 128)
    $InitialsCounter = 1
EndIf
    Global $SigDate = " ~" & $Initials &" " & _NowDate()
    Return $Initials
EndFunc

Func _ToolTip($msg = "", $timeout = 1000, $xpos = MouseGetPos(0), $ypos = MouseGetPos(1))
    ToolTip($msg)
    AdlibRegister(_ToolTipStop, $timeout)
EndFunc
Func _ToolTipStop()
    ToolTip("")
    AdlibUnRegister(_ToolTipStop)
EndFunc

Func ChangeInitials()
    $InitialsCounter = 0
    InitialsCheck()
EndFunc ; ==> ChangeInitials