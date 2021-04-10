##Local Group Policy Transfer Tool    --ss 2021


##show messages and check for admin privileges

Write-Host "2021 Steven Soward |  MIT License

Checking for elevated permissions..."
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
[Security.Principal.WindowsBuiltInRole] "Administrator")) {
Write-Warning "Insufficient permissions to run this script. Open the PowerShell console as an administrator and run this script again."

#notify and exit if not admin

Add-Type -AssemblyName Microsoft.VisualBasic
$urnotadmin=[System.Windows.MessageBox]::Show("Please re-run this script as administrator", 'LGP Transfer Tool','ok')

exit
}
else {
Write-Host "LGP Transfer Tool is running as administrator..." -ForegroundColor Green

Write-Host "Please specify a directory that does not contain existing GP data" -ForegroundColor magenta

}


##Local/mapped drive selection dialogue



Function Get-Folder($initialDirectory="")
{
    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $browse = New-Object System.Windows.Forms.FolderBrowserDialog
    $browse.SelectedPath = "C:\"
    $browse.ShowNewFolderButton = $true
    $browse.Description = "Select a Directory for LGP export - network drives may be used"

    $loop = $true
    while($loop)
    {
        if ($browse.ShowDialog() -eq "OK")
        {
        $loop = $false
		
		#Insert your script here
		
        } else
        {
            $res = [System.Windows.Forms.MessageBox]::Show("You clicked Cancel. Would you like to try again or cancel?", "Select a location", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
            if($res -eq "Cancel")
            {
               exit
            }
        }
    }
    $browse.SelectedPath
    $browse.Dispose()
}




###user interaction for network or local file 



Add-Type -AssemblyName Microsoft.VisualBasic
$Netorlocal = [Microsoft.VisualBasic.Interaction]::InputBox('Specify Backup Directory:

Enter a Network Path or leave this field blank to select a local file or mapped drive in the next step
', 'LGP Transfer Tool')

if ($Netorlocal -lt "0")

{

$backupdirectory = Get-Folder
write-host "a local path is being used"

} 

else 

{ 

$backupdirectory=netorlocal
}






#_____________________________________________________________________
####Back up the local group policy to specified directory ####


#$backupdirectory = "C:\Users\$env:UserName\Desktop\lgpBackup" 
md -f $backupdirectory
cp c:\windows\System32\GroupPolicy  $backupdirectory -Recurse -Force -Passthru

Secedit /export /cfg $backupdirectory\SecurityConfig.csv
Auditpol /backup /file:$backupdirectory\AuditPolicy.ini


### makes a powershell script in the specified location 
$newimportscript = '
#LGP transfer tool
#This script will import the lgp files from the directory where the script exists



$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

write-host "2021 Steven Soward |  MIT License

Importing Local Group Policy from $scriptdir"

secedit /configure /cfg $scriptdir/SecurityConfig.csv /db c:\windows\System32\GroupPolicy\defltbase.sdb /verbose

cp $scriptdir/GroupPolicy c:\windows\System32\GroupPolicy

Auditpol /restore /file:$scriptdir\AuditPolicy.ini

write-host "Local Group Policy Imported" -ForegroundColor Green
'

$newimportscript>>C:\Users\steven.soward\new1.ps1
$newimportscript>>$backupdirectory/ImportScript.ps1

Add-Type -AssemblyName PresentationFramework

$userresponseend=[System.Windows.MessageBox]::Show("The files have been backed up at $backupdirectory

Please Run the powershell script that was generated there from the destination machine, this will import the LGP ", 'LGP Transfer Tool','ok')
if ($UserResponseend -eq "ok")
{

#Yes activity
write-host "cleaning-up temp files and closing"
stop-transcript
rv * -ea SilentlyContinue; rmo *; $error.Clear(); cls
exit
} 