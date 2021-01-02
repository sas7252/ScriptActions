#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Samuel Schreiber

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------


;#RequireAdmin




HotKeySet("{F11}", "_exit")
HotKeySet("{Space}", "_coord")

Local $txtFilePath = @ScriptDir &"\"
local $txtFileName = "coord.txt"
Global $txtdir = $txtFilePath&$txtFileName

while sleep(100)

wend



Func _coord()
   FileWriteLine($txtdir,MouseGetPos()[0]&" "&MouseGetPos()[1])
EndFunc



func _exit()
   MsgBox(0,0,"exit",1)
   exit
endfunc
