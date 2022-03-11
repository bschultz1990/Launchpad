; Function Reference
; https://www.autoitscript.com/autoit3/docs/functions.htm

; Language Reference
; https://www.autoitscript.com/autoit3/docs/intro/lang_operators.htm

#include <Array.au3>
#include <AutoItConstants.au3>
#include <ButtonConstants.au3>
#include <ColorConstantS.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>

; CUSTOM SCRIPTS
#include <scripts\Launcher.au3>
;~ #include <scripts\Methods2.au3>

AutoItSetOption("GUIOnEventMode", 1); Turn onEventMode On.
Opt("WinTitleMatchMode", 2); Match any substring in the window title.

; GUI SECTION
Global $AppTitle = "Launchpad 2"
Global $AppWidth = 400
Global $AppHeight = 68
Global $MainWindow = GUICreate($AppTitle, $AppWidth, $AppHeight, @DesktopWidth-$AppWidth-5, @DesktopHeight-$AppHeight-32)

; GLOBAL VARIABLES
Global $input
Global $orderArray
Global $EvosusWindow = "Evosus";
; Global $EvosusWindow = "TEST MODE!"
Global $ShipworksWindow = "ShipWorks"
Global $ChromeWindow = "Chrome"
Global $pmtMemo[1] ; Payment memo placeholder until we have some data.
Global $regexAMZ = "P01-[A-Za-z0-9]{7}-[A-Za-z0-9]{7}-[A-Za-z0-9]{7}|P01-[A-Za-z0-9]{7}-[A-Za-z0-9]{7}"
Global $regexCRD = "\b\d{11}"
Global $regexPPL = "[A-Za-z0-9]{17}"
Global $regexPHN = "\(?\d{3}\)?[\s-]?\d{3}[\s-]?\d{4}"
Global $regexPHN10 = "\d{10}$"
Global $regexCA = "[A-Za-z0-9]{3}\s?[A-Za-z0-9]{3}"


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

GUISetState(@SW_SHOW) ; Show the main GUI.
WinActivate($MainWindow)
WinSetOnTop($AppTitle, "", $WINDOWS_ONTOP); Set Launchpad on top.

; END GUI SECTION

; ----------------------------------------------------------------------
; 							EVENTS SECTION
; ----------------------------------------------------------------------
While 1
	HotKeySet("^!q", "testFunc")


	GUISetOnEvent($GUI_EVENT_CLOSE, "close")
	
	GUICtrlSetOnEvent($Btn_Info, "orderInfo")
	HotKeySet("^!i", "orderInfo")

	GUICtrlSetOnEvent($Btn_Order, "btnOrder")
	HotKeySet("^!o", "btnOrder")

	HotKeySet("^!d", "evosusDeposit") ; Secret Evosus Deposit Function! :)
	HotKeySet("^!s", "evosusStockLookup") ; Secret Stock Lookup Function! :)
	HotKeySet("^l", "itemFocus") ; Secret item focus function.
	HotKeySet("^!{NUMPADADD}", "printLabel") ; Secret print label function

	GUICtrlSetOnEvent($Btn_Memo, "inputMemo")

	GUICtrlSetOnEvent($Btn_AzAddress, "btnAzAddress") ; AMAZON
	GUICtrlSetOnEvent($Btn_AzCst, "btnAzCst")
	GUICtrlSetOnEvent($Btn_AzPmt, "azPmt")

	GUICtrlSetOnEvent($Btn_ebLookCst, "ebLook"); EBAY
	GUICtrlSetOnEvent($Btn_EbCst, "ebCst")
	GUICtrlSetOnEvent($Btn_EbPmt, "ebPmt")

	GUICtrlSetOnEvent($Btn_CtLookup, "ctLookup") ; CART
	GUICtrlSetOnEvent($Btn_CtCst, "ctCst")
	GUICtrlSetOnEvent($Btn_CtCard, "ctPmt") ; One function for multiple payment methods.
	GUICtrlSetOnEvent($Btn_CtPayPal, "ctPmt")
	GUICtrlSetOnEvent($Btn_CtAmazon, "ctPmt")

	GUICtrlSetOnEvent($Btn_WmAddress, "wmAddress") ; WAL-MART
	GUICtrlSetOnEvent($Btn_WmCst, "wmCst")
	GUICtrlSetOnEvent($Btn_WmPmt, "wmPmt")
WEnd
; END EVENTS SECTION

; ----------------------------------------------------------------------
; 						BEGIN GENERAL FUNCTIONS
; ----------------------------------------------------------------------

; TEST FUNCTION SECTION
Func testFunc()
	
EndFunc ; testFunc()
; END TEST FUNCTION SECTION

Func newCstWinCheck()
	If WinActivate("New Customer") = 0 Then
	ControlClick($EvosusWindow, "Add Lead or Customer", 15) ; Click "Add Lead or Customer"
	WinWaitActive("New Customer", "", 2) ; Wait a second for the New Customer window to appear.
	EndIf
EndFunc ; newCstWinCheck()

Func printLabel()
	WinActivate($ShipworksWindow, "") ; Activate ShipWorks window and click "Create Label."
	WinWaitActive($ShipworksWindow, "")
	Send("{F10}")
EndFunc ; printLabel()

Func itemFocus()
	WinActivate($EvosusWindow, "")
	ControlClick($EvosusWindow, "", "[CLASS:SSTabCtlWndClass; INSTANCE:1]", "left", 1, 236, 11) ; Click on "Items" tab.
	ControlFocus($EvosusWindow, "", "[CLASS:ThunderRT6TextBox; INSTANCE:18]"); Focus Item field
EndFunc ; funcName()



Func evosusStockLookup() ; Secret Stock Lookup Function! :)
	WinActivate($EvosusWindow)
	ControlClick($EvosusWindow, "Show Stock Status", 99) ; Click on "Show Stock Status"
EndFunc ; evosusStockLookup()

Func evosusDeposit() ; Secret Evosus Deposit Function! :)
	WinActivate($EvosusWindow, "")
	ControlClick($EvosusWindow, "Make Deposit", 89) ; Click "Make Deposit"
EndFunc ; evosusPayment()

Func close()
	If MsgBox(4+32, "Exit?", "Are you sure you want to exit?", 0, $MainWindow) = 6 Then ; Yes
		Exit
	EndIf
EndFunc

Func btnOrder()
	clearOrder() ; Clear all previous data.
	importOrder()
EndFunc ; $Btn_Order

Func canadaCheck()
	If StringRegExp($orderArray[16], $regexCA, 0) = 1 Then ;Yes or no result? No offset.
		Global $CAZip = StringRegExp($orderArray[16], $regexCA, 1) ; Return an array of matches. No offset.
		ControlFocus("New Customer", "", 69) ; Focus the dropdown control
		ControlCommand("New Customer", "", "[ID:69]", "SelectString", "Canada") ; Select "Canada"
		ControlClick("New Customer", "", 71); Click on the Postal code field to shock the State dropdown into submission when State lookup happens.
		ClipPut($orderArray[17]) ; Load phone number
		ControlFocus("New Customer", "", "[CLASS:MSMaskWndClass; INSTANCE:2]") ; Focus phone number field
		ControlSend("New Customer", "","[CLASS:MSMaskWndClass; INSTANCE:2]", "{CTRLDOWN}v{CTRLUP}") ; Paste phone number
	EndIf
EndFunc ; canadaCheck()

Func wmWebsite()
	ClipPut($orderArray[2]) ; Load WalMart order number into clipboard
	GUICtrlSetData($statusBar, "Copied WM Order number. Paste into Chrome.")
EndFunc ; wmWebsite()

Func btnAzAddress()
	WinActivate($ChromeWindow)
	Send("{CTRLDOWN}t{CTRLUP}") ; Make new tab. Automatically focuses address bar.
	WinWaitActive("New Tab", "", 1) ; Wait for the new tab window to appear.
	ClipPut($AmazonSearch & $orderArray[3])
	Send("{CTRLDOWN}v{CTRLUP}{ENTER}") ; Paste Amazon order number and GO

	btnAddress()
EndFunc ; btnAzAddress()

Func btnAddress()
	If UBound($orderArray) > 10 Then ; If address field exists, do stuff.
		ClipPut($orderArray[11])
		WinActivate($EvosusWindow)
		ControlClick($EvosusWindow, "Street Name", 49); Click on Street Name to clear Address Field
		ControlClick($EvosusWindow, "Address", 52); Click on Address field
		ControlFocus ($EvosusWindow, "", 63); Focus address field in the Evosus window
		ControlSend($EvosusWindow, "", 63, "{CTRLDOWN}v{CTRLUP}{ENTER}")
		Else
			MsgBox(64, "Missing Order Info.", "Address line nonexistent. Review order info.") ; Info box.
			orderInfo() ; Show user info box right away.
	EndIf
EndFunc ; $Btn_AzAddress

Func btnAzCst()
	If UBound($orderArray) > 15 Then ; Check if zip code exists.
	WinActivate($EvosusWindow)
	WinActivate("New Customer")
	newCstWinCheck() ; Check for New Customer window

	; Fill in marketing information as part of customer entry.
	ControlFocus("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:18]") ; Focus "What?"
	ControlCommand("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:18]", "SelectString", "Accessories") ; Select "Accessories"
	ControlFocus("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:2]") ; Focus "Contact Type"
	ControlCommand("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:2]", "SelectString", "Internet/Email") ; Select "Internet/Email"
	ControlFocus("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:6]") ; Focus "Gender"
	ControlCommand("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:6]", "SelectString", "Male") ; Select "Male"

	canadaCheck()

	ClipPut($orderArray[8]); Load First Name
	ControlSend("New Customer", "", 68, "{CTRLDOWN}v{CTRLUP}") ; Paste First Name
	ClipPut($orderArray[9]) ; Load Last Name
	ControlSend("New Customer", "", 67, "{CTRLDOWN}v{CTRLUP}") ; Paste Last Name
	ClipPut($orderArray[10]) ; Load Company Name
	ControlSend("New Customer", "", 63, "{CTRLDOWN}v{CTRLUP}") ; Paste Company Name
	ClipPut($orderArray[11]) ; Load Address Line 1
	ControlSend("New Customer", "", 74, "{CTRLDOWN}v{CTRLUP}") ; Paste Address Line 1
	ClipPut($orderArray[12]); Load Address Line 2
	ControlSend("New Customer", "", 73, "{CTRLDOWN}v{CTRLUP}") ; Paste Address Line 2
		; TODO: Add a preferences screen.
		; TODO: Add a checkbox: "Bypass Lookup [F6]" If that's checked, do the following:
		ClipPut($orderArray[14]) ; Load City
		ControlSend("New Customer", "", 72, "{CTRLDOWN}v{CTRLUP}") ; Paste City
		; Else, do this:
	ClipPut($orderArray[16]) ; Load Postal Code
	ControlSend("New Customer", "", 71, "{CTRLDOWN}v{CTRLUP}{F6}") ; Paste Postal Code. Look up City and State.
	Else
		MsgBox(64, "Missing Order Info.", "Double check order details with the info button.") ; Info box.
		orderInfo() ; Show user info box right away.
	EndIf
EndFunc ; btnAzCst()


Func azPmt()
	WinActivate($EvosusWindow)
	ClipPut($orderArray[3]) ; Load Amazon Order Number
	ControlFocus($EvosusWindow, "", "[ID:11]") ; Focus memo field
	ControlSend($EvosusWindow, "", "[ID:11]", "{CTRLDOWN}v{CTRLUP}") ; Paste Amazon Order Number
	ControlClick($EvosusWindow, "Pay In Full", "[ID:8]") ; Click "Pay in Full."
	ControlClick($EvosusWindow, "", "[ID:21]") ; Uncheck "Print order on Save"
	ControlClick($EvosusWindow, "", "[ID:10]") ; Focus Method field
	ControlFocus($EvosusWindow, "", 10) ; Focus the dropdown control
	ControlCommand($EvosusWindow, "", "[ID:10]", "SelectString", "Credit Card - Amazon") ; Select Amazon method.
	bypassAndInvoice()

EndFunc ; azPmt()


Func bypassAndInvoice()
	WinWaitActive("Process Credit Card", "", 10)
	ControlFocus("Process Credit Card", "Bypass >", "[NAME:cmdBypass]")
	ControlClick("Process Credit Card", "Bypass >", "[NAME:cmdBypass]") ; Click "Bypass >"
	WinWaitActive("Confirm Bypass", "", 2) ; click "Yes"
	ControlClick("Confirm Bypass", "", "[ID:6]")
	WinWaitActive("Payment", "", 2) ; Wait for "Successfully saved payment"
	ControlClick("Payment", "", "[ID:2]") ; Click "OK"
	WinWaitActive("Deliver Items?", "", 2)
	ControlClick("Deliver Items?", "", "[ID:7]") ; No. Don't Deliver.

	; INVOICE ORDER
	WinActivate($EvosusWindow, 10)
	ControlClick($EvosusWindow, "", "[ID:233]") ; Options
	Sleep(120)
	Send("{DOWN}{DOWN}{DOWN}")
	Sleep(120)
	Send("{ENTER}")
EndFunc ; bypassAndInvoice()

Func ctLookup()
	WinActivate($ChromeWindow) 
	Send("{CTRLDOWN}t{CTRLUP}") ; Make new tab. Automatically focuses address bar.
	WinWaitActive("New Tab", "", 1) ; Wait for the new tab window to appear.
	ClipPut($cartSearch[0] & $orderArray[2] & $cartSearch[1]) ; Concatenate and load the entire Cart URL
	Send("{CTRLDOWN}v{CTRLUP}{ENTER}") ; Paste last part of Cart search url and GO.

	If WinActivate ($ChromeWindow) = 0 Then
		MsgBox(64, "Chrome Not Open", "Google Chrome is not open. Open Google Chrome and try again.")
	EndIf
	btnAddress()
EndFunc ; ctLookup()


Func ebLook()
	WinActivate($ChromeWindow) 
	Send("{CTRLDOWN}t{CTRLUP}") ; Make new tab. Automatically focuses address bar.
	WinWaitActive("New Tab", "", 1) ; Wait for the new tab window to appear.
	ClipPut($ebaySearch & $orderArray[4]) ; Load eBay search url
	Send("{CTRLDOWN}v{CTRLUP}{ENTER}") ; Paste eBay order number into address bar and GO

	btnAddress() ; Look up address in Evosus.
EndFunc ; ebLook()

Func ebCst()
	If UBound($orderArray) > 16 Then ; Check if phone number exists
		WinActivate($EvosusWindow)
		WinActivate("New Customer")
		newCstWinCheck() ; Check for New Customer window

		; Fill in marketing information as part of customer entry.
		ControlFocus("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:18]") ; Focus "What?"
		ControlCommand("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:18]", "SelectString", "Accessories") ; Select "Accessories"
		ControlFocus("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:2]") ; Focus "Contact Type"
		ControlCommand("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:2]", "SelectString", "Internet/Email") ; Select "Internet/Email"
		ControlFocus("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:6]") ; Focus "Gender"
		ControlCommand("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:6]", "SelectString", "Male") ; Select "Male"

		ClipPut($orderArray[8]); Load First Name
		ControlSend("New Customer", "", 68, "{CTRLDOWN}v{CTRLUP}") ; Paste First Name
		ClipPut($orderArray[9]) ; Load Last Name
		ControlSend("New Customer", "", 67, "{CTRLDOWN}v{CTRLUP}") ; Paste Last Name
		ClipPut($orderArray[10]) ; Load Company Name
		ControlSend("New Customer", "", 63, "{CTRLDOWN}v{CTRLUP}") ; Paste Company Name
		ClipPut($orderArray[11]) ; Load Address Line 1
		ControlSend("New Customer", "", 74, "{CTRLDOWN}v{CTRLUP}") ; Paste Address Line 1
		ClipPut($orderArray[12]); Load Address Line 2
		ControlSend("New Customer", "", 73, "{CTRLDOWN}v{CTRLUP}") ; Paste Address Line 2

		canadaCheck()

		; TODO: Add a checkbox: "Bypass Lookup [F6]" If that's checked, do the following:
		ClipPut($orderArray[14]) ; Load City
		ControlSend("New Customer", "", 72, "{CTRLDOWN}v{CTRLUP}") ; Paste City
		ClipPut($orderArray[17]) ; Load phone number
		ControlFocus("New Customer", "", "[CLASS:MSMaskWndClass; INSTANCE:2]") ; Focus phone field.
		ControlSend("New Customer", "","[CLASS:MSMaskWndClass; INSTANCE:2]", "{CTRLDOWN}v{CTRLUP}") ; Paste phone number
		ClipPut($orderArray[16]) ; Load Postal Code
		ControlSend("New Customer", "", 71, "{CTRLDOWN}v{CTRLUP}{F6}") ; Paste Postal Code. Look up City and State.
		Else
			MsgBox(64, "Missing Order Info.", "Double check order details with the info button.") ; Info box.
			orderInfo() ; Show user info box right away.
	EndIf
EndFunc ; ebLook()

Func ebPmt()
	WinActivate($EvosusWindow)
	ClipPut($orderArray[4]) ; Load eBay order number
	ControlFocus($EvosusWindow, "", "[ID:11]") ; Focus memo field
	ControlSend($EvosusWindow, "", "[ID:11]", "{CTRLDOWN}v{CTRLUP}") ; Paste eBay Order Number
	ControlClick($EvosusWindow, "Pay In Full", "[ID:8]") ; Click "Pay in Full."
	ControlClick($EvosusWindow, "", "[ID:21]") ; Uncheck "Print order on Save"
	ControlClick($EvosusWindow, "", "[ID:10]") ; Focus Method field
	ControlFocus($EvosusWindow, "", 10) ; Focus the dropdown control
	ControlCommand($EvosusWindow, "", "[ID:10]", "SelectString", "Credit Card - EBAY") ; Select Ebay payment method.
	bypassAndInvoice()
EndFunc ; ebPmt()


Func ctCst()
	If UBound($orderArray) > 15 Then ; Check if zip code exists.
		WinActivate($EvosusWindow)
		WinActivate("New Customer")
		newCstWinCheck()

		; Fill in marketing information as part of customer entry.
		ControlFocus("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:18]") ; Focus "What?"
		ControlCommand("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:18]", "SelectString", "Accessories") ; Select "Accessories"
		ControlFocus("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:2]") ; Focus "Contact Type"
		ControlCommand("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:2]", "SelectString", "Internet/Email") ; Select "Internet/Email"
		ControlFocus("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:6]") ; Focus "Gender"
		ControlCommand("New Customer", "", "[CLASS:ThunderRT6ComboBox; INSTANCE:6]", "SelectString", "Male") ; Select "Male"

		ClipPut($orderArray[8]); Load First Name
		ControlSend("New Customer", "", 68, "{CTRLDOWN}v{CTRLUP}") ; Paste First Name
		ClipPut($orderArray[9]) ; Load Last Name
		ControlSend("New Customer", "", 67, "{CTRLDOWN}v{CTRLUP}") ; Paste Last Name
		ClipPut($orderArray[10]) ; Load Company Name
		ControlSend("New Customer", "", 63, "{CTRLDOWN}v{CTRLUP}") ; Paste Company Name
		ClipPut($orderArray[11]) ; Load Address Line 1
		ControlSend("New Customer", "", 74, "{CTRLDOWN}v{CTRLUP}") ; Paste Address Line 1
		ClipPut($orderArray[12]); Load Address Line 2
		ControlSend("New Customer", "", 73, "{CTRLDOWN}v{CTRLUP}") ; Paste Address Line 2
		ClipPut($orderArray[21]) ; Load email address
		ControlSend("New Customer", "", "[CLASS:ThunderRT6TextBox; INSTANCE:27]", "{CTRLDOWN}v{CTRLUP}") ; Paste email address
		ClipPut($orderArray[17]) ; Load phone number
		ControlFocus("New Customer", "", "[CLASS:MSMaskWndClass; INSTANCE:2]") ; Focus phone field to make sure it stays.
		ControlSend("New Customer", "","[CLASS:MSMaskWndClass; INSTANCE:2]", "{CTRLDOWN}v{CTRLUP}") ; Paste phone number

		canadaCheck()
		
			; TODO: Add a preferences screen.
			; TODO: Add a checkbox: "Bypass Lookup [F6]" If that's checked, do the following:
			ClipPut($orderArray[14]) ; Load City
			ControlSend("New Customer", "", 72, "{CTRLDOWN}v{CTRLUP}") ; Paste City
			; Else, do this:
		ClipPut($orderArray[16]) ; Load Postal Code
		ControlSend("New Customer", "", 71, "{CTRLDOWN}v{CTRLUP}{F6}") ; Paste Postal Code. Look up City and State.

		Else
			MsgBox(64, "Missing Order Info.", "Zip code line nonexistent. Double check order details with the info button.") ; Info box.
			orderInfo() ; Show user info box right away.
	EndIf
EndFunc ; ctCst()

Func ctPmt()
	WinActivate($EvosusWindow)
	ClipPut($orderArray[3]) ; Load Amazon Order Number
	ControlFocus($EvosusWindow, "", "[ID:11]") ; Focus memo field
	ClipPut($pmtMemo[0]) ; Load payment memo
	ControlSend($EvosusWindow, "", "[ID:11]", "{CTRLDOWN}v{CTRLUP}") ; Paste payment memo
	ControlClick($EvosusWindow, "Pay In Full", "[ID:8]") ; Click "Pay in Full."
	ControlClick($EvosusWindow, "", "[ID:21]") ; Uncheck "Print order on Save"
	ControlClick($EvosusWindow, "", "[ID:10]") ; Focus Method field

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
	bypassAndInvoice()
EndFunc ; ctPmt

Func wmAddress()
	WinActivate($ChromeWindow)
	Send("{CTRLDOWN}t{CTRLUP}") ; Make new tab. Automatically focuses address bar.
	WinWaitActive("New Tab", "", 1) ; Wait for the new tab window to appear.
	ClipPut($wmSearch) ; Load WalMart Seller Central
	Send("{CTRLDOWN}v{CTRLUP}{ENTER}") ; Paste WalMart Seller Central and GO

	If WinActivate ($ChromeWindow) = 0 Then
		MsgBox(64, "Chrome Not Open", "Google Chrome is not open. Open Google Chrome and try again.")
	EndIf
	btnAddress()
	wmWebsite()
EndFunc ; wmAddress()

Func wmCst()
	GUICtrlSetData($statusBar, $orderArray[2]); Show WalMart order number in status bar.
	ebCst()
	wmWebsite()
EndFunc ; wmCst()

Func wmPmt()
	WinActivate($EvosusWindow)
	ClipPut($orderArray[2]) ; Load Wal-Mart order number
	ControlFocus($EvosusWindow, "", "[ID:11]") ; Focus memo field
	ControlSend($EvosusWindow, "", "[ID:11]", "{CTRLDOWN}v{CTRLUP}") ; Paste Wal-Mart Order Number
	ControlClick($EvosusWindow, "Pay In Full", "[ID:8]") ; Click "Pay in Full."
	ControlClick($EvosusWindow, "", "[ID:21]") ; Uncheck "Print order on Save"
	ControlClick($EvosusWindow, "", "[ID:10]") ; Focus Method field
	ControlFocus($EvosusWindow, "", 10) ; Focus the dropdown control
	ControlCommand($EvosusWindow, "", "[ID:10]", "SelectString", "Credit Card - WalMart") ; Select WalMart method
	bypassAndInvoice()
EndFunc ; wmPmt()

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

	HotKeySet("^!a", "btnAddress") ; Set hotkeys for Amazon buttons.
	HotKeySet("^!c", "btnAzCst")
	HotKeySet("^!p", "azPmt")
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

	HotKeySet("^!a", "ebLook") ; Enable lookup hotkey
	HotKeySet("^!c", "ebCst") ; Enable enter cst. hotkey
	HotKeySet("^!p", "ebPmt") ; Enable memo hotkey
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
	
	HotKeySet("^!a", "ctLookup") ; Enable lookup hotkey
	HotKeySet("^!c", "ctCst") ; Enable enter cst. hotkey
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

	HotKeySet("^!a", "wmAddress") ; Enable lookup hotkey
	HotKeySet("^!c", "ebCst") ; Enable enter cst. hotkey
	HotKeySet("^!p", "wmPmt") ; Enable memo hotkey
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
	GUICtrlSetData($pmtMemo[0], "") ; Clear payment memo.
	GUICtrlSetData($statusBar, "") ; Clear status bar
	HotKeySet("^!a", "") ; Disable lookup hotkey
	HotKeySet("^!c", "") ; Disable enter cst. hotkey
	HotKeySet("^!p", "") ; Disable payment hotkey
EndFunc ; clearOrder

; END GENERAL FUNCTIONS


Func importOrder()
	GUISetState(@SW_HIDE, $AppTitle) ; Hide the main window
	GUICtrlSetState($Btn_Memo, $GUI_ENABLE + $GUI_SHOW)
	$mainWinPos = WinGetPos($AppTitle) ; Returns an array
	$input = InputBox("Order:", "Copy and paste order:", "", "", 200, 128, $mainWinPos[0], $mainWinPos[1])
	$orderArray = StringSplit($input, "	")
	
	GUISetState(@SW_SHOW, $AppTitle); Show the main window

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
		phoneFormatter()

		hidePaymentButtons()
		hideAmazonButtons()
		hideEbayButtons()
		showCartButtons()
		hideWmButtons()

	ElseIf $orderArray[1] = "esesstoves" Then
		GUICtrlSetData($orderBar, "eBay Order")
		GUICtrlSetData($statusBar, $orderArray[4]&" - "&$orderArray[9])
		phoneFormatter()

		hidePaymentButtons()
		hideAmazonButtons()
		showEbayButtons()
		hideCartButtons()
		hideWmButtons()

	ElseIf $orderArray[1] = "WalMart" Then
		GUICtrlSetData($orderBar, "WalMart Order")
		GUICtrlSetData($statusBar, $orderArray[2]&" - "&$orderArray[9])
		phoneFormatter()

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
	GUISetState(@SW_HIDE, $AppTitle) ;Hide the main window
	GUICtrlSetState($Label_Memo, $GUI_DISABLE + $GUI_HIDE); Hide memo notification
	$mainWinPos = WinGetPos($AppTitle) ; Get main window position.
	$memo = InputBox("Memo", "Copy and paste payment memo:", "", "", 200, 128, $mainWinPos[0], $mainWinPos[1]) ; Put InputBox where main window was.
	GUISetState(@SW_SHOW, $AppTitle); Show the main window

	If (StringRegExp($memo, $regexAMZ, 0) = 1) Then
	    $pmtMemo = StringRegExp($memo, $regexAMZ, 1)
	    GUICtrlSetData($statusBar,"Amazon Payments: "&$pmtMemo[0])
		hidePaymentButtons() ; Hide all payment buttons, but....
		GUICtrlSetState($Btn_CtAmazon, $GUI_ENABLE + $GUI_SHOW); Show Amazon Payments button
		GUICtrlSetState($Btn_Memo, $GUI_ENABLE + $GUI_SHOW) ; Show Resubmit Memo
		HotKeySet("^!p") ; Clear previous hotkey.
		HotKeySet("^!p", "ctPmt") ; Set hotkey
		Return $pmtMemo[0]

	    ElseIf(StringRegExp($memo, $regexPPL, 0)= 1) Then
	        $pmtMemo = StringRegExp($memo, $regexPPL, 1)
	        GUICtrlSetData($statusBar,"PayPal: " &$pmtMemo[0])
			hidePaymentButtons() ; Hide all payment buttons, but....
			GUICtrlSetState($Btn_CtPayPal, $GUI_ENABLE + $GUI_SHOW)
			GUICtrlSetState($Btn_Memo, $GUI_ENABLE + $GUI_SHOW) ; Show Resubmit Memo
			HotKeySet("^!p") ; Clear previous hotkey.
			HotKeySet("^!p", "ctPmt") ; Set hotkey
			Return $pmtMemo[0]

	    ElseIf(StringRegExp($memo, $regexCRD, 0) = 1) And (StringRegExp($pmtMemo, $regexPPL, 0)) = 0  Then
	        $pmtMemo = StringRegExp($memo, $regexCRD, 1)
	        GUICtrlSetData($statusBar,"Card: "&$pmtMemo[0])
			hidePaymentButtons() ; Hide all payment buttons, but....
			GUICtrlSetState($Btn_CtCard, $GUI_ENABLE + $GUI_SHOW)
			GUICtrlSetState($Btn_Memo, $GUI_ENABLE + $GUI_SHOW) ; Show Resubmit Memo
			HotKeySet("^!p") ; Clear previous hotkey.
			HotKeySet("^!p", "ctPmt") ; Set hotkey
			Return $pmtMemo[0]

	    Else
	        GUICtrlSetData($statusBar,"No match.")
			HotKeySet("^!p") ; Clear previous payment hotkey.
	        hidePaymentButtons() ; Hide all payment buttons, but....
			GUICtrlSetState($Btn_Memo, $GUI_ENABLE + $GUI_SHOW)
			GUICtrlSetState($Label_Memo, $GUI_ENABLE + $GUI_SHOW)
	EndIf

EndFunc ; inputMemo

Func orderInfo()
	_ArrayDisplay($orderArray, "Order Info")
	If @error Then
		MsgBox(64, "Missing Order Info.", "No data to display. Copy and paste an order from Shipworks to view details.") ; Info box.
		importOrder() ; Display Order Info box
	EndIf
EndFunc
; END OF METHODS SECTION