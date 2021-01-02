#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <file.au3>
#include <array.au3>
#include <MsgBoxConstants.au3>
;#RequireAdmin


local $iniDir = @ScriptDir&"\config.ini"
if not FileExists($iniDir) then _createINI()

Global $iINIMouseLoopSpeed 	;= Number(IniRead($iniDir,"Mouse", "MouseLoopSpeed", "20"))
Global $iINIMouseMoveSpeed 	;= Number(IniRead($iniDir,"Mouse", "MouseMoveSpeed", "0"))
;Global $iINIMouseClickSpeed ;= Number(IniRead($iniDir,"Mouse", "MouseClickSpeed", "10"))
Global $iINIWaitBeforeClick ;= Number(IniRead($iniDir,"Mouse", "WaitBeforeClick", "10"))
Global $sINIFileSeperator 	;= IniRead($iniDir,"General", "FileSeperator", "")
Global $bDebugClickEnabled 	;= IniWrite($iniDir,"Debug", "MouseClickEnabled", True)
_INIReRead()

HotKeySet(IniRead($iniDir,"Hotkey", "Exit", "{F1}"), "_exit")
HotKeySet(IniRead($iniDir,"Hotkey", "MouseMove", "{F2}"), "_mousemovefromfile")

Local $txtFilePath = IniRead($iniDir,"General", "CoordFilePath", @ScriptDir &"\")
local $txtFileName = IniRead($iniDir,"General", "CoordFileName", "coord.txt")
Global $txtdir = $txtFilePath&$txtFileName

while sleep(100)

wend



Func _coord()
   FileWriteLine($txtdir,MouseGetPos()[0]&" "&MouseGetPos()[1])
EndFunc


func _MouseMoveFromFile()
   _INIReRead()
   local $arPositions
   if $sINIFileSeperator = "" then $sINIFileSeperator = " "
   _FileReadToArray($txtdir, $arPositions,default, $sINIFileSeperator)
   if @error then _error("Error code: "&@error &@CRLF &"Function: " &"_FileReadToArray")

   for $i= 0 to ubound($arpositions)-1
	  _coordClick($arpositions[$i][0],$arpositions[$i][1])
	  sleep(Number($iINIMouseLoopSpeed))
   Next
endfunc

Func _coordClick($x, $y)
   $x = Number($x)
   $y = Number($y)
   MouseMove($x, $y,$iINIMouseMoveSpeed)
   sleep($iINIWaitBeforeClick)
   if $bDebugClickEnabled then MouseClick("primary")
EndFunc

func _createINI($iniDir = $iniDir)
   IniWrite($iniDir,"General", "CoordFilePath", "")
   IniWrite($iniDir,"General", "CoordFileName", "coord.txt")
   IniWrite($iniDir,"General", "FileSeperator", "")

   IniWrite($iniDir,"Hotkey", "Exit", "{F1}")
   IniWrite($iniDir,"Hotkey", "MouseMove", "{F2}")

   IniWrite($iniDir,"Mouse", "MouseLoopSpeed", "20")
   IniWrite($iniDir,"Mouse", "MouseMoveSpeed", "0")
   ;IniWrite($iniDir,"Mouse", "MouseClickSpeed", "10")
   IniWrite($iniDir,"Mouse", "WaitBeforeClick", "10")

   IniWrite($iniDir,"Debug", "MouseClickEnabled", True)
EndFunc

func _INIReRead()
   $iINIMouseLoopSpeed = Number(IniRead($iniDir,"Mouse", "MouseLoopSpeed", "20"))
   $iINIMouseMoveSpeed = Number(IniRead($iniDir,"Mouse", "MouseMoveSpeed", "0"))
   ;$iINIMouseClickSpeed = Number(IniRead($iniDir,"Mouse", "MouseClickSpeed", "10"))
   $iINIWaitBeforeClick = Number(IniRead($iniDir,"Mouse", "WaitBeforeClick", "10"))
   $sINIFileSeperator = IniRead($iniDir,"General", "FileSeperator", "")
   $bDebugClickEnabled = IniWrite($iniDir,"Debug", "MouseClickEnabled", True)
EndFunc

func _exit()
   MsgBox(0,@ScriptName,"exit",1)
   exit
endfunc

func _error($sMSG=" ")
   MsgBox(BitOR($MB_SYSTEMMODAL,$MB_TOPMOST,$MB_ICONERROR),"ERROR!", $sMSG)
   Exit
EndFunc