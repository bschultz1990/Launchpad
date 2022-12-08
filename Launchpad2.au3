; Function Reference
; https://www.autoitscript.com/autoit3/docs/functions.htm

; UDF Functions
; https://www.autoitscript.com/autoit3/docs/libfunctions.htm

; Language Reference
; https://www.autoitscript.com/autoit3/docs/intro/lang_operators.htm

#include <Array.au3>
#include <AutoItConstants.au3>
#include <ButtonConstants.au3>
#include <ColorConstantS.au3>
#include <Date.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>

#include <GuiTreeView.au3>

;~ ; CUSTOM SCRIPTS
#include <scripts\PopUpMenu.au3>
#include <scripts\ExtInputBox.au3>


AutoItSetOption("GUIOnEventMode", 1); Turn onEventMode On.
_PopUpMenuSetOption ("OnEventMode", 1)
AutoItSetOption("WinTitleMatchMode", 2); Match any substring in the window title.
AutoItSetOption("ExpandVarStrings", 1); Expand variables when called like $var$.


; GUI SECTION
Global $AppTitle = "Launchpad 2"
Global $AppVersion = "v. 2.1.2"
Global $AppWidth = 400
Global $AppHeight = 68
;~ Global $MainWindow = GUICreate($AppTitle, $AppWidth, $AppHeight, @DesktopWidth-$AppWidth-5, @DesktopHeight-$AppHeight-32)
Global $MainWindow = GUICreate($AppTitle, $AppWidth, $AppHeight)

; GLOBAL VARIABLES
Global $input
Global $orderArray
Global $EvosusWindow = "Evosus";
; Global $EvosusWindow = "TEST MODE!"
Global $ShipworksWindow = "ShipWorks"
Global $NotepadWindow = WinGetHandle("Notepad")
Global $pmtMemo[1] ; Payment memo placeholder until we have some data.
Global $regexAMZ = "P01-[A-Za-z0-9]{7}-[A-Za-z0-9]{7}-[A-Za-z0-9]{7}|P01-[A-Za-z0-9]{7}-[A-Za-z0-9]{7}"
Global $regexCRD = "\b\d{11}"
Global $regexPPL = "[A-Za-z0-9]{17}"
Global $regexPHN = "\(?\d{3}\)?[\s-]?\d{3}[\s-]?\d{4}"
Global $regexPHN10 = "\d{10}$"
Global $regexCA = "[A-Za-z0-9]{3}\s?[A-Za-z0-9]{3}"

; POPUP MENU VARIABLES
Global $hMenu = _PopUpMenuCreate ("^`")
Global $Oos = _PopUpMenuCreateMenuItem ("&Out of Stock", $hMenu)
Global $Fraud = _PopUpMenuCreateMenuItem ("Frau&d?", $hMenu)
Global $FraudNote = _PopUpMenuCreateMenuItem ("Fraud Msg. &Note", $hMenu)
Global $Backordered = _PopUpMenuCreateMenuItem ("B&ackordered", $hMenu)
Global $BadAddressContacted = _PopUpMenuCreateMenuItem ("&Bad Address, Contacted", $hMenu)
Global $eMenu = _PopUpMenuCreateMenu("&Emails", $hMenu)
Global $BadAddress = _PopUpMenuCreateMenuItem ("Bad &Address", $eMenu)
Global $EmailFraud = _PopUpMenuCreateMenuItem ("&Fraud", $eMenu)
Global $EmailTracking = _PopUpMenuCreateMenuItem ("&Tracking", $eMenu)
Global $EmailShippingChange = _PopUpMenuCreateMenuItem ("&Shipping Change", $eMenu)
Global $ExitButton = _PopUpMenuCreateMenuItem ("&Change Initials", $hMenu)

Global $OosText = "Item out of stock."
Global $FraudText = "Potential fraud. Order and payment entered."
Global $FraudNoteText = "Contacted customer about order issue. Requested a call back. Hold order until "
Global $EmailFraudText[3] = ["Hello! There was an issue processing your Pellethead order "," and it has been put on hold. Please call us back at 920-779-6647 so we can get the order rolling for you. If we do not hear back by "," , your order will be cancelled and your payment refunded. Best regards,"]
Global $BoText = "Item backordered."
Global $BadAddressText[2] = ["Hello! We're processing your Pellethead order and your shipping address (", ") is showing undeliverable via USPS. Since this is such a light order, do you have an alternate address or a PO box we could use? Please reply to this message at your earliest convenience so we can get this order rolling for you. Thanks!"]
Global $BadAddressContactedText = "Contacted customer about bad address."
Global $EmailTrackingText = "Hello! Thanks for reaching out! Your tracking number is below and order attached. I just created the label, so it might take up to 1 business day to show movement."
Global $EmailShippingChangeText = "Hello! I'm contacting you in regard to your recent Pellethead.com order. The shipping service you requested (First Class Mail International) was not available for your package.  USPS was giving an estimate as far out as 999 days. However, we managed to upgrade you to FedEx International Ground at no extra cost. Your tracking number is below. It may take a day to show movement, as the label just got created. Thank you in advance for understanding and hope you have a great rest of day."

Global $InitialsCounter = 0

; SEARCH VARIABLES AND COLORS
Global $AmazonSearch = "https://sellercentral.amazon.com/orders-v3/order/"
Global $ebaySearch = "https://www.ebay.com/sh/ord/details?srn=118139&orderid="
Global $cartSearch[2] = ["https://pellethead.com/wp-admin/post.php?post=", "&action=edit"]
Global $wmSearch = "https://seller.walmart.com/order-management/details"

; https://coolors.co/9d66f4
Global $Color_Amazon = 0xfaa71a
Global $Color_Ebay = 0xf69699
Global $Color_Cart = 0xA471F5
Global $Color_WalMart = 0x74adff

Global $Btn_Info = GUICtrlCreateButton("i", 12, 12, 24, 24)
Global $Btn_Order = GUICtrlCreateButton("Import Order", 36, 12, 84, 24)

;Amazon buttons
Global $Btn_AzAddress = GUICtrlCreateButton("Chk. Address", 120, 12, 84, 24)
Global $Btn_AzCst = GUICtrlCreateButton("Enter Cst.", 204, 12, 84, 24)
Global $Btn_AzPmt = GUICtrlCreateButton("Az Payment", 288, 12, 84, 24)
GUICtrlSetBkColor($Btn_AzAddress, $Color_Amazon) ;~ Color the Amazon Buttons
GUICtrlSetBkColor($Btn_AzCst, $Color_Amazon)
GUICtrlSetBkColor($Btn_AzPmt, $Color_Amazon)

;eBay buttons
Global $Btn_ebLookCst = GUICtrlCreateButton("Lookup Cst.", 120, 12, 84, 24)
Global $Btn_EbCst = GUICtrlCreateButton("Enter Cst.", 204, 12, 84, 24)
Global $Btn_EbPmt = GUICtrlCreateButton("eBay Payment", 288, 12, 84, 24)
GUICtrlSetBkColor($Btn_ebLookCst, $Color_Ebay) ;~ Color the eBay Buttons
GUICtrlSetBkColor($Btn_EbCst, $Color_Ebay)
GUICtrlSetBkColor($Btn_EbPmt, $Color_Ebay)

;Cart Buttons
Global $Btn_CtLookup = GUICtrlCreateButton("Lookup Cst.", 120, 12, 84, 24)
Global $Btn_CtCst = GUICtrlCreateButton("Enter Cst.", 204, 12, 84, 24)
Global $Btn_CtCard = GUICtrlCreateButton("Pmt. - Card", 288, 12, 84, 24)
Global $Btn_CtPayPal = GUICtrlCreateButton("Pmt. - PayPal", 288, 12, 84, 24)
Global $Btn_CtAmazon = GUICtrlCreateButton("Payment - AZ", 288, 12, 84, 24)
GUICtrlSetBkColor($Btn_CtLookup, $Color_Cart) ; Color the Cart Buttons
GUICtrlSetBkColor($Btn_CtCst, $Color_Cart)
GUICtrlSetBkColor($Btn_CtCard, $Color_Cart)
GUICtrlSetBkColor($Btn_CtPayPal, $Color_Cart)
GUICtrlSetBkColor($Btn_CtAmazon, $Color_Cart)

Global $Label_Memo = GUICtrlCreateLabel("Enter memo -->", 298, 18); Memo notification.
Global $Btn_Memo = GUICtrlCreateButton("$", 372, 12, 24, 24); Resubmit memo button

;WalMart Buttons
Global $Btn_WmAddress = GUICtrlCreateButton("Lookup Cst.", 120, 12, 84, 24)
Global $Btn_WmCst = GUICtrlCreateButton("Enter Cst.", 204, 12, 84, 24)
Global $Btn_WmPmt = GUICtrlCreateButton("WM Payment", 288, 12, 84, 24)
GUICtrlSetBkColor($Btn_WmAddress, $Color_WalMart) ; Color the WalMart Buttons
GUICtrlSetBkColor($Btn_WmCst, $Color_WalMart)
GUICtrlSetBkColor($Btn_WmPmt, $Color_WalMart)

; Info Bars
Global $orderBar = GUICtrlCreateLabel("", 0, $AppHeight-20, $AppWidth, 20, $SS_SUNKEN)
Global $statusBar = GUICtrlCreateLabel("", 72, $AppHeight-20, $AppWidth-72, 20, $SS_SUNKEN)


; Set tooltips
GUICtrlSetTip($Btn_Info, "CTRL+ALT+i")
GUICtrlSetTip($Btn_Order, "CTRL+ALT+o")
GUICtrlSetTip($Btn_AzAddress, "CTRL+ALT+a")
GUICtrlSetTip($Btn_AzCst, "CTRL+ALT+c")
GUICtrlSetTip($Btn_AzPmt, "CTRL+ALT+p")
GUICtrlSetTip($Btn_ebLookCst, "CTRL+ALT+a")
GUICtrlSetTip($Btn_EbCst, "CTRL+ALT+c")
GUICtrlSetTip($Btn_EbPmt, "CTRL+ALT+p")
GUICtrlSetTip($Btn_WmAddress, "CTRL+ALT+a")
GUICtrlSetTip($Btn_WmCst, "CTRL+ALT+c")
GUICtrlSetTip($Btn_WmPmt, "CTRL+ALT+p")
GUICtrlSetTip($Btn_CtLookup, "CTRL+ALT+a")
GUICtrlSetTip($Btn_CtCst, "CTRL+ALT+c")
GUICtrlSetTip($Btn_CtCard, "CTRL+ALT+p")
GUICtrlSetTip($Btn_CtPayPal, "CTRL+ALT+p")
GUICtrlSetTip($Btn_CtAmazon, "CTRL+ALT+p")
GUICtrlSetTip($Btn_Memo, "CTRL+ALT+4")


; Disable and hide all but one button to start:
hideAmazonButtons()
hideEbayButtons()
hideWmButtons()
hideCartButtons()
hidePaymentButtons()

GUICtrlSetData($statusBar, $AppVersion) ; Show app version
GUISetState(@SW_SHOW) ; Show the main GUI.
WinActivate($MainWindow)
WinSetOnTop($AppTitle, "", $WINDOWS_ONTOP); Set Launchpad on top.


; END GUI SECTION

; ----------------------------------------------------------------------
; 							EVENTS SECTION
; ----------------------------------------------------------------------
While 1
	HotKeySet("^!q", "testFunc")

	HotKeySet("^+`", "console")

	GUISetOnEvent($GUI_EVENT_CLOSE, "closeMain")
	
	GUICtrlSetOnEvent($Btn_Info, "orderInfo")
	HotKeySet("^!i", "orderInfo")

	GUICtrlSetOnEvent($Btn_Order, "btnOrder")
	HotKeySet("^!o", "btnOrder")

	HotKeySet("{F2}", "deliverInvoice")
	HotKeySet("!a", "addSalesOrder")
	HotKeySet("!`", "printOrder")
	HotKeySet("!d", "printDeliverySlip")
	HotKeySet("!w", "ctrlWRemap")
	HotKeySet("!q", "altF4Remap")
	HotKeySet("^!d", "evosusDeposit") ; Secret Evosus Deposit Function! :)
	HotKeySet("^!s", "evosusStockLookup") ; Secret Stock Lookup Function! :)
	HotKeySet("^l", "itemFocus") ; Secret item focus function.
	HotKeySet("^!{NUMPADADD}", "printLabel") ; Secret print label function
	HotKeySet("^!\", "printLabel"); Alternate print label key for numpad-less keyboards.
	HotKeySet("^{ENTER}", "selectCustomer")
	HotKeySet("^!u", "updateCustomer"); Update Customer function

	GUICtrlSetOnEvent($Btn_Memo, "inputMemo")

	GUICtrlSetOnEvent($Btn_AzAddress, "btnAzAddress") ; AMAZON
	GUICtrlSetOnEvent($Btn_AzCst, "newCstImport")
	GUICtrlSetOnEvent($Btn_AzPmt, "payment")

	GUICtrlSetOnEvent($Btn_ebLookCst, "ebLook"); EBAY
	GUICtrlSetOnEvent($Btn_EbCst, "newCstImport")
	GUICtrlSetOnEvent($Btn_EbPmt, "payment")

	GUICtrlSetOnEvent($Btn_CtLookup, "ctLookup") ; CART
	GUICtrlSetOnEvent($Btn_CtCst, "newCstImport")
	GUICtrlSetOnEvent($Btn_CtCard, "payment") ; One function for multiple payment methods.
	GUICtrlSetOnEvent($Btn_CtPayPal, "payment")
	GUICtrlSetOnEvent($Btn_CtAmazon, "payment")

	GUICtrlSetOnEvent($Btn_WmAddress, "wmAddress") ; WAL-MART
	GUICtrlSetOnEvent($Btn_WmCst, "newCstImport")
	GUICtrlSetOnEvent($Btn_WmPmt, "payment")

	; POPUP MENU EVENTS SECTION
	_PopUpMenuItemSetOnEvent ($Oos, "Oos", "")
	_PopUpMenuItemSetOnEvent ($Fraud, "Fraud", "")
	_PopUpMenuItemSetOnEvent ($FraudNote, "FraudNote", "")
	_PopUpMenuItemSetOnEvent ($EmailFraud, "EmailFraud", "")
	_PopUpMenuItemSetOnEvent ($Backordered, "Backordered", "")
	_PopUpMenuItemSetOnEvent ($BadAddressContacted, "BadAddressContacted", "")
	_PopUpMenuItemSetOnEvent ($BadAddress, "BadAddress", "")
	_PopUpMenuItemSetOnEvent ($EmailTracking, "EmailTracking", "")
	_PopUpMenuItemSetOnEvent ($EmailShippingChange, "EmailShippingChange", "")
	_PopUpMenuItemSetOnEvent ($ExitButton, "ChangeInitials", "")
WEnd
; END EVENTS SECTION

; ----------------------------------------------------------------------
; 						BEGIN GENERAL FUNCTIONS
; ----------------------------------------------------------------------
; TEST FUNCTION SECTION
Func testFunc()

EndFunc ; testFunc()
; END TEST FUNCTION SECTION

Func console()
	Local $cData = _ExtInputBox(">", "Command|Arguments (Optional. Separate by ,)", 1)
	If ($cData = False) Then
		Return
	EndIf
	Local $userArgs = StringSplit($cData[2],",")
	$userArgs[0] = "CallArgArray" ;Tell Call() to recognize this as a bunch of arguments.
  ; TODO: Work on $userArgs[1] to $userArgs[N] and convert them from strings to variables.
  ; _ArrayDisplay($userArgs)
  Call($cData[1], $userArgs)
	If ($cData[1] = "az") Then
		Global $AmazonOrder = $AmazonSearch & $orderArray[3]
		ShellExecute ($AmazonOrder)
	ElseIf ($cData[1] = "ct") Then
		Global $CartOrder = $cartSearch[0] & $orderArray[2] & $cartSearch[1]
		ShellExecute($CartOrder)
	ElseIf ($cData[1] = "eb") Then
		Global $eBayOrder = $ebaySearch & $orderArray[4]
		ShellExecute($eBayOrder)
	ElseIf ($cData[1] = "wm") Then
		Global $wmOrder = $wmSearch
		ShellExecute($wmOrder)
	EndIf
EndFunc ; console()

Func deliverInvoice()
	ControlClick("Sales Order", "Select All", "[CLASS:ThunderRT6CommandButton; INSTANCE:5]")
	ControlClick("Sales Order", "Promote to Invoice >", "[CLASS:ThunderRT6CommandButton; INSTANCE:8]")
EndFunc ; deliverInvoice()

Func addSalesOrder()
  ControlClick($EvosusWindow, "Add", "[CLASS:ThunderRT6CommandButton; INSTANCE:132]")
EndFunc;addSalesOrder

Func printOrder()
	Send("{ALTDOWN}p{ALTUP}")
EndFunc ; printOrder()

Func printDeliverySlip()
	WinActivate($EvosusWindow)
	ControlClick($EvosusWindow, "Delivery Slip", "[CLASS:ThunderRT6CommandButton; INSTANCE:3]")
EndFunc ; printDeliverySlip()

Func ctrlWRemap()
	Send("{CTRLDOWN}{F4}{CTRLUP}")
EndFunc ; altWRemap()

Func altF4Remap()
	Send("{ALTDOWN}{F4}{ALTUP}")
EndFunc ; altQRemap()

Func taxCodeAbbr()
  Global $poText = ControlGetText($EvosusWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:10]")
  If ($poText = "") Then
    If UBound($orderArray) > 2 Then ; Check for an order first
    ; Why is "abbreviation" such a long word?
    If ($orderArray[1] = "Amazon") Or ($orderArray[1] = "Amazon.ca") Then
      ControlSetText($EvosusWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:10]", "az")
    ElseIf ($orderArray[1] = "esesstoves") Then
      ControlSetText($EvosusWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:10]", "eb")
    ElseIf ($orderArray[1] = "WalMart") Then
      ControlSetText($EvosusWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:10]", "wm")
    ElseIf ($orderArray[1] = "Earth Sense") Then
      ControlSetText($EvosusWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:10]", "ct")
    Else
      MsgBox(64, "Missing Order Info.", "Double check order details with the info button.") ; Info box.
      orderInfo() ; Show order info box right away.
    EndIf
  EndIf
  EndIf
  ; Taxes or not?
  If $orderArray[1]="Earth Sense" Then
    If ($orderArray[15]="Wisconsin") Then
      ControlCommand($EvosusWindow, "", "[CLASS:ThunderRT6ComboBox; INSTANCE:26]", "SelectString", "Eau Claire 5.5%")
    EndIf
  Else
    ControlCommand($EvosusWindow, "", "[CLASS:ThunderRT6ComboBox; INSTANCE:26]", "SelectString", "Out of State")
  EndIf
EndFunc ; taxCodeAbbr()

Func addDays($dayNum)
	Local $MyDate = _DateAdd("D", $dayNum, _NowCalc())
	Local $datePart, $timePart
	_DateTimeSplit($MyDate, $datePart, $timePart)
	Local $futureDate = ($datePart[2]&"/"&$datePart[3]&"/"&$datePart[1])
	Return $futureDate
EndFunc ; addDays()

Func newCstWinCheck()
	If WinActivate("New Customer") = 0 Then
	ControlClick($EvosusWindow, "Add Lead or Customer", 15) ; Click "Add Lead or Customer"
	WinWaitActive("New Customer", "", 2) ; Wait a second for the New Customer window to appear.
	EndIf
EndFunc ; newCstWinCheck()

Func selectCustomer()
	WinActivate($EvosusWindow, "")
	ControlClick($EvosusWindow, "Select This Customer", "[CLASS:ThunderRT6CommandButton; INSTANCE:8]")
EndFunc ; selectCustomer()



Func updateCustomer()
	Local $uData = InputBox("Update Profile", "What would you like to update? Separate the options by commas:."
	& @CRLF "Options:" & @CRLF &
	"n = Customer first and last name" & @CRLF &
	"a = Address lines 1 and 2" & @CRLF &
	"p = Add a phone number" & @CRLF &
	"e = Add email")
	ControlFocus($EvosusWindow, "", "[CLASS:ThunderRT6CommandButton; INSTANCE:60]")
	ControlClick($EvosusWindow, "", "[CLASS:ThunderRT6CommandButton; INSTANCE:60]"); Click update button
	Local $CLWin = WinWaitActive("Customer Location", "", 5); Wait 5 seconds for win to appear.
	If ($CLWin <> 0) Then
		ControlClick("Customer Location", "","[CLASS:ThunderRT6CommandButton; INSTANCE:4]")
		Local $CPhoneWin = WinWaitActive("New Phone Number", "", 5); Wait for New Phone Number to appear.
		If ($CPhoneWin <> 0) Then
			ClipPut($orderArray[17]); Load phone number
			ControlFocus("New Phone Number", "","[CLASS:MSMaskWndClass; INSTANCE:1]") ; Focus phone # field.
			ControlSend("New Phone Number", "", "[CLASS:MSMaskWndClass; INSTANCE:1]", "{CTRLDOWN}v{CTRLUP}"); Paste phone #
			ControlClick("New Phone Number", "&OK", "[CLASS:ThunderRT6CommandButton; INSTANCE:1]"); Click OK.
			Local $CConWin = WinWaitActive("New Phone Number", 5); Wait for Confirmation window to appear.
			If ($CConWin <> 0) Then
				WinActivate("New Phone Number")
				ControlFocus("New Phone Number", "OK", 2)
				ControlClick("New Phone Number", "OK", 2); Click OK.
			Else
			GUICtrlSetData($statusBar, "Confirmation box not found. :(")
			Return
			EndIf
		Return
		EndIf
		; you are here
	Else
	Return
	EndIf
EndFunc ; updateCustomer()



Func printLabel()
	WinActivate($ShipworksWindow, "") ; Activate ShipWorks window and click "Create Label."
	Send("{F10}")
EndFunc ; printLabel()

Func itemFocus()
	;~ WinActivate($EvosusWindow, "")
	ControlClick($EvosusWindow, "", "[CLASS:SSTabCtlWndClass; INSTANCE:1]", "left", 1, 236, 11) ; Click on "Items" tab.
	ControlFocus($EvosusWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:18]"); Focus Item field
EndFunc ; funcName()

Func evosusStockLookup() ; Secret Stock Lookup Function! :)
	WinActivate($EvosusWindow)
	ControlClick($EvosusWindow, "Show Stock Status", 99) ; Click on "Show Stock Status"
	taxCodeAbbr()
EndFunc ; evosusStockLookup()

Func evosusDeposit() ; Secret Evosus Deposit Function! :)
	ControlCommand($EvosusWindow, "", "[CLASS:ThunderRT6ComboBox; INSTANCE:25]", "SelectString", "Parts")
	taxCodeAbbr()
	WinActivate($EvosusWindow, "")
	ControlClick($EvosusWindow, "Make Deposit", 89) ; Click "Make Deposit"
EndFunc ; evosusPayment()

Func closeMain()
	If MsgBox(4+32, "Exit?", "Are you sure you want to exit?", 0, $MainWindow) = 6 Then ; Yes
		Exit
	EndIf
EndFunc

Func btnOrder()
	importOrder()
EndFunc ; $Btn_Order

Func canadaCheck()
	If StringRegExp($orderArray[16], $regexCA, 0) = 1 Then ;Yes or no result? No offset.
		Global $CAZip = StringRegExp($orderArray[16], $regexCA, 1) ; Return an array of matches. No offset.
		ControlFocus("New Customer", "", 69) ; Focus the dropdown control
		ControlCommand("New Customer", "", "[ID:69]", "SelectString", "Canada") ; Select "Canada"
	EndIf
EndFunc ; canadaCheck()

Func wmWebsite()
	ClipPut($orderArray[2]) ; Load WalMart order number into clipboard
	GUICtrlSetData($statusBar, "Copied WM Order number. Paste into Chrome.")
EndFunc ; wmWebsite()

Func btnAzAddress()
	Global $AmazonOrder = $AmazonSearch & $orderArray[3]
	ShellExecute($AmazonOrder)
	btnAddress()
EndFunc ; btnAzAddress()

Func btnAddress()
	If UBound($orderArray) > 10 Then ; If address field exists, do stuff.
		WinActivate($EvosusWindow)
		WinMenuSelectItem($EvosusWindow, "", "&Go To", "Customers")
		ControlClick($EvosusWindow, "Address", 52); Click on Address field
		ControlSetText($EvosusWindow, "","[CLASS:ThunderRT6TextBox; INSTANCE:5]", $orderArray[11]); Set address text
		ControlClick($EvosusWindow, "", 56); Click lookup customer.
	Else
		MsgBox(64, "Missing Order Info.", "Address line nonexistent. Review order info.") ; Info box.
		orderInfo() ; Show user info box right away.
	EndIf
	WinActivate($EvosusWindow)
EndFunc ; $Btn_AzAddress

Func bypassAndInvoice()
	; Create a new yes/no msg box on top of everything else
	Local $PaymentDetails = MsgBox(4+32+262144, "Info OK?", "Payment Details look good?", 0, $AppTitle)
	
	If ($PaymentDetails = $IDYES) Then
		WinActivate ($EvosusWindow) ; Activate Evosus window
		ControlClick($EvosusWindow, "Save Payment >", "[ID:22]") ; Click "Save Payment"
		Local $CCWin = WinWaitActive("Process Credit Card", "", 5)
			If ($CCWin <> 0) Then
			ControlFocus("Process Credit Card", "Bypass >", "[NAME:cmdBypass]")
			ControlClick("Process Credit Card", "Bypass >", "[NAME:cmdBypass]") ; Click "Bypass >"
			ElseIf ($CCWin = 0) Then
			Return
			EndIf
		Local $CBWin = WinWaitActive("Confirm Bypass", "", 5) ; click "Yes"
			If $CBWin <> 0 Then
			ControlClick("Confirm Bypass", "", "[ID:6]")
			ElseIf $CBWin = 0 Then
			Return
			EndIf
		Local $PWin = WinWaitActive("Payment", "", 5) ; Wait for "Successfully saved payment"
			If ($PWin <> 0) Then
			ControlClick("Payment", "", "[ID:2]") ; Click "OK"
			ElseIf ($PWin = 0) Then
			Return
			EndIf
		Local $DIWin = WinWaitActive("Deliver Items?", "", 10)
			If $DIWin <> 0 Then
			ControlClick("Deliver Items?", "", "[ID:7]") ; No. Don't Deliver.
			ElseIf $DIWin = 0 Then
			Return
			EndIf			
	
		; INVOICE ORDER
		WinActivate($EvosusWindow, 10)
		Local $EWinCheck = WinWaitActive ($EvosusWindow, "", 5)
		If ($EWinCheck <> 0) Then
			ControlClick($EvosusWindow, "", "[ID:233]") ; Options
			Sleep(120)
			Send("{DOWN}{DOWN}{DOWN}")
			Sleep(120)
			Send("{ENTER}")
		Else
			Return
		EndIf
		ElseIf	($PaymentDetails = $IDNO) Then
			Return
	EndIf
EndFunc ; bypassAndInvoice()

Func ctLookup()
	Global $CartOrder = $cartSearch[0] & $orderArray[2] & $cartSearch[1]
	ShellExecute($CartOrder)
	btnAddress()
EndFunc ; ctLookup()

Func ebLook()
	Global $eBayOrder = $ebaySearch & $orderArray[4]
	ShellExecute($eBayOrder)
	btnAddress() ; Look up address in Evosus.
EndFunc ; ebLook()

Func wmAddress()
	Global $wmOrder = $wmSearch
	ShellExecute($wmOrder)
	btnAddress()
	wmWebsite()
EndFunc ; wmAddress()

Func SetTextMenuLabels ()
  GUICtrlSetData($Oos, "Out of Stock")
  GUICtrlSetData($Fraud, "Fraud?")
  GUICtrlSetData($Backordered, "Backordered")
  GUICtrlSetData($BadAddressContacted, "Bad Address, Contacted")
  GUICtrlSetData($BadAddress, "Email, Bad Address")
  GUICtrlSetData($EmailTracking, "Email, Tracking")
  GUICtrlSetData($EmailShippingChange, "Email, Shipping Change")
  GUICtrlSetData($ExitButton, "Change Initials")
EndFunc

Func showAmazonButtons()

	GUICtrlSetState($Btn_AzAddress, $GUI_ENABLE + $GUI_SHOW) ; Enable and show Amazon buttons.
	GUICtrlSetState($Btn_AzCst, $GUI_ENABLE + $GUI_SHOW)
	GUICtrlSetState($Btn_AzPmt, $GUI_ENABLE + $GUI_SHOW)

	GUICtrlSetData($Btn_AzAddress, "Chk. Address") ; Re-set button labels. Keep them from disappearing.
	GUICtrlSetData($Btn_AzCst, "Enter Cst.")
	GUICtrlSetData($Btn_AzPmt, "Az Payment")
	GUICtrlSetData($Btn_Info, "i")
	GUICtrlSetData($Btn_Order, "Import Order")
	GUICtrlSetData($Btn_Memo, "$")

	; Re-set quick text labels. Keep them from disappearing.
	SetTextMenuLabels ()

	HotKeySet("^!a", "btnAzAddress") ; Set hotkeys for Amazon buttons.
	HotKeySet("^!c", "newCstImport")
	HotKeySet("^!p", "payment")
EndFunc ; showAmazonButtons()

Func showEbayButtons()
	GUICtrlSetState($Btn_ebLookCst, $GUI_ENABLE + $GUI_SHOW)
	GUICtrlSetState($Btn_EbCst, $GUI_ENABLE + $GUI_SHOW)
	GUICtrlSetState($Btn_EbPmt, $GUI_ENABLE + $GUI_SHOW)

	GUICtrlSetData($Btn_ebLookCst, "Lookup Cst.") ; Re-set button labels. Keep them from disappearing.
	GUICtrlSetData($Btn_EbCst, "Enter Cst.")
	GUICtrlSetData($Btn_EbPmt, "eBay Payment")
	GUICtrlSetData($Btn_Info, "i")
	GUICtrlSetData($Btn_Order, "Import Order")
	GUICtrlSetData($Btn_Memo, "$")

	; Re-set quick text labels. Keep them from disappearing.
	SetTextMenuLabels ()

	HotKeySet("^!a", "ebLook") ; Enable lookup hotkey
	HotKeySet("^!c", "newCstImport") ; Enable enter cst. hotkey
	HotKeySet("^!p", "payment") ; Enable memo hotkey
EndFunc ; showEbayButtons()

Func showCartButtons()
	GUICtrlSetState($Btn_CtCard, $GUI_DISABLE + $GUI_HIDE); Hide payment buttons in case they were used before.
	GUICtrlSetState($Btn_CtPayPal, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_CtAmazon, $GUI_DISABLE + $GUI_HIDE)

	GUICtrlSetState($Btn_CtLookup, $GUI_ENABLE + $GUI_SHOW) ; Show 2 Cart Buttons and payment memo field.
	GUICtrlSetState($Btn_CtCst, $GUI_ENABLE + $GUI_SHOW)
	GUICtrlSetState($Btn_Memo, $GUI_ENABLE + $GUI_SHOW) ; Show resubmit payment button.
	GUICtrlSetState($Label_Memo, $GUI_ENABLE + $GUI_SHOW); Show memo notification

	GUICtrlSetData($Btn_CtLookup, "Lookup Cst.") ; Re-set button labels. Keep them from disappearing.
	GUICtrlSetData($Btn_CtCst, "Enter Cst.")
	GUICtrlSetData($Btn_CtCard, "Pmt. - Card")
	GUICtrlSetData($Btn_CtPayPal, "Pmt. - PayPal")
	GUICtrlSetData($Btn_CtAmazon, "Payment - AZ")
	GUICtrlSetData($Btn_Info, "i")
	GUICtrlSetData($Btn_Order, "Import Order")
	GUICtrlSetData($Btn_Memo, "$")

	; Re-set quick text labels. Keep them from disappearing.
	SetTextMenuLabels ()
	
	HotKeySet("^!a", "ctLookup") ; Enable lookup hotkey
	HotKeySet("^!c", "newCstImport") ; Enable enter cst. hotkey
	HotKeySet("^!4", "inputMemo") ; Enable memo hotkey
EndFunc ; showCartButtons()

Func showWmButtons()
	GUICtrlSetState($Btn_WmAddress, $GUI_ENABLE + $GUI_SHOW) ; Show Walmart Buttons
	GUICtrlSetState($Btn_WmCst, $GUI_ENABLE + $GUI_SHOW)
	GUICtrlSetState($Btn_WmPmt, $GUI_ENABLE + $GUI_SHOW)

	GUICtrlSetData($Btn_WmAddress, "Lookup Cst.") ; Re-set button labels. Keep them from disappearing.
	GUICtrlSetData($Btn_WmCst, "Enter Cst.")
	GUICtrlSetData($Btn_WmPmt, "WM Payment")
	GUICtrlSetData($Btn_Info, "i")
	GUICtrlSetData($Btn_Order, "Import Order")
	GUICtrlSetData($Btn_Memo, "$")
	
	; Re-set quick text labels. Keep them from disappearing.
	SetTextMenuLabels ()

	HotKeySet("^!a", "wmAddress") ; Enable lookup hotkey
	HotKeySet("^!c", "newCstImport") ; Enable enter cst. hotkey
	HotKeySet("^!p", "payment") ; Enable memo hotkey
EndFunc ; showWmButtons()

Func hidePaymentButtons()
	GUICtrlSetState($Btn_CtCard, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_CtPayPal, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_CtAmazon, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_Memo, $GUI_DISABLE + $GUI_HIDE)
	GUiCtrlSetState($Label_Memo, $GUI_DISABLE + $GUI_HIDE)

	HotKeySet("^!p", "") ; Disable payment hotkey
	HotKeySet("^!4", "") ; Disable memo hotkey
EndFunc ;hidePaymentButtons

Func hideAmazonButtons()
	GUICtrlSetState($Btn_AzAddress, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_AzCst, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_AzPmt, $GUI_DISABLE + $GUI_HIDE)

	HotKeySet("^!a", "") ; Disable lookup hotkey
	HotKeySet("^!c", "") ; Disable enter cst. hotkey
	HotKeySet("^!p", "") ; Disable payment hotkey
EndFunc ; hideAmazonButtons()

Func hideEbayButtons()
	GUICtrlSetState($Btn_ebLookCst, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_EbCst, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_EbPmt, $GUI_DISABLE + $GUI_HIDE)

	HotKeySet("^!a", "") ; Disable lookup hotkey
	HotKeySet("^!c", "") ; Disable enter cst. hotkey
	HotKeySet("^!p", "") ; Disable payment hotkey
EndFunc ; hideEbayButtons()

Func hideCartButtons()
	GUICtrlSetState($Btn_CtLookup, $GUI_DISABLE + $GUI_HIDE) ; Hide Cart Buttons
	GUICtrlSetState($Btn_CtCst, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_CtCard, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_CtPayPal, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_CtAmazon, $GUI_DISABLE + $GUI_HIDE)
	
	HotKeySet("^!a", "") ; Disable lookup hotkey
	HotKeySet("^!c", "") ; Disable enter cst. hotkey
	HotKeySet("^!p", "") ; Disable payment hotkey
	HotKeySet("^!4", "") ; Disable memo hotkey
EndFunc ; hideCartButtons()

Func hideWmButtons()
	GUICtrlSetState($Btn_WmAddress, $GUI_DISABLE + $GUI_HIDE) ; Hide Walmart Buttons
	GUICtrlSetState($Btn_WmCst, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_WmPmt, $GUI_DISABLE + $GUI_HIDE)

	HotKeySet("^!a", "") ; Disable lookup hotkey
	HotKeySet("^!c", "") ; Disable enter cst. hotkey
	HotKeySet("^!p", "") ; Disable payment hotkey
EndFunc ; hideWmButtons()

Func clearOrder()
	GUICtrlSetData($input, "")
	GUICtrlSetData($orderArray, "") ; Clear order
	GUICtrlSetData($orderBar, "") ; Clear order type
	$pmtMemo[0] = "" ; Clear payment memo.
	GUICtrlSetData($statusBar, "") ; Clear status bar
	HotKeySet("^!a", "") ; Disable lookup hotkey
	HotKeySet("^!c", "") ; Disable enter cst. hotkey
	HotKeySet("^!p", "") ; Disable payment hotkey
EndFunc ; clearOrder

; END GENERAL FUNCTIONS


Func importOrder()
	$mainWinPos = WinGetPos($AppTitle) ; Returns an array
	WinSetOnTop($AppTitle, "", $WINDOWS_NOONTOP); Set main window not on top.
	$input = InputBox("Order:", "Copy and paste order:", "", "", 200, 128, $mainWinPos[0], $mainWinPos[1]) ;Keep the window from hiding under the main window

	; Don't overwrite old order info if we hit "Cancel."
	if @error = 1 Or $input = "" Then
		WinSetOnTop($AppTitle, "", $WINDOWS_ONTOP); Set Launchpad on top.
		return
	EndIf
	
	clearOrder() ; NOW clear all previous data.
	$orderArray = StringSplit($input, "	");

	WinSetOnTop($AppTitle, "", $WINDOWS_ONTOP); Set Launchpad on top.
	GUICtrlSetState($Btn_Memo, $GUI_ENABLE + $GUI_SHOW)

	If $orderArray[1] = "Amazon" Or $orderArray[1] = "Amazon.ca" Then
		GUICtrlSetData($statusBar, $orderArray[3]&" - "&$orderArray[9])
		If $orderArray[1] = "Amazon.ca" Then
			GUICtrlSetData($orderBar, "Amazon.ca") ; Oh, Canada!
			ElseIf $orderArray[1] = "Amazon" Then
				GUICtrlSetData($orderBar, "Amazon US") ; USA!
		EndIf

		hidePaymentButtons()
		showAmazonButtons()
		hideEbayButtons()
		hideCartButtons()
		hideWmButtons()

	ElseIf $orderArray[1] = "Earth Sense" Then
		GUICtrlSetData($orderBar, "Cart Order")
		GUICtrlSetData($statusBar, $orderArray[2]&" - "&$orderArray[9]) ; Show cart order number in status bar.

		hidePaymentButtons()
		hideAmazonButtons()
		hideEbayButtons()
		showCartButtons()
		hideWmButtons()

	ElseIf $orderArray[1] = "esesstoves" Then
		GUICtrlSetData($orderBar, "eBay Order")
		GUICtrlSetData($statusBar, $orderArray[4]&" - "&$orderArray[9])

		hidePaymentButtons()
		hideAmazonButtons()
		showEbayButtons()
		hideCartButtons()
		hideWmButtons()

	ElseIf $orderArray[1] = "WalMart" Then
		GUICtrlSetData($orderBar, "WalMart Order")
		GUICtrlSetData($statusBar, $orderArray[2]&" - "&$orderArray[9])

		hidePaymentButtons()
		hideAmazonButtons()
		hideEbayButtons()
		hideCartButtons()
		showWmButtons()
	Else
		GUICtrlSetData($orderBar, "")
		hidePaymentButtons()
		hideAmazonButtons()
		hideEbayButtons()
		hideCartButtons()
		hideWmButtons()
	EndIf
phoneFormatter()
EndFunc ; importOrder()

Func phoneFormatter()
	If UBound($orderArray) > 16 Then
		If StringRegExp($orderArray[17], $regexPHN10, 0, 2) = 1 Then ; Yes or no result? Offset of 2.
			$newPhone = StringRegExp($orderArray[17], $regexPHN10, 1, 2); Return an array of matches.
			; GUICtrlSetData($statusBar, $newPhone[0]) ; Display number.
			$orderArray[17] = $newPhone[0]; Update phone number with formatted one.
		ElseIf StringRegExp($orderArray[17], $regexPHN, 0) = 1 Then 
			$newPhone = StringRegExp($orderArray[17], $regexPHN, 1); No offset. Return an array of matches.
			; GUICtrlSetData($statusBar, $newPhone[0]) ; Display number.
			$orderArray[17] = $newPhone[0]; Update phone number with formatted one.
		EndIf
		; Else 
		; MsgBox(64, "Invalid Phone# Format", "Phone number is an incorrect length. Double-check the number before proceeding.") ; Info box.
	EndIf
EndFunc ; phoneFormatter()

Func inputMemo()
	$mainWinPos = WinGetPos($AppTitle) ; Get main window position.
	WinSetOnTop($AppTitle, "", $WINDOWS_NOONTOP); Set Launchpad on top.

	GUICtrlSetState($Label_Memo, $GUI_DISABLE + $GUI_HIDE); Hide memo notification
	$memo = InputBox("Memo", "Copy and paste payment memo:", "", "", 200, 128, $mainWinPos[0], $mainWinPos[1]) ; Keep memo box from being covered by main window.
	
	; Don't overwrite the old memo info if we hit 'cancel.'
	if @error = 1 Or $memo = "" Then
		WinSetOnTop($AppTitle, "", $WINDOWS_ONTOP); Set Launchpad on top.
		return
	EndIf

	WinSetOnTop($AppTitle, "", $WINDOWS_ONTOP); Set Launchpad on top.
	$pmtMemo = ""; NOW Clear the old payment memo.

	If (StringRegExp($memo, $regexAMZ, 0) = 1) Then
	    $pmtMemo = StringRegExp($memo, $regexAMZ, 1)
		hidePaymentButtons() ; Hide all payment buttons, but....
		GUICtrlSetState($Btn_CtAmazon, $GUI_ENABLE + $GUI_SHOW); Show Amazon Payments button
		GUICtrlSetState($Btn_Memo, $GUI_ENABLE + $GUI_SHOW) ; Show Resubmit Memo
		HotKeySet("^!p") ; Clear previous hotkey.
		HotKeySet("^!p", "payment") ; Set hotkey
		Return $pmtMemo[0]

	    ElseIf(StringRegExp($memo, $regexPPL, 0)= 1) Then
	        $pmtMemo = StringRegExp($memo, $regexPPL, 1)
			hidePaymentButtons() ; Hide all payment buttons, but....
			GUICtrlSetState($Btn_CtPayPal, $GUI_ENABLE + $GUI_SHOW)
			GUICtrlSetState($Btn_Memo, $GUI_ENABLE + $GUI_SHOW) ; Show Resubmit Memo
			HotKeySet("^!p") ; Clear previous hotkey.
			HotKeySet("^!p", "payment") ; Set hotkey
			Return $pmtMemo[0]

	    ElseIf(StringRegExp($memo, $regexCRD, 0) = 1) And (StringRegExp($pmtMemo, $regexPPL, 0)) = 0  Then
	        $pmtMemo = StringRegExp($memo, $regexCRD, 1)
			hidePaymentButtons() ; Hide all payment buttons, but....
			GUICtrlSetState($Btn_CtCard, $GUI_ENABLE + $GUI_SHOW)
			GUICtrlSetState($Btn_Memo, $GUI_ENABLE + $GUI_SHOW) ; Show Resubmit Memo
			HotKeySet("^!p") ; Clear previous hotkey.
			HotKeySet("^!p", "payment") ; Set hotkey
			Return $pmtMemo[0]

	    Else
			HotKeySet("^!p") ; Clear previous payment hotkey.
	        hidePaymentButtons() ; Hide all payment buttons, but....
			GUICtrlSetState($Btn_Memo, $GUI_ENABLE + $GUI_SHOW)
			GUICtrlSetState($Label_Memo, $GUI_ENABLE + $GUI_SHOW)
	EndIf

EndFunc ; inputMemo

Func orderInfo()
	_ArrayDisplay($orderArray, "Order Info")
	_ArrayDisplay($pmtMemo, "Memo Info")
	; If @error Then
	; 	MsgBox(64, "Missing Order Info.", "No data to display. Copy and paste an order from Shipworks to view details.") ; Info box.
	; 	importOrder() ; Display Order Info box
	; EndIf
EndFunc


; POPUP MENU FUNCTIONS:
Func Oos()
    InitialsCheck()
    ClipPut($OosText & $SigDate)
    _ToolTip("Text copied!", 2000)
EndFunc

Func Fraud()
    InitialsCheck()
    ClipPut($FraudText & $SigDate)
    _ToolTip("Text copied!", 2000)
EndFunc

Func FraudNote()
	InitialsCheck()
	ClipPut($FraudNoteText & addDays(7) & $SigDate)
    _ToolTip("Text copied!", 2000)
EndFunc ; FraudNote()

Func Backordered()
    InitialsCheck()
    ClipPut($BoText & $SigDate)
    _ToolTip("Text copied!", 2000)
EndFunc

Func BadAddress()
    InitialsCheck()
    ClipPut($BadAddressText[0] & $orderArray[11] & $BadAddressText[1] & $SigDate)
    _ToolTip("Text copied!", 2000)
EndFunc

Func BadAddressContacted()
    InitialsCheck()
    ClipPut($BadAddressContactedText & $SigDate)
    _ToolTip("Text copied!", 2000)
EndFunc

Func EmailFraud()
	InitialsCheck()
	ClipPut($EmailFraudText[0] & $orderArray[2] & $EmailFraudText[1] & addDays(7) & $EmailFraudText[2] & $SigDate)
	_ToolTip("Text copied!", 2000)
EndFunc ; EmailFraud()

Func EmailTracking()
    InitialsCheck()
    ClipPut($EmailTrackingText)
    _ToolTip("Text copied!", 2000)
Endfunc

Func EmailShippingChange()
    InitialsCheck()
    ClipPut($EmailshippingChangeText & $SigDate)
    _ToolTip("Text copied!", 2000)
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

; END OF METHODS SECTION

Func newCstImport()
	If UBound($orderArray) > 15 Then ; Check if zip code exists.
	WinActivate($EvosusWindow)
	WinActivate("New Customer")
	newCstWinCheck() ; Check for New Customer window

	Local $NCWindow = WinGetHandle("New Customer")

	; Fill in marketing information as part of customer entry.
	ControlFocus("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:18]") ; Focus "What?"
	ControlCommand("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:18]", "SelectString", "Parts") ; Select "Parts"
	ControlFocus("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:2]") ; Focus "Contact Type"
	ControlCommand("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:2]", "SelectString", "Internet/Email") ; Select "Internet/Email"
	ControlFocus("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:6]") ; Focus "Gender"
	ControlCommand("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:6]", "SelectString", "Male") ; Select "Male"

	canadaCheck()

	; Enter Phone If order is not Amazon.com
	If ($orderArray[1] <> "Amazon") Then
		ClipPut($orderArray[17]) ; Load phone number
		ControlClick("New Customer", "", 71); Click on the Postal code field to shock the State dropdown into submission when State lookup happens.
		ControlFocus("New Customer", "", "[CLASS:MSMaskWndClass; INSTANCE:2]") ; Focus phone number field
		ControlSend("New Customer", "","[CLASS:MSMaskWndClass; INSTANCE:2]", "{CTRLDOWN}v{CTRLUP}") ; Paste phone number

		;~ ControlClick("New Customer", "", 71); Click on the Postal code field to shock the State dropdown into submission when State lookup happens.
		;~ ControlSetText("New Customer", "", "[CLASS:MSMaskWndClass; INSTANCE:2]", $orderArray[17]); Paste phone number

	EndIf

	ControlCommand($NCWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:22]", "EditPaste", $orderArray[8]) ;First Name
	ControlCommand($NCWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:21]", "EditPaste", $orderArray[9]) ;Last Name
	ControlCommand($NCWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:17]", "EditPaste", $orderArray[10]) ;Company Name
	ControlCommand($NCWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:26]", "EditPaste", $orderArray[11]); Address1
	ControlCommand($NCWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:25]", "EditPaste", $orderArray[12]) ;Address2
	ControlCommand($NCWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:24]", "EditPaste", $orderArray[14]) ;City
		; TODO: Add a preferences screen.
		; TODO: Add a checkbox: "Bypass Lookup [F6]" If that's checked, do the following:
		;~ ControlFocus("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:23]") ; Focus State dropdown
		;~ ControlCommand("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:23]", "SelectString", $orderArray[15]); Select the state from customer's profile.
		; Else, do this:

	; email Check
	If ($orderArray[1] = "Earth Sense") Then
		ControlCommand($NCWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:27]", "EditPaste", $orderArray[21]); Email
	EndIf

	ControlCommand($NCWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:23]", "EditPaste", $orderArray[16]); Paste Zip Code
	ControlSend($NCWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:23]", "{F6}"); Look up City and State

	If ($orderArray[1] = "WalMart") Then
		wmWebsite()
	EndIf

	Else
		MsgBox(64, "Missing Order Info.", "Double check order details with the info button.") ; Info box.
		orderInfo() ; Show order info box right away.
	EndIf
EndFunc ; newCstImport()

Func payment()
	if ($pmtMemo[0] = "" And $orderArray[1] = "Earth Sense") Then
		MsgBox(64, "Missing Payment Info.", "No payment memo provided. Paste in a payment memo to continue.") ; Info box.
		Return
	EndIf
	WinActivate($EvosusWindow)
	ControlClick($EvosusWindow, "Pay In Full", "[ID:8]") ; Click "Pay in Full."
	ControlCommand($EvosusWindow, "", "[CLASS:ThunderRT6CheckBox; INSTANCE:2]", "UnCheck", ""); Uncheck "Print order on Save"
	
	If ($orderArray[1] = "Amazon") Then
		ControlCommand($EvosusWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:2]", "EditPaste", $orderArray[3]); Amazon order number
		ControlCommand($EvosusWindow, "", "[ID:10]", "SelectString", "Credit Card - Amazon") ; Select Amazon method.
	ElseIf ($orderArray[1] = "Amazon.ca") Then
		ControlCommand($EvosusWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:2]", "EditPaste", $orderArray[3]); Amazon order number
		ControlCommand($EvosusWindow, "", "[ID:10]", "SelectString", "Credit Card - Z-Amazon.CA") ; Select Amazon.ca method.
	ElseIf ($orderArray[1] = "esesstoves") Then
		ControlCommand($EvosusWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:2]", "EditPaste", $orderArray[4]); Paste eBay order number
		ControlCommand($EvosusWindow, "", "[ID:10]", "SelectString", "Credit Card - EBAY") ; Select Ebay payment method.
	ElseIf ($orderArray[1] = "WalMart") Then
		ControlCommand($EvosusWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:2]", "EditPaste", $orderArray[2]); Paste WalMart order number
		ControlCommand($EvosusWindow, "", "[ID:10]", "SelectString", "Credit Card - WalMart") ; Select WalMart method
	ElseIf $orderArray[1] = "Earth Sense" Then
		ControlCommand($EvosusWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:2]", "EditPaste", $pmtMemo[0]); Paste payment memo
			If (StringRegExp($pmtMemo[0], $regexPPL, 0)) = 1  Then ; Check PayPal memo
				ControlFocus($EvosusWindow, "", 10) ; Focus the dropdown control
				ControlCommand($EvosusWindow, "", "[ID:10]", "SelectString", "Credit Card - PayPal") ; Select Paypal

			ElseIf (StringRegExp($pmtMemo[0], $regexCRD, 0)) = 1 Then ; Check the card.
				ControlFocus($EvosusWindow, "", 10) ; Focus the dropdown control
				ControlCommand($EvosusWindow, "", "[ID:10]", "SelectString", "Credit Card - Visa/MC/Disc") ; ; Select Card

			ElseIf (StringRegExp($pmtMemo[0], $regexAMZ, 0)) = 1  Then ; Check Amazon memo
				ControlFocus($EvosusWindow, "", 10) ; Focus the dropdown control
				ControlCommand($EvosusWindow, "", "[ID:10]", "SelectString", "Credit Card - Amazon Payments") ; Select Amazon
		EndIf
	EndIf
	bypassAndInvoice()
EndFunc
