'Andrew Mueller, Network Delivery
'This plugin requires:
'1. Golang to be installed (https://golang.org/dl/) then reboot
'2. rcs/2fa (https://github.com/rsc/2fa) files (unzipped) to be in the %COMSPEC% (default command prompt)
'3. a .2fa file for the account "NM" in the %COMSPEC% and C:\Windows\System32. Open cmd and run "go get -u rsc.io/2fa" than "2fa -add NM" to generate one.
'4. The .2fa you generate must have a seed from your NM microsoft account (https://mysignins.microsoft.com/security-info)
'5. This plugin will run in Windows and CRT
Set objShell = CreateObject("WScript.Shell")
Set objWshScriptExec = objShell.Exec("cmd /K 2fa NM")
Set objStdOut = objWshScriptExec.StdOut
strAuth = objStdOut.ReadLine
MsgBox(strAuth)