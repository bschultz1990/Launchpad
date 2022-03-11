#include "PopUpMenu.au3"

_PopUpMenuSetOption ("OnEventMode", 1)

$hMenu2 = _PopUpMenuCreate ("!5")
$hSend2 = _PopUpMenuCreateMenu ("Send 2:", $hMenu2)
   $hString2 = _PopUpMenuCreateMenuItem ("Mat Rocks!", $hSend2)
      _PopUpMenuItemSetOnEvent (-1, "MyFunc", "You Sent:|Mat Rocks!!")
_PopUpMenuCreateMenuItem ("", $hMenu2)
$hExit2 = _PopUpMenuCreateMenuItem ("Exit (2)", $hMenu2)
_PopUpMenuItemSetOnEvent (-1, "MyFunc", "You Sent|Exit. Goodbye!")

While 1
   Sleep (5000)
WEnd

Func MyFunc ($sArg, $sParam)
   MsgBox (0, $sArg, $sParam)
   If $sParam = "Exit. Goodbye!" Then Exit
EndFunc ; ==> MyFunc