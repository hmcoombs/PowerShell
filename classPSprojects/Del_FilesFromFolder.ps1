#Delete files from a folder.
#Modified below to this = worked in vm lab
$Path = "C:\Users\Administrator.ADATUM\Downloads" #Change to path needed
$Daysback = "-2" #change to how many days to go back
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)

#Object containing all the log files we want to delete
$logfiles = Get-ChildItem -Path $Path -Recurse | Where-Object { $_.LastWriteTime -lt $DatetoDelete }

$msg = $($logFiles.Fullname) -join "`n" #separate lines for the string
       
        Write-Host "Deleting old files..."
        Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item
        Write-host "$($logFiles.count) Files Deleted"

#make script to run once a month??  I think you have to do that in the scheduler ... Just saw the comment below hahaha maybe remove line 17 (Rob)
#To run on a schedule use task scheduler, specify path were you saved .ps1 file

#or could try the following.  Have not tried to run. Just a note
#if line 22 and 23 are no longer needed I would recommend deleting (Rob)
#$taskTrigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 3am
#Register-ScheduledTask -TaskName "MyScheduledTask" -Trigger $taskTrigger -Action { powershell.exe -NoLogo -WindowStyle Hidden -File "C:\Path\To\Your\Script.ps1" }

#set variable values for scirpt 
$Path = "C:\TEMP\junk"
$Daysback = "-30"
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)

#Object containing all the log files we want to delete
$logfiles = Get-ChildItem -Path $Path -Recurse | Where-Object { $_.LastWriteTime -lt $DatetoDelete }

#if the custom eventlog source does not exist, create it.
if(!($([System.Diagnostics.EventLog]::SourceExists('DevOps'))))
  { 
    Write-Host "Adding eventlog source 'DevOps'" -ForegroundColor Red
    New-EventLog –LogName Application –Source “DevOps”
  } ELSE {Write-Host "DevOps Source already exists" -ForegroundColor green}

$msg = $($logFiles.Fullname) -join "`n" #separate lines for the string
Write-EventLog -LogName "Application" -Source "DevOps" -EventID 1313 -EntryType Information -Message "$($logfiles.count) files deleted from $path on $CurrentDate `n $msg"
Write-Host "Deleting old files..."
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item
Write-host "$($logFiles.count) Files Deleted"


