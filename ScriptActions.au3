; #INDEX# =======================================================================================================================
; Title .........:
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...:
; Author(s) .....:
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;
; ===============================================================================================================================

;Includes needs global variables

#include "log.au3"
#include "click.au3"
#include <array.au3>
;#include "const.au3"


#Region ;set by Const.au3
;~    Global $iniDir
;~    Global $iniMain
;~    Global $iniHotKey
#EndRegion

#Region ;set Global
   Global $sExitOnTargetWindowMissing
   Global $arHK=			IniReadSection($iniHotKey, "HotKey")
   Global $sMainProcess = 	IniRead($iniMain,"General","TargetProcess","starter.exe")
   Global $bWait = 			IniRead($iniMain,"General","HotkeyWaitForTargetWindow",True)
#EndRegion

#Region ;set AutoItSetOption
   Opt("TrayIconHide", IniRead($iniMain,"Tray","TrayIconHide",True)) 	;(True/False) 	//==> Hides the tray icon.
   Opt("TrayMenuMode", IniRead($iniMain,"Tray","TrayMenuMode", 1))		;(1,2,4,8)		//==> Extend the behaviour of the script tray icon/menu.
   Opt("TrayAutoPause", IniRead($iniMain,"Tray","TrayAutoPause",False))	;(True/False) 	//==> Script pauses when click on tray icon.
#EndRegion

#Region ;on initializing
   _HotKey()							;set hotkeys
   _waitForProcess($sMainProcess)		;wait for process
   _FolderIsWritable()					;
   _Main()								;main loop
#EndRegion

;main
Func _Main()
   local $sExitOnTargetWindowMissing = IniRead($iniMain,"General","ExitOnTargetWindowMissing",True)

   ;main loop
   While ProcessExists($sMainProcess)
	  Sleep(100)
   WEnd

   ;exit if process lost
   if not ProcessExists($sMainProcess) and $sExitOnTargetWindowMissing then
	  _LogInfo("ProcessExists" &@TAB& "Process lost - EXIT")
	  Exit
   EndIf
EndFunc



#Region hotkey
   ;assign hotkeys
   func _HotKey()
	  if not isarray ($arHK) then
		 _LogError("_HotKey"&@tab&"HotKey.ini failure")
	  elseif $arHK[0][0] <> 10 then
		 _LogError("_HotKey"&@tab&"HotKey.ini Array has wrong range")
	  EndIf

	  HotKeySet(IniRead($iniMain,"HotKey","HotKey1","{F1}"),"__HotKey1")
	  HotKeySet(IniRead($iniMain,"HotKey","HotKey2","{F2}"),"__HotKey2")
	  HotKeySet(IniRead($iniMain,"HotKey","HotKey3","{F3}"),"__HotKey3")
	  HotKeySet(IniRead($iniMain,"HotKey","HotKey4","{F4}"),"__HotKey4")
	  HotKeySet(IniRead($iniMain,"HotKey","HotKey5","{F5}"),"__HotKey5")
	  HotKeySet(IniRead($iniMain,"HotKey","HotKey6","{F6}"),"__HotKey6")
	  HotKeySet(IniRead($iniMain,"HotKey","HotKey7","{F7}"),"__HotKey7")
	  HotKeySet(IniRead($iniMain,"HotKey","HotKey8","{F8}"),"__HotKey8")
	  HotKeySet(IniRead($iniMain,"HotKey","HotKey9","{F9}"),"__HotKey9")
	  HotKeySet(IniRead($iniMain,"HotKey","HotKey10","{F10}"),"__HotKey10")
	  HotKeySet(IniRead($iniMain,"HotKey","HotKeyExit","{F11}"),"_exit")
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
   ; avoid duplicated runs
   func _checkRunDuplicate()
	  if ProcessExists(@ScriptName) then
		 _LogError("Duplicate process found")
		 Exit
	  Endif
   EndFunc

   ; wait for process which should be monitored
   func _waitForProcess($processName="")
	  ; dimensions for splash screen
	  Local $splashX = Floor(@DesktopWidth / 100*IniRead($iniMain,"Splash","Width", 10))
	  Local $splashY = Floor(@DesktopHeight /100*IniRead($iniMain,"Splash","Height", 10))
	  Local $bSplashVisible = IniRead($iniMain,"Splash","Visible", True)
	  ;check user input - process name
	  if $processName="" then
		 _LogError("_waitForProcess"&@tab&"Process name could not be empty")
	  endif
	  _LogInfo("_waitForProcess"&@TAB&"Waiting for process")
	  if $bSplashVisible then SplashTextOn("Wait for Process" ,$processName&@CRLF&"...waiting",$splashX,$splashY)

	  ; wait for process
	  While not ProcessExists($processName)
		 $bWaiting = True
		 sleep(100)
	  WEnd

	  $bWait = False ;allows hotkeys
	  _LogInfo("_waitForProcess"&@TAB&"process found")
	  if $bSplashVisible then SplashTextOn("Wait for Process",$processName&@CRLF&"process found",$splashX,$splashY)
	  sleep(1000)
	  SplashOff()
   EndFunc

   ; checks if called path is writable
   Func _FolderIsWritable($sPath=@ScriptDir)
	  if FileGetAttrib($sPath) = "R" then
		 _LogError("Folder is read only")
	  EndIf
   EndFunc
#EndRegion Check

#Region Envirement
   ;shutdown routine
   func _exit()
	  _LogInfo("Exit process")
	  splashoff()
	  msgbox(0,@scriptname,"exit",2)
	  Exit
   EndFunc
#EndRegion
