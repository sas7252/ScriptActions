; #INDEX# =======================================================================================================================
; Title .........: Log
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Only simple log functions
;				   - Creates a (log)file in the script dir
;			       - return messagebox alerts
; Author(s) .....:
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _LogError
; _LogWarning
; _LogInfo
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __Log
; ===============================================================================================================================

#include <Date.au3>
#include <MsgBoxConstants.au3>
#include-once

; #VARIABLE# ====================================================================================================================
Global $LOG_DIR
; ===============================================================================================================================



; #FUNCTION# ====================================================================================================================
; Name...........: _LogError
; Description ...:
; Syntax.........: _LogError($sErrorMessage="",$bShowMsgbox = true)
; Parameters ....: 	- $sErrorMessage	String
;					- $bShowMsgbox		Boolean
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: _LogError('Error message')
; ===============================================================================================================================
func _LogError($sErrorMessage="",$bShowMsgbox = true)
   __Log($sErrorMessage, $LOG_DIR,"FATAL: ")
   SplashOff()
   if $bShowMsgbox then MsgBox(BitOR($MB_TOPMOST,$MB_ICONERROR),"Error!", $sErrorMessage)
   Exit
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _LogWarning
; Description ...:
; Syntax.........: _LogWarning($sErrorMessage="",$bShowMsgbox = true)
; Parameters ....: 	- $sErrorMessage	String
;					- $bShowMsgbox		Boolean
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: _LogWarning('message')
; ===============================================================================================================================
func _LogWarning($sErrorMessage="",$bShowMsgbox = true)
   __Log($sErrorMessage, $LOG_DIR,"WARNING: ")
   SplashOff()
   if $bShowMsgbox then MsgBox(BitOR($MB_TOPMOST,$MB_ICONWARNING),"WARNING!", $sErrorMessage)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _LogInfo
; Description ...:
; Syntax.........: _LogInfo($sErrorMessage="",$bShowMsgbox = False)
; Parameters ....: 	- $sErrorMessage	String
;					- $bShowMsgbox		Boolean
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: _LogInfo('message')
; ===============================================================================================================================
func _LogInfo($sErrorMessage="", $bShowMsgbox = False)
   __Log($sErrorMessage, $LOG_DIR,"INFO: ")
   if $bShowMsgbox then
	  SplashOff()
	  MsgBox(BitOR($MB_TOPMOST,$MB_ICONINFORMATION),"Info: ", $sErrorMessage)
   EndIf
EndFunc

; #FOR_INTERNAL_USE_ONLY# =======================================================================================================
; Name...........: __Log
; Description ...:
; Syntax.........: __Log($Data, $FileName = "", $TimeStamp = True, $logStage="INFO: ")
; Parameters ....: 	- $Data 	 - string 	//Message
;					- $FileName  - string 	//File dir and name (default: @ScriptDir & '\Log.txt')
;					- $TimeStamp - boolean 	//
;					- $logStage  - String	//
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......: for internal use only
; Related .......:
; Link ..........:
; Example .......: Func __Log("My message", Default, True, "WARNING: ")
; ===============================================================================================================================
Func __Log($Data, $FileName = "", $TimeStamp = True, $logStage="INFO: ")
   ;reads file dir and name
    If $FileName = "" Then $FileName = @ScriptDir & '\Log.txt'
   ;open file in write mode
    $hFile = FileOpen($FileName, 1)
    If $hFile <> -1 Then
        If $TimeStamp = True Then $Data = _Now() & ' - ' & $logStage & ' - ' &$Data
        FileWriteLine($hFile, $Data)
        FileClose($hFile)
    EndIf
EndFunc