#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Samuel Schreiber

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

Global $sExitOnTargetWindowMissing
Global $iniDir= @ScriptDir&"\"&"Config\"

#include "log.au3"
#include "click.au3"
#include <array.au3>

Local $sMainProcess = "starter.exe"
local $hotkeyINI = $iniDir&"hotkey.ini"
Global $arHK=IniReadSection($hotkeyINI, "HotKey")
Global $bWait = False

_HotKey()
_waitForProcess($sMainProcess)
_FolderIsWritable()
_Main($sMainProcess)



Func _Main($sMainProcess=$sMainProcess)
   While ProcessExists($sMainProcess)
	  Sleep(100)
   WEnd
   if not ProcessExists($sMainProcess) and $sExitOnTargetWindowMissing then
	  _LogInfo("ProcessExists" &@TAB& "Process lost - EXIT")
	  Exit
   EndIf
EndFunc



#Region hotkey

   func _HotKey()
	  local $mainINI = $iniDir&"main.ini"


	  if not isarray ($arHK) then
		 _LogError("_HotKey"&@tab&"HotKey.ini failure")
	  elseif $arHK[0][0] <> 10 then
		 _LogError("_HotKey"&@tab&"HotKey.ini Array has wrong range")
	  EndIf
	  ;_ArrayDisplay($arHK)
	  HotKeySet(IniRead($mainINI,"HotKey","HotKey1","{F1}"),"__HotKey1")
	  HotKeySet(IniRead($mainINI,"HotKey","HotKey2","{F2}"),"__HotKey2")
	  HotKeySet(IniRead($mainINI,"HotKey","HotKey3","{F3}"),"__HotKey3")
	  HotKeySet(IniRead($mainINI,"HotKey","HotKey4","{F4}"),"__HotKey4")
	  HotKeySet(IniRead($mainINI,"HotKey","HotKey5","{F5}"),"__HotKey5")
	  HotKeySet(IniRead($mainINI,"HotKey","HotKey6","{F6}"),"__HotKey6")
	  HotKeySet(IniRead($mainINI,"HotKey","HotKey7","{F7}"),"__HotKey7")
	  HotKeySet(IniRead($mainINI,"HotKey","HotKey8","{F8}"),"__HotKey8")
	  HotKeySet(IniRead($mainINI,"HotKey","HotKey9","{F9}"),"__HotKey9")
	  HotKeySet(IniRead($mainINI,"HotKey","HotKey10","{F10}"),"__HotKey10")
	  HotKeySet(IniRead($mainINI,"HotKey","HotKeyExit","{F11}"),"_exit")

	  $sExitOnTargetWindowMissing = IniRead($mainINI,"General","ExitOnTargetWindowMissing",True)
   EndFunc

   func __HotKey1()
	  if not $bWait then _runScript($arHK[_ArraySearch($arHK,"HotKey1")][1])
   EndFunc
   func __HotKey2()
	  if not $bWait then _runScript($arHK[_ArraySearch($arHK,"HotKey2")][1])
   EndFunc
   func __HotKey3()
	  if not $bWait then _runScript($arHK[_ArraySearch($arHK,"HotKey3")][1])
   EndFunc
   func __HotKey4()
	  if not $bWait then _runScript($arHK[_ArraySearch($arHK,"HotKey4")][1])
   EndFunc
   func __HotKey5()
	  if not $bWait then _runScript($arHK[_ArraySearch($arHK,"HotKey5")][1])
   EndFunc
   func __HotKey6()
	  if not $bWait then _runScript($arHK[_ArraySearch($arHK,"HotKey6")][1])
   EndFunc
   func __HotKey7()
	  if not $bWait then _runScript($arHK[_ArraySearch($arHK,"HotKey7")][1])
   EndFunc
   func __HotKey8()
	  if not $bWait then _runScript($arHK[_ArraySearch($arHK,"HotKey8")][1])
   EndFunc
   func __HotKey9()
	  if not $bWait then _runScript($arHK[_ArraySearch($arHK,"HotKey9")][1])
   EndFunc
   func __HotKey10()
	  if not $bWait then _runScript($arHK[_ArraySearch($arHK,"HotKey10")][1])
   EndFunc

#endRegion hotkey


#Region Check
   func _checkRunDuplicate()
	  if ProcessExists(@ScriptName) then
		 _LogError("Duplicate process found")
		 Exit
	  Endif
   EndFunc

   func _waitForProcess($processName="")
	  Local $splashX = @DesktopWidth / 100*10
	  Local $splashY = @DesktopHeight / 100*10
	  if $processName="" then
		 _LogError("_waitForProcess"&@tab&"Process name could not be empty")
	  endif
	  _LogInfo("_waitForProcess"&@TAB&"Waiting for process")
	  SplashTextOn("Wait for Process" ,$processName&@CRLF&"...waiting",$splashX,$splashY)

	  While not ProcessExists($processName)
		 $bWaiting = True
		 sleep(100)
	  WEnd
	  $bWait = False
	  _LogInfo("_waitForProcess"&@TAB&"process found")
	  SplashTextOn("Wait for Process",$processName&@CRLF&"process found",$splashX,$splashY)
	  sleep(1000)
	  SplashOff()
   EndFunc

   Func _FolderIsWritable($sPath=@ScriptDir)
	  if FileGetAttrib($sPath) = "R" then
		 _LogError("Folder is read only")
	  EndIf
   EndFunc
#EndRegion Check

func _exit()
   _LogInfo("Exit process")
   splashoff()
   msgbox(0,@scriptname,"exit",2)
   Exit
EndFunc