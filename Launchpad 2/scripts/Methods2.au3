; BEGIN GENERAL FUNCTIONS
Func clearOrder()
		GUICtrlSetData($input,""); Clear original copied and pasted order info.
		GUICtrlSetData($orderArray, "") ; Clear order
		GUICtrlSetData($inputMemo, ""); Clear payment memo info.
EndFunc ; clearOrder

Func hideCartButtons()
	GUICtrlSetState($Btn_CtLookup, $GUI_DISABLE + $GUI_HIDE) ; Hide Cart Buttons
	GUICtrlSetState($Btn_CtCst, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_CtCard, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_CtPayPal, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_CtAmazon, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($inputMemo, $GUI_HIDE)
EndFunc ; hideCartButtons()

Func showCartButtons() ; CART BUTTONZ!
	GUICtrlSetState($Btn_CtLookup, $GUI_ENABLE + $GUI_SHOW) ; Show Cart Buttons
	GUICtrlSetState($Btn_CtCst, $GUI_ENABLE + $GUI_SHOW)
	GUICtrlSetState($Btn_CtCard, $GUI_ENABLE + $GUI_SHOW)
	GUICtrlSetState($Btn_CtPayPal, $GUI_ENABLE + $GUI_SHOW)
	GUICtrlSetState($Btn_CtAmazon, $GUI_ENABLE + $GUI_SHOW)
EndFunc ; showCartButtons()

Func hideWmButtons()
	GUICtrlSetState($Btn_WmChkAddress, $GUI_DISABLE + $GUI_HIDE) ; Hide Walmart Buttons
	GUICtrlSetState($Btn_WmCst, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_WmPmt, $GUI_DISABLE + $GUI_HIDE)
EndFunc ; hideWmButtons()

Func showWmButtons()
	GUICtrlSetState($Btn_WmChkAddress, $GUI_ENABLE + $GUI_SHOW) ; Show Walmart Buttons
	GUICtrlSetState($Btn_WmCst, $GUI_ENABLE + $GUI_SHOW)
	GUICtrlSetState($Btn_WmPmt, $GUI_ENABLE + $GUI_SHOW)
EndFunc ; showWmButtons()

Func hideEbayButtons()
	GUICtrlSetState($Btn_ebLookCst, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_EbCst, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_EbPmt, $GUI_DISABLE + $GUI_HIDE)
EndFunc ; hideEbayButtons()

Func showEbayButtons()
	GUICtrlSetState($Btn_ebLookCst, $GUI_ENABLE + $GUI_SHOW)
	GUICtrlSetState($Btn_EbCst, $GUI_ENABLE + $GUI_SHOW)
	GUICtrlSetState($Btn_EbPmt, $GUI_ENABLE + $GUI_SHOW)
EndFunc ; showEbayButtons()

Func hideAmazonButtons()
	GUICtrlSetState($Btn_Address, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_AzCst, $GUI_DISABLE + $GUI_HIDE)
	GUICtrlSetState($Btn_AzPmt, $GUI_DISABLE + $GUI_HIDE)
EndFunc ; hideAmazonButtons()

Func showAmazonButtons()
	GUICtrlSetState($Btn_Address, $GUI_ENABLE + $GUI_SHOW) ; Enable and show Amazon buttons.
	GUICtrlSetState($Btn_AzCst, $GUI_ENABLE + $GUI_SHOW)
	GUICtrlSetState($Btn_AzPmt, $GUI_ENABLE + $GUI_SHOW)
EndFunc ; showAmazonButtons()


; END GENERAL FUNCTIONS

; GLOBAL VARIABLES
Global $input
Global $orderArray

Func enterOrder()
	GUISetState(@SW_HIDE, $AppTitle) ;Hide the main window
	$input = InputBox("Order:", "Copy and paste order:", "", "", 200, 128,@DesktopWidth-$AppWidth, @DesktopHeight-$AppHeight-32)
	$orderArray = StringSplit($input, "	")
	GUISetState(@SW_SHOW, $AppTitle); Show the main window

		If $orderArray[1] = "Amazon" Then
			GUICtrlSetData($orderBar, "Amazon Order") ; Tell user it's an Amazon order.
			showAmazonButtons()
			hideEbayButtons()
			hideCartButtons()
			hideWmButtons()


		ElseIf $orderArray[1] = "Earth Sense" Then
			GUICtrlSetData($orderBar, "Cart Order")

			hideAmazonButtons()
			hideEbayButtons()

			GUICtrlSetState($Btn_CtCard, $GUI_DISABLE + $GUI_HIDE); Hide payment buttons in case they were used before.
			GUICtrlSetState($Btn_CtPayPal, $GUI_DISABLE + $GUI_HIDE)
			GUICtrlSetState($Btn_CtAmazon, $GUI_DISABLE + $GUI_HIDE)

			GUICtrlSetState($Btn_CtLookup, $GUI_ENABLE + $GUI_SHOW) ; Show 2 Cart Buttons and payment memo field.
			GUICtrlSetState($Btn_CtCst, $GUI_ENABLE + $GUI_SHOW)
			GUICtrlSetState($inputMemo, $GUI_SHOW)

			hideWmButtons()

			Switch ($inputMemo)
				Case $inputMemo
				MsgBox(0,"Memo", "Payment memo", $inputMemo)
			EndSwitch

		ElseIf $orderArray[1] = "esesstoves" Then
			GUICtrlSetData($orderBar, "eBay Order")
			hideAmazonButtons()
			showEbayButtons()
			hideCartButtons()
			hideWmButtons()

		ElseIf $orderArray[1] = "WalMart" Then
			GUICtrlSetData($orderBar, "WalMart Order")
			hideAmazonButtons()
			hideEbayButtons()
			hideCartButtons()
			showWmButtons()
		Else
		GUICtrlSetData($orderBar, "Other order")
		EndIf

EndFunc ; enterOrder()

Func orderInfo()
	_ArrayDisplay($orderArray, "Order Info")
	If @error Then
	MsgBox(64, "Missing Order Info.", "No data to display. Copy and paste an order form Shipworks to view details.") ; Info box.
	enterOrder() ; Display Order Info box
	EndIf
EndFunc