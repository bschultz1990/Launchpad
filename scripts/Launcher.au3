Func LaunchEvosus()
	Run("C:\Program Files (x86)\Evosus\Evosus Retail\EvosusRetail.exe")
EndFunc ; LaunchEvosus

Func LaunchNpp()
	Run("S:\Ben\Apps\npp.7.9.2.portable.x64\notepad++.exe")
EndFunc ; LaunchNpp()

Func LaunchShipworks()
	Run("C:\Program Files\ShipWorks\ShipWorks.exe")
EndFunc ; LaunchShipworks()

Func LaunchChrome()
	Run("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
EndFunc ; LaunchChrome()

Func LaunchGroup()
	LaunchEvosus()
	LaunchChrome()
	LaunchNpp()
	LaunchShipworks()
EndFunc; LaunchGroup