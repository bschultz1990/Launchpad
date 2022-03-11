; START CUSTOM SCRIPTS
#include <AutoItConstants.au3>
#include <scripts\Launcher.au3>
#include <scripts\Methods.au3>
; END CUSTOM SCRIPTS
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=S:\Ben\DESKTOP\Docs\Launchpad\Launchpad.kxf
; $Form1 = GUICreate("Launchpad", 345, 417, 1560, 616)
$Form1 = GUICreate("Launchpad",345,417, @DesktopWidth-350,@DesktopHeight-480)
GUISetBkColor(0xCCCCCC)
$Group_Core = GUICtrlCreateGroup("Core", 8, 8, 113, 193)
$Btn_LaunchEvosus = GUICtrlCreateButton("Evosus", 24, 32, 83, 25)
$Btn_LaunchChrome = GUICtrlCreateButton("Chrome", 24, 64, 83, 25)
$Btn_LaunchNpp = GUICtrlCreateButton("Notepad ++", 24, 96, 83, 25)
$Btn_LaunchShipworks = GUICtrlCreateButton("ShipWorks", 24, 128, 83, 25)
$Btn_LaunchGroup = GUICtrlCreateButton("Launch Group", 24, 160, 83, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group_Amazon = GUICtrlCreateGroup("Amazon", 120, 8, 105, 193)
$Btn_CheckAddress = GUICtrlCreateButton("Chk. Address", 136, 32, 75, 25)
$Btn_AmazonCustomer = GUICtrlCreateButton("Enter Cst.", 136, 64, 75, 25)
$Btn_AmazonPayment = GUICtrlCreateButton("Payment", 136, 96, 75, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GroupEbay = GUICtrlCreateGroup("Ebay", 224, 8, 113, 193)
$Btn_EbayLookupOrder = GuiCtrlCreateButton("Lookup Cst.", 240, 32, 75, 25)
$Btn_EbayCustomer = GUICtrlCreateButton("Enter Cst.", 240, 64, 75, 25)
$Btn_EbayPayment = GUICtrlCreateButton("Payment", 240, 95, 75, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group_Cart = GUICtrlCreateGroup("Cart", 8, 216, 145, 193)
$Btn_CartLookup = GUICtrlCreateButton ("Lookup Cst.", 24, 240,75, 25)
$Btn_CartCustomer = GUICtrlCreateButton("Enter Cst.", 24, 272, 75, 25)
$Btn_CardPayment = GUICtrlCreateButton("Pmt. - Card", 24, 304, 75, 25)
$Btn_PayPalPmt = GUICtrlCreateButton("Pmt. - PayPal", 24, 336, 75, 25)
$Btn_CartAzPmt = GUICtrlCreateButton("Pmt. - AZ", 24, 368, 75, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group_Walmart = GUICtrlCreateGroup("WalMart", 224, 216, 113, 161)
$Btn_CheckAddress2 = GUICtrlCreateButton("Chk. Address", 240, 240, 75, 25)
$Btn_WalmartCustomer = GUICtrlCreateButton("Enter Cst.", 240, 272, 75, 25)
$Btn_WalmartPmt = GUICtrlCreateButton("Payment", 240, 304, 75, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$input = GUICtrlCreateInput("", 136, 240, 75, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

; Set "Launchpad" window to on top.
WinSetOnTop("Launchpad", "", $WINDOWS_ONTOP)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
		Exit

		; CORE
		Case $Btn_LaunchEvosus
			LaunchEvosus()

		Case $Btn_LaunchChrome
			LaunchChrome()

		Case $Btn_LaunchNpp
			LaunchNpp()

		Case $Btn_LaunchShipworks
			LaunchShipworks()

		Case $Btn_LaunchGroup
			LaunchGroup()

		; AMAZON
		Case $Btn_CheckAddress ; Don't take a suggestion.
			addressLookup()

		Case $Btn_AmazonCustomer
			AmazonEnterCustomer()

		Case $Btn_AmazonPayment
			AmazonPayment()

		; EBAY
		Case $Btn_EbayLookupOrder
			addressSuggestion()
			ebayLookupOrder()

		Case $Btn_EbayCustomer
			eBayEnterCustomer()

		Case $Btn_EbayPayment
			eBayPayment()

		; CART
		Case $Btn_CartLookup
			addressSuggestion()
			CartLookupCustomer()

		Case $Btn_CartCustomer
			CartEnterCustomer()

		Case $Btn_CardPayment
			CartPaymentCreditCard()

		Case $Btn_PayPalPmt
			CartPaymentPayPal()

		Case $Btn_CartAzPmt
			CartPaymentAZ()

		; WALMART
		Case $Btn_CheckAddress2
			addressSuggestion()
			addressLookup()
			MouseMove(1840, 926, 0)

		Case $Btn_WalmartCustomer
			WalMartEnterCustomer()

		Case $Btn_WalmartPmt
			PaymentWalMart()
	EndSwitch
WEnd
