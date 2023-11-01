# $language = "VBScript"
# $interface = "1.0"
'Andrew Mueller, Network Delivery
'This plugin requires:
'1. Golang to be installed (https://golang.org/dl/) then reboot
'2. rcs/2fa (https://github.com/rsc/2fa) files (unzipped) to be in the %COMSPEC% (default command prompt)
'3. Open cmd and run "go get -u rsc.io/2fa" than "2fa -add NM" to generate one.
'4. The .2fa you generate must have a seed from your NM microsoft account (https://mysignins.microsoft.com/security-info)
'5. Copy the .2fa from your %COMSPEC% folder to C:\Windows\System32
'5. There must be a saved session in CRT "Sessions\Discovery" with a saved password. (connect to a host once to prompt crt to save a password)
'6. This plugin must run in CRT. It will not work in Windows.
'7. If you get an error when trying to save your prepend, simply create a file named "prepend.txt" that contains your prepend and put it in C:
Sub Main
 'Check if c:\prepend.txt exsists 
 Set fso = CreateObject("Scripting.FileSystemObject")
 If fso.FileExists("c:\prepend.txt") Then
	 Set objFileToRead = CreateObject("Scripting.FileSystemObject").OpenTextFile("C:\prepend.txt",1)
     strPrepend = objFileToRead.ReadAll()
     objFileToRead.Close
     Set objFileToRead = Nothing
	 'Begin
     crt.Screen.Synchronous = True
     host = "172.27.16.126"
     'Ask user where they're goin'
     strIP = crt.Dialog.Prompt("Enter Target IP:", "Target IP", "", False)
     'If no input/cancel then skip to end
     If strIP = "" then
         msgbox "User Cancelled"
     Else
         strUsername = strPrepend & strIP
         ' Load config from Sessions\Discovery (including encrypted Password)
         set config = crt.OpenSessionConfiguration("Discovery")
         'build command
         cmd = "/SSH2 /L " & strUsername & " /ENCRYPTEDPASSWORD " & config.GetOption("Password") & " /C AES-128-GCM /M SHA1 " & host
         'open shell put output to var save var as str then kill shell
         Set objShell = CreateObject("WScript.Shell")
         Set objWshScriptExec = objShell.Exec("cmd /K 2fa NM")
         Set objStdOut = objWshScriptExec.StdOut
         strAuth = objStdOut.ReadLine
         objWshScriptExec.Terminate
         'Check if code was generated
         If strAuth = "" then
             msgbox "Could not get 2fa string. Are .2fa and .vbs files in %USERPROFILE% and %COMPSEC%?"
         Else
             'connect, wait for "code" send auth and enter or error
             Set g_objTab = crt.Session.ConnectinTab(cmd,True,True)
			 If g_objTab.Session.Connected Then
                             g_objTab.Caption = strIP
			 Else
			         msgbox "Session could not connect. Problem with CyberArk or reaching CyberArk."
                         End If
	End If
     End If
     crt.Screen.Synchronous = False
 Else
     'Ask for the users prepend and save to c:\prepent.txt
     strPrepend = crt.Dialog.Prompt("Enter CyberArk CRT Prepend. Example: NMXXXXXX@PAXXXXXX#NM@", "CRT Prepend Request", "", False)
     If strPrepend = "" then
         msgbox "User Cancelled"
	 Else
         Set f = fso.OpenTextFile("c:\prepend.txt", 2, True)
         f.Write strPrepend
         f.Close
	     Set objFileToRead = CreateObject("Scripting.FileSystemObject").OpenTextFile("C:\prepend.txt",1)
         strPrepend = objFileToRead.ReadAll()
         objFileToRead.Close
         Set objFileToRead = Nothing
	     msgbox "Your prepend has been saved to C:\prepend.txt. This will be referenced next time you run 2faDiscovery. Your prepend is: " & strPrepend
	 End If
 End If
 End Sub