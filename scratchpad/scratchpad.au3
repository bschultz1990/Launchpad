; When array is Earth Sense
; Input field for payment information is shown. Store in its own variable.

; If payment information looks like credit card info,
	; Show $Btn_CtCard
	; Hide $Btn_CtPayPal
	; Hide $Btn_CtAmazon

; If payment information looks like PayPal,
	; Hide $Btn_CtCard
	; Show $Btn_CtPayPal
	; Hide $Btn_CtAmazon

; If payment information looks like Amazon,
	; Hide $Btn_CtCard
	; Hide $Btn_CtPayPal
	; Show $Btn_CtAmazon


; Look at phone number in order array.
; Find the relevant 10 digits and overwrite phone number info in order Array.




PAYMENT METHODS
CARD:
Order 114269 Authorize.Net Credit Card Charge Approved: Visa ending in 0347 (expires 06/25) (Transaction ID 43005805370)
Order 114288 Authorize.Net Credit Card Charge Approved: Visa ending in 8535 (expires 03/22) (Transaction ID 43006983785)

PAYPAL:
Order 114277 YITH PayPal EC payment (ID: 00E5681277667871T)

AMAZON:
Order 114283 Charge P01-3535609-8398673-C011388 with status Captured.
                                P01-5844479-8020495
Order 114286 Charge Permission  P01-7208358-3484661 with status Closed.

StringRegExp($inputMemo,"P01-.+-", 1, 1) ; Amazon payments regEx. $STR_REGEXPARRAYMATCH return an array of matches.
$inputMemo = $STR_REGEXPMATCH[1]; Grab just the payment memo and not other text.


_ControlHover
:ORDER FORMATS 
Store Name	Order #	Amazon Order #	eBay Order Number	Date	Local Status	Store Status	S: First Name	S: Last Name	S: Company	S: Street1	S: Street2	S: Street3	S: City	S: State	S: Postal Code	S: Phone	S: Country	Buyer	Total	S: Email	Item SKU	Last Modified (Online)
Amazon	275721	113-1234567-6082602		Yesterday		Unshipped	John	Smith		3309 Logan Dr			Porco Rosso	Nevada	54978-1231	+1 619-854-2705 ext. 54284	US		$46.09	pj5lt853xr98msq@marketplace.amazon.com	12153900	11/06/2021 5:59 PM
Earth Sense	113457			November 05, 2021		processing	Casey	Smith		3333 Third St			Quad Rivers	Idaho	83301	2243456784	US		$42.90	email.address@gmail.com	Multiple (2)	11/05/2021 10:41 AM
esesstoves	94380		12-12345-12345	November 05, 2021	Not Shipped	Completed	Daniel	Milestone		2000 Llama Way			Alpine	Texas	79830-7752	5054701888	US	dale6744	$50.12	7348494e9c169bdbe847@members.ebay.com	PH-20154 + SRV7034-186	11/05/2021 4:35 PM
WalMart	0551774665678			Yesterday			Buddy	Elf		605 Indian Hill Drive			Durham	Connecticut	06422-3101	5487946513	US		$201.00	BCA97670621040C3BDF060BBE8401EFB@relay.walmart.com	1-10-05802	11/06/2021 10:12 AM






















#include <GUIConstantsEx.au3>

_Clear_Input

Func _Clear_Input()


    $hGUI = GUICreate("Test", 500, 500)
    
    $hInput_1 = GUICtrlCreateInput("Input_1 ", 10, 10, 200, 20)
    $hInput_2 = GUICtrlCreateInput("Input_2 ", 10, 80, 200, 20)
    
    GUISetState()

    While 1
        
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                Exit
        EndSwitch
        
        $aInfo = GUIGetCursorInfo($hGUI)
        If $aInfo[2] Then
            If $aInfo[4] = $hInput_1 Then GUICtrlSetData($hInput_1, "")
            If $aInfo[4] = $hInput_2 Then GUICtrlSetData($hInput_2, "")
        EndIf
        
    WEnd

EndFunc;==>_Clear_Input



#include <Array.au3>
_ArrayDisplay($order,"title");
_ArrayAdd($arrayName,"valueToAdd")
_ArrayInsert ; Insert a new value at the specified position of a 1D or 2D array.
_ArrayPop($arrayname) ; Remove last value from array
ControlClick("windowTitle", "", "[ID:00]")
ControlFocus ( "title", "text", controlID ) ; Sets input focus to a given control on a window.
ControlGetPos ( "title", "text", controlID ) ; Retrieves the position and size of a control relative to its window.
ControlSend(title, text, controlID, string, [flag]) ; Send a command or string to a control.
GUICtrlCreateInput("text", left, top, [width], [height], [style], [exStyle])
GUICtrlSetData($controlName, "string here")
GUICtrlSetState ( controlID, state ); Changes the state of a control
GUICtrlCreateLabel ( "text", left, top [, width [, height [, style = -1 [, exStyle = -1]]]] ) ; Creates a static Label control for the GUI.
GUISetState([flag], [winhandle]) ; Set the state of a window (Show, hide, etc...)
If expression Then
    statement
EndIf
MouseMove(1623, 927, 0) ; Hover over "Enter Cst."
MsgBox(0, "Order Number", "Amazon Order Number is: " & $orderArray[3]) ; String template literally?
Send("{CTRLDOWN}v{CTRLUP}") ; Pasta
StringSplit(str, delimiters, [flag])
WinActivate("windowTitle")
WinClose("title", "[text]")
WinSetOnTop ( "title", "text", flag )
WinWaitActive("title", sleepTimeInSeconds)
WinWaitActive("[CLASS:Notepad]", "")


ClipGet ( )
ClipPut( )
ControlFocus ("Evosus  -  Ben Schultz  -  Online Stores", "", 63); Focus address field
ControlSend("Window Title", "", "Edit1", ClipGet())
ControlSend(title, text, controlID, string, [flag])






MouseClick($MOUSE_CLICK_PRIMARY, 3570, 0, 1, 0); Home the mouse.
Send("{HOME}")
Sleep(120)
Send("{CTRLDOWN}c{CTRLUP}") ; Copy order number.

MouseClickDrag ( "button", x1, y1, x2, y2, 0); Copy order number.
$MOUSE_CLICK_RIGHT
$MOUSE_CLICK_MIDDLE
$MOUSE_CLICK_MAIN
$MOUSE_CLICK_MENU
$MOUSE_CLICK_PRIMARY
$MOUSE_CLICK_SECONDARY

- - - - - - - - - - -
NEW PAYMENT FUNCTION
- - - - - - - - - - -
Func GENERICPAYMENT()
	; HOME THE MOUSE
	; COPY ORDER NUMBER

	paymentScreen();
	
	; SELECT PAYMENTS HERE

	BypassAndInvoice()

	MouseMove(1054, 196, 0) ; Hover over "Sales Orders"
--------------------