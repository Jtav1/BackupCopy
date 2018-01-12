@echo off
SET Scripts=%~dp0
SET ScriptPath=%Scripts%BackupCopy.ps1
Powershell .\BackupCopy.ps1 -s "C:\Users\User\Desktop\FROM","C:\Users\User\Desktop\FROM2" -d "C:\Users\User\Desktop\TO" -l "C:\Users\User\Desktop\LOG"