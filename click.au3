; #INDEX# =======================================================================================================================
; Title .........: Click
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Functions for doing keyboard/mouse interactions
; Author(s) .....:
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _doAction
; _runScript
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __ReadActions
; __scriptHandler
; ===============================================================================================================================

#include <array.au3>
#include "Log.au3"
#include <File.au3>
#include "const.au3"
#include-once

;~ ;remove this line ==> only for debug
;~ ;Global $iniDir= @ScriptDir&"\"&"Config\"	;$iniDir set by ScriptActions.au3

; #VARIABLE# ====================================================================================================================
;Global $iniDir				; $iniDir set by ScriptActions.au3
;Global $actionScriptDir	; dir contains action files
;Global $iniActions			; list with mouse coordinates and key bindings
Global $arActions			; set an array with all actions (example: MouseMoveTest= 100,100)
Global $bClick				; do click-actions
Global $iLoopSpeed			; loop speed in ms
; -------------------------------------------------------------------------------------------------------------------------------
   $arActions = __ReadActions()
   $bClick=		IniRead($iniMain,"Simulation","MouseClickEnabled", true)
   $iLoopSpeed=	IniRead($iniMain,"Simulation","LoopSpeed", 10)
; ===============================================================================================================================

; #Envirement# ==================================================================================================================
Opt("MouseClickDelay",IniRead($iniMain,"Simulation","MouseClickDelay", 10))
Opt("SendKeyDelay", IniRead($iniMain,"Simulation","SendKeyDelay",5))
Opt("SendKeyDownDelay",IniRead($iniMain,"Simulation","SendKeyDownDelay", 1))
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _doAction
; Description ...: executes a single action, defined by actions.ini
; Syntax.........: _doAction($sAction)
; Parameters ....: $sAction - String //expect action from action file (example: MouseMoveTest)
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......: __ReadActions
; Link ..........:
; Example .......: _doAction('MouseMoveTest')
; ===============================================================================================================================
func _doAction($sAction)
   if $sAction="" then return ""
   Local $iIndex = _ArraySearch($arActions,$sAction)
   if @error then
	  _LogInfo("_doAction -> _ArraySearch" &" "&"ErrorCode: "&@error)
	  return ""
   EndIf

   Local $sArValue = $arActions[$iIndex][1]
   Local $arXY

   if stringleft($sAction,4)= "Push" then
	  Send($sArValue)
	  _LogInfo("_doAction" &@tab&"Key sent: "&$sArValue)
	  ConsoleWrite("Key sent: "&$sArValue&@CRLF)
   ElseIf stringleft($sAction,5)= "Click" then
	  if StringInStr($sArValue,",") Then
		 $arXY = StringSplit($sArValue,",",$STR_NOCOUNT)
		 MouseMove($arXY[0],$arXY[1],0)
		 sleep($iLoopSpeed)
		 if $bClick then MouseClick("primary")
		 ConsoleWrite("Mouse move: "&$arXY[0]& " "&$arXY[1]&@CRLF)
		 _LogInfo("_doAction" &@tab&"Mouse move: "&$sArValue)
	  EndIf
   EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _runScript
; Description ...: reads actions from script and execute
; Syntax.........: _runScript($sScriptName="")
; Parameters ....: $sScriptName - String //expect a script
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: _runScript('MyScript.txt')
; ===============================================================================================================================
Func _runScript($sScriptName="")

   if $sScriptName="" then
	  _LogInfo("_runScript" &@tab&"No script name given")
	  RETURN ""
   EndIf

   local $arfilelist = _FileListToArray( $actionScriptDir,"*.txt",$FLTA_FILES)
   if @error then
	  _LogWarning("_runScript" &@tab&"error code: "&@error)
	  RETURN ""
   EndIf
   _ArrayDelete($arfilelist,0)
   _ArraySearch($arfilelist, $sScriptName)
   Switch @error
	  case 6
		 _LogWarning("_runScript" &@tab&"Script not found")
		 return ""
	  case Else
		 if @error then
			_LogWarning("_runScript" &@tab&"error code: "&@error)
			return ""
		 EndIf
   EndSwitch
;~    if @error then
;~ 	  _LogWarning("_runScript" &@tab&"error code: "&@error)
;~ 	  return ""
;~    endif

   local $arActions = __scriptHandler($actionScriptDir&$sScriptName)

   for $sAction in $arActions
	  ConsoleWrite($sAction&@CRLF)
	  _doAction($sAction)
   Next
EndFunc

; #FOR_INTERNAL_USE_ONLY# =======================================================================================================
; Name...........: __ReadActions
; Description ...: Reads all possible actions from actions.ini
; Syntax.........: __ReadActions()
; Parameters ....:
; Return values .: array with possible actions (2D-array with 2 columns)
; Author ........:
; Modified.......:
; Remarks .......: for internal use only
; Related .......:
; Link ..........:
; Example .......: __ReadActions()
; ===============================================================================================================================
func __ReadActions()
   local $arActions = IniReadSection($iniActions,"Actions")
   _ArrayDelete($arActions,0)
   return $arActions
EndFunc

; #FOR_INTERNAL_USE_ONLY# =======================================================================================================
; Name...........: __scriptHandler
; Description ...: convets a script to an array containing comands and removes comments etc.
; Syntax.........: __scriptHandler($sScriptDir)
; Parameters ....: $sScriptDir - String //expect a path with a single script
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......: for internal use only
; Related .......:
; Link ..........:
; Example .......: __scriptHandler(%HOMEDIR&'\Scripts\myScript.txt')
; ===============================================================================================================================
func __scriptHandler($sScriptDir)
   local $arOutput[0]
   local $arFile = FileReadToArray($sScriptDir)
   if @error then
	  _LogWarning("__scriptHandler" &@tab&"error code: "&@error)
	  return ""
   EndIf

   ;Remove spaces, empty lines, etc.
   for $sEntry in $arFile
	  Switch $sEntry
		 case " "
			ContinueLoop

		 Case ""
			ContinueLoop

		 Case ";"
			ContinueLoop
	  EndSwitch

	  ;remove comments
	  if StringLeft($sEntry,1) = ";" then ContinueLoop
	  Redim $arOutput[UBound($arOutput)+1]
	  $arOutput[UBound($arOutput)-1] = $sEntry
   Next

   return $arOutput
EndFunc