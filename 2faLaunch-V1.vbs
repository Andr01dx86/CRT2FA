#$language = "VBScript"
#$interface = "1.0"
'Andrew Mueller, Network Delivery
'This plugin requires:
'1. Golang to be installed (https://golang.org/dl/) then reboot
'2. rcs/2fa (https://github.com/rsc/2fa) files (unzipped) to be in the %COMSPEC% (default command prompt)
'3. a .2fa file for the account "NM" in the %COMSPEC% and C:\Windows\System32. Open cmd and run "go get -u rsc.io/2fa" than "2fa -add NM" to generate one.
'4. The .2fa you generate must have a seed from your NM microsoft account (https://mysignins.microsoft.com/security-info)
'5. This plugin must run in CRT. It will not work in Windows.
Sub Main
     crt.Screen.Synchronous = True
     'Wait for target word, open shell, read output to string and close shell
     If crt.Screen.WaitForString ("code", 10) then
         crt.sleep 1000
	     Set objShell = CreateObject("WScript.Shell")
         Set objWshScriptExec = objShell.Exec("cmd /K 2fa NM")
         Set objStdOut = objWshScriptExec.StdOut
         strAuth = objStdOut.ReadLine
         objWshScriptExec.Terminate
		 'Check if the one time code was generated or error
	     If strAuth = "" then
             msgbox "Could not get 2fa string. Are .2fa and .vbs files in %USERPROFILE% and %COMPSEC%?"
         Else
		     'Send Auth and return
		     crt.Screen.Send strAuth & chr(13)
	     End If
     Else
	     'Error if "code not found"
         msgbox "Session did not find the word code within 10 seconds. Problem with CyberArk or reaching CyberArk"
	 End If
     crt.Screen.Synchronous = False
end Sub