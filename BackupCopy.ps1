param (
	[Parameter(Mandatory=$true)][string[]]$src,
	[Parameter(Mandatory=$true)][string]$dest,
	[string]$log = ""
)

#Create a directory to store this backup named with a timestamp
$dateStamp  = Get-Date -Format "yyyyMMMdd_HH-mm-ss"
$monthStamp = Get-Date -Format "yyyyMMM"
$backDir    = "$($dest)\$($dateStamp)"
$logFile    = "$($log)\$($dateStamp)"
$logDir     = "$($log)\$($monthStamp)"

#If a log filename was provided, transcribe everything into a file in that directory
if ($log.length -gt 0){
    $logging = $true
} else {
    $logging = $false
}

if($logging){
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

#Move log file into zip
if ($logging){
    Stop-Transcript
    zip a -tzip "$($logDir).zip" "$($logFile).txt"
    Remove-Item "$($logFile).txt" -Force
}