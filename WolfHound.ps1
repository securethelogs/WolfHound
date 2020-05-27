  #Requires -RunAsAdministrator

 $logo = @( '                       
                                                                                                          ....
                                                                                                         .   ;\
                                                                                                        /  :  ._;
                                                                                                       / _.;  :Tb|
                                                                                                      /   /   ;j$j
                                                                                                  _.-"       d$$$$
   █     █░ ▒█████   ██▓      █████▒██░ ██  ▒█████   █    ██  ███▄    █ ▓█████▄                 ./ ..       d$$$$;
 ▓█░ █ ░█░▒██▒  ██▒▓██▒    ▓██   ▒▓██░ ██▒▒██▒  ██▒ ██  ▓██▒ ██ ▀█   █ ▒██▀ ██▌                /  /X`      d$$$$P. |\
 ▒█░ █ ░█ ▒██░  ██▒▒██░    ▒████ ░▒██▀▀██░▒██░  ██▒▓██  ▒██░▓██  ▀█ ██▒░██   █▌               /   "      .d$$$P` |\^"l
 ░█░ █ ░█ ▒██   ██░▒██░    ░▓█▒  ░░▓█ ░██ ▒██   ██░▓▓█  ░██░▓██▒  ▐▌██▒░▓█▄   ▌             .`           `T$P^"""""  :
 ░░██▒██▓ ░ ████▓▒░░██████▒░▒█░   ░▓█▒░██▓░ ████▓▒░▒▒█████▓ ▒██░   ▓██░░▒████▓          ._.`      _.`                ;
 ░ ▓░▒ ▒  ░ ▒░▒░▒░ ░ ▒░▓  ░ ▒ ░    ▒ ░░▒░▒░ ▒░▒░▒░ ░▒▓▒ ▒ ▒ ░ ▒░   ▒ ▒  ▒▒▓  ▒       `-.-".-!-` ._.       _.-"    .-"
  ▒ ░ ░    ░ ▒ ▒░ ░ ░ ▒  ░ ░      ▒ ░▒░ ░  ░ ▒ ▒░ ░░▒░ ░ ░ ░ ░░   ░ ▒░ ░ ▒  ▒      `.-" _____  ._              .-"
  ▒ ░ ░    ░ ▒ ▒░ ░ ░ ▒  ░ ░      ▒ ░▒░ ░  ░ ▒ ▒░ ░░▒░ ░ ░ ░ ░░   ░ ▒░ ░ ▒  ▒     -(.($$$$$$$e.              .
   ░   ░  ░ ░ ░ ▒    ░ ░    ░ ░    ░  ░░ ░░ ░ ░ ▒   ░░░ ░ ░    ░   ░ ░  ░ ░  ░      ""^^T$$$P^)            .(:
     ░        ░ ░      ░  ░        ░  ░  ░    ░ ░     ░              ░    ░           _/  -"  /.         /:/;
                                                                        ░          ._.`-``-`  `)/         /;/;
                                                                                `-.-"..--""   " /         /  ;
   Creator: Securethelogs.com     |    @securethelogs                          .-" ..--""        -`          :
                                                                               ..--""--.-`         (\      .-(\
                                                                                 ..--""              `-\(\/;`
                                                                                   _.                      :
')


$logo

Write-Output "Let's hunt....."
Start-Sleep -Seconds 3

Write-Output ""

Write-Output "--- Anti-virus present ---"
Write-Output ""
(Get-CimInstance -Namespace root/securitycenter2 -ClassName antivirusproduct).displayName

Write-Output ""

Write-Output "--- Current logged on users ---"
Write-Output ""
(Get-CimInstance win32_LoggedOnUser).Antecedent.Name | Get-Unique

Write-Output ""

if((Get-Service WinRM).Status -ne "running"){

Write-Output "Enabling WinRM service..."

  Get-Service WinRM | Set-Service -Status Running

}

Write-Output ""



try {Get-PSSession -Name "hashcheck" -ErrorAction SilentlyContinue | Remove-PSSession ; Get-Job -Name "hashcheck" -ErrorAction SilentlyContinue | Remove-Job} catch {

# No Session

}

try {Get-PSSession -Name "networkcheck" -ErrorAction SilentlyContinue | Remove-PSSession ; Get-Job -Name "networkcheck" -ErrorAction SilentlyContinue | Remove-Job} catch {

# No Session

}

try {Get-PSSession -Name "taskcheck" -ErrorAction SilentlyContinue | Remove-PSSession ; Get-Job -Name "taskcheck" -ErrorAction SilentlyContinue | Remove-Job} catch {

# No Session

}

try {Get-PSSession -Name "eventcheck" -ErrorAction SilentlyContinue | Remove-PSSession ; Get-Job -Name "eventcheck" -ErrorAction SilentlyContinue | Remove-Job} catch {

# No Session

}



# Start Sessions

$hashcheck = New-PSSession -Name "hashcheck"
$networkcheck = New-PSSession -Name "networkcheck"
$taskcheck = New-PSSession -Name "taskcheck"
$eventcheck = New-PSSession -Name "eventcheck"

if ((Get-PSSession -Name "hashcheck") -ne $null){Write-Output "Hash Scan Started..."}
if ((Get-PSSession -Name "networkcheck") -ne $null){Write-Output "Network Check Started..."}
if ((Get-PSSession -Name "taskcheck") -ne $null){Write-Output "Persistence Check Started..."}
if ((Get-PSSession -Name "eventcheck") -ne $null){Write-Output "Event Check Started..."}



Invoke-Command -Session $hashcheck -ScriptBlock {


$StopWatch = New-Object -TypeName System.Diagnostics.Stopwatch

### Edit this line ###

$tmp = "C:\temp\tmp.txt"

### Edit this line ###

(curl https://raw.githubusercontent.com/securethelogs/WolfHound/master/Hashes/md5_hashes.txt -UseBasicParsing).content | Out-File $tmp

$Hashdb = @(Get-Content $tmp)

Remove-Item -Path $tmp -Force



$badfile = @()

$qs = @((Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue).fullname | Where-Object {$_ -notlike "C:\Windows\*" -and $_ -notlike "C:\Program Files\*" -and $_ -notlike "C:\Program Files (x86)\*" -and $_ -notlike "C:\ProgramData\*"})
$qsh = @((Get-ChildItem -Path C:\ -Recurse -Hidden -ErrorAction SilentlyContinue).fullname | Where-Object {$_ -notlike "C:\Windows\*" -and $_ -notlike "C:\Program Files\*" -and $_ -notlike "C:\Program Files (x86)\*" -and $_ -notlike "C:\ProgramData\*"})
$qs +=$qsh

$fts = $qs.count



$StopWatch.Start()

foreach ($o in $qs){

### Edit this line for MD5 to Algorithm ###

$fh = (Get-FileHash -Path $o -Algorithm MD5 -ErrorAction SilentlyContinue).Hash 

if(($Hashdb.Contains($fh)) -eq "True"){

$badfile +=  "File Location: " + $o + "   |  " + "Hash: " + $fh


} else {

# Move on

   }




 }

  $StopWatch.Stop()

Write-Output "--- Hash Check Results ---"
Write-Output ""

Write-Output "Files Scanned: $fts."
 
 $m =  ($StopWatch).Elapsed.Minutes
 $h =  ($StopWatch).Elapsed.Hours
 $s =  ($StopWatch).Elapsed.Seconds

 Write-Output "Scanning time: Hours: $h  Mins: $m  Seconds: $s"

 Write-Output ""

 if ($badfile -ne $null){

 Write-Output "--- Hash Match Found ---"
 Write-Output ""

 $badfile

 } else {
 
 Write-Output "No Hash Match Found..."
 
 }

 Write-Output ""

} -AsJob -JobName "hashcheck" 



Invoke-Command -Session $networkcheck -ScriptBlock {


$StopWatch = New-Object -TypeName System.Diagnostics.Stopwatch

Start-Sleep -Seconds 3

### Edit this line ###

$tmp = "C:\temp\tmp.txt"

### Edit this line ###

(curl https://raw.githubusercontent.com/securethelogs/WolfHound/master/BadIPs/IPs.txt -UseBasicParsing).content | Out-File $tmp

$badips = @(Get-Content $tmp)

Remove-Item -Path $tmp -Force



$foundips = @()

$connections = @(Get-NetTCPConnection -State Established | Where-Object {$_.LocalAddress -ne "127.0.0.1" -and $_.RemoteAddress -ne "127.0.0.1"})

$currentconnections = @()

$currentconnections += $connections.localaddress
$currentconnections += $connections.remoteaddress


Write-Output ""
Write-Output "--- Network Scan ---"
Write-Output ""

foreach ($cc in $currentconnections){


if (($badips.Contains($cc)) -eq "True"){

 $foundips += $connections | Where-Object {$_.localaddress -eq $cc -or $_.remoteaddress -eq $cc}


 }


}

if ($foundips -ne $null){

Write-Output "--- Matching IPs Found ---"

$foundips | Format-Table

} else {

Write-Output "No Matching IPs Found"

}


} -AsJob -JobName "networkcheck"




Invoke-Command -Session $taskcheck -ScriptBlock {


$logontasks = Get-ScheduledTask | Where-Object {$_.Triggers.CimClass -like "*TaskLogonTrigger*"}

Write-Output ""
Write-Output "--- Suspisious Scheduled Tasks Found ---"

$logontasks |Where-Object {$_.CimInstanceProperties.value.runlevel -eq "Highest" -or $_.CimInstanceProperties.value.userID -like "*system*" -and $_.State -ne "Disabled"} | Format-Table TaskPath, TaskName, State




} -AsJob -JobName "taskcheck"


Invoke-Command -Session $eventcheck -ScriptBlock {

Write-Output ""
Write-Output "--- Failed Logon Events ---"
Write-Output ""
Get-EventLog -LogName Security -InstanceId "4625"


Write-Output ""
Write-Output "-- Bitsadmin Downloaded File Events ---"
Write-Output ""

$bits = Get-WinEvent -LogName Microsoft-Windows-Bits-Client/Operational | Where-Object {$_.id -eq "59" -and $_.message -like "*http*" -and $_.message -like "*started*"}
 
$bits | Where-Object {$_.message -like "*.ps1*" -or $_.message -like "*.bat*" -or $_.message -like "*.exe*" -or $_.message -like "*.vbs*"} | Format-Table

Write-Output ""
Write-Output "-- Suspicious Powershell Events ---"

$ps = Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" | Where-Object {$_.id -eq "4104"}

$ps | Where-Object {$_.message -like "*invoke-command*" -or $_.message -like "*-enc*" -or $_.message -like "*bypass*" -or $_.message -like "*-noin*" -or $_.message -like "*certutil -urlcache*" } | Format-Table


} -AsJob -JobName "eventcheck"



Write-Output ""
Receive-Job -Name "networkcheck" -Wait -Force -AutoRemoveJob

Write-Output ""
Receive-Job -Name "taskcheck" -Wait -Force -AutoRemoveJob

Write-Output ""
Receive-Job -Name "eventcheck" -Wait -Force -AutoRemoveJob

Write-Output ""
Receive-Job -Name "hashcheck" -Wait -Force -AutoRemoveJob


# Cleanup

Get-PSSession -Name "hashcheck" -ErrorAction SilentlyContinue | Remove-PSSession

Get-PSSession -Name "networkcheck" -ErrorAction SilentlyContinue | Remove-PSSession

Get-PSSession -Name "taskcheck" -ErrorAction SilentlyContinue | Remove-PSSession 

Get-PSSession -Name "eventcheck" -ErrorAction SilentlyContinue | Remove-PSSession 



Write-Output ""

$endwinrm = Read-Host -Prompt "Would you like to end WinRm service? (y/n) "

if ($endwinrm -eq "y"){

Get-Service WinRM | Set-Service -Status Stopped

}

