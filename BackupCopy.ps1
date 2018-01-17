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

#unzip existing backup, copy over newer files using robocopy, zip it back up
$allZips = Get-ChildItem -Path $dest -filter "*.zip"
$recent = $allZips | Sort-Object LastAccessTime -Descending | Select-Object -First 1 

#If there is an existing backup, unzip it so we can avoid overwriting existing files
if($recent){
    $recentFolderPath = "$($dest)\$($recent.BaseName)"
    zip x "$($recent.FullName)" -o"$dest"
}

#If any of the other zips areolder than 7 days old, delete them
foreach($f in $allZips){
    $today = Get-Date
    if ($f.CreationTime -lt $today.AddDays(-7)){
        Remove-Item $f.FullName
    }
}

#Copy each provided directory
for ($i=0; $i -lt $src.length; $i++){
    robocopy $src[$i] $backDir/ /e /xo    
}

#Move new directory structure into zip
zip a -tzip "$($backDir).zip" $backDir

#Cleanup leftover directories
Remove-Item $backDir -Recurse -Force
if($recent){
    Remove-Item $recentFolderPath -Recurse -Force
}

#Move log file into zip
if ($logging){
    Stop-Transcript
    zip a -tzip "$($logDir).zip" "$($logFile).txt"
    Remove-Item "$($logFile).txt" -Force
}