param (
	[Parameter(Mandatory=$true)][string[]]$src,
	[Parameter(Mandatory=$true)][string]$dest,
	[string]$log = ""
)

#Create a directory to store this backup in called YYYYMonDD-HHMM
$dateStamp  = Get-Date -UFormat "%Y%b%d-%H%m"
$monthStamp = Get-Date -UFormat "%Y%b"
$backDir    = "$($dest)\$($dateStamp)"
$logFile    = "$($log)\$($dateStamp)"
$logDir     = "$($log)\$($monthStamp)"

#If a log filename was provided, transcribe everything into a file in that directory
if ($log.length -gt 0){
    Start-Transcript -path "$($logFile).txt" -append
}

#Alias 7zip
if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe is missing."}
set-alias zip "$env:ProgramFiles\7-Zip\7z.exe"  

New-Item $backDir -type directory

#Copy each provided directory
for ($i=0; $i -lt $src.length; $i++){
    Copy-Item -Path $src[$i] -Destination $backDir -recurse -Force -verbose  
}

#Move new directory structure into zip
zip a -tzip "$($backDir).zip" $backDir
Remove-Item $backDir -Recurse -Force

Stop-Transcript

#Move log file into zip
zip a -tzip "$($logDir).zip" "$($logFile).txt"
Remove-Item "$($logFile).txt" -Force