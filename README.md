# Backup Copy

BackupCopy is a simple powershell script leveraging 7zip to backup directories to a compressed archive.

This is currently designed specifically for my personal use. 

## Getting Started

BackupCopy.ps1 can be run from PowerShell with the provided -src directory, -dest director, and optional -log directory parameters. The -src parameter can include multiple comma-delimted directory paths. 


### Scheduling

The BackupCopy.bat file can be used with the Windows Task Scheduler to automatically run BackupCopy. Edit the batch file to set the appropriate parameters.

## Features

- Automatically delete backups that are over a certain age
- Incremental backups
- Automatically zips backups and logs
- TBD: Parameter for deletion age for backups

## Author

* **Justin Tavares**