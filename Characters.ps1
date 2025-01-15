$desktopPath = [Environment]::GetFolderPath('Desktop')
New-Item -ItemType Directory -Path "$desktopPath\UsnJournal" | Out-Null
Write-Host "Scanning USN-Journal..."
$ntfsDisks = Get-WmiObject Win32_LogicalDisk | Where-Object {$_.FileSystem -eq "NTFS"} | Select-Object DeviceID
foreach ($disk in $ntfsDisks) {
    $driveLetter = $disk.DeviceID.ToLower()
    $journal = fsutil usn readjournal $driveLetter csv
    $journal | Select-String -Pattern "\?" | Out-File -FilePath "$desktopPath\UsnJournal\UnicodeAndInvisibleCharacters.txt"
}
explorer.exe $desktopPath\Characters