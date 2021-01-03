#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <array.au3>
#include "Log.au3"
#include <File.au3>
#include-once


;remove this line; only for debug
;Global $iniDir= @ScriptDir&"\"&"Config\"

Global $actionScriptDir=@ScriptDir&"\"&"scripts\"
Global $iniActions = $iniDir &"actions.ini"
Global $arActions = __ReadActions()
Global $bClick = True



;_runScript()
;__scriptHandler($actionScriptDir&"bestDrivingConditions.txt")
;_runScript("bestDrivingConditions.txt")

func __ReadActions()
   local $arActions = IniReadSection($iniActions,"Actions")
   _ArrayDelete($arActions,0)
   return $arActions
EndFunc

func _doAction($sAction)
   if $sAction="" then return ""
   Local $iIndex = _ArraySearch($arActions,$sAction)
   if @error then
	  _LogInfo("_doAction" &@tab&"ErrorCode: "&@error)
	  return ""
   EndIf

   Local $sArValue = $arActions[$iIndex][1]
   Local $arXY

   if $sAction= "PushToggleMenuKey" Then
	  Send($sArValue)
	  _LogInfo("_doAction" &@tab&"Key sent: "&$sArValue)
   Else
	  if StringInStr($sArValue,",") Then
		 $arXY = StringSplit($sArValue,",",$STR_NOCOUNT)
		 MouseMove($arXY[0],$arXY[1],0)
		 sleep(10)
		 if $bClick then MouseClick("primary")
		 ConsoleWrite("Mouse move: "&$arXY[0]& " "&$arXY[1]&@CRLF)
		 _LogInfo("_doAction" &@tab&"Mouse move: "&$sArValue)
	  EndIf
   EndIf
EndFunc

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


func __scriptHandler($sScriptDir)
   local $arOutput[0]
   local $arFile = FileReadToArray($sScriptDir)
   if @error then
	  _LogWarning("__scriptHandler" &@tab&"error code: "&@error)
	  return ""
   EndIf

   for $sEntry in  $arFile
	  Switch $sEntry
		 case " "
			ContinueLoop

		 Case ""
			ContinueLoop

		 Case ";"
			ContinueLoop
	  EndSwitch
	  if StringLeft($sEntry,1) = ";" then ContinueLoop
	  Redim $arOutput[UBound($arOutput)+1]
	  $arOutput[UBound($arOutput)-1] = $sEntry
   Next
   return $arOutput
EndFunc