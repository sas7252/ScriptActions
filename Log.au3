#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Samuel Schreiber

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------



#include <Date.au3>
#include <MsgBoxConstants.au3>
#include-once

Global $LOG_DIR


func _LogError($sErrorMessage="")
   __Log($sErrorMessage, $LOG_DIR,"FATAL: ")
   SplashOff()
   MsgBox(BitOR($MB_TOPMOST,$MB_ICONERROR),"Error!", $sErrorMessage)
   Exit
EndFunc

func _LogInfo($sErrorMessage="")
   __Log($sErrorMessage, $LOG_DIR,"INFO: ")
EndFunc

func _LogWarning($sErrorMessage="")
   __Log($sErrorMessage, $LOG_DIR,"WARNING: ")
   SplashOff()
   MsgBox(BitOR($MB_TOPMOST,$MB_ICONWARNING),"WARNING!", $sErrorMessage)
EndFunc

Func __Log($Data, $FileName = "", $TimeStamp = True, $logStage="INFO: ")
    If $FileName = "" Then $FileName = @ScriptDir & '\Log.txt'
    ;Send($Data)
    $hFile = FileOpen($FileName, 1)
    If $hFile <> -1 Then
        If $TimeStamp = True Then $Data = _Now() & ' - ' & $logStage & ' - ' &$Data
        FileWriteLine($hFile, $Data)
        FileClose($hFile)
	 EndIf
EndFunc