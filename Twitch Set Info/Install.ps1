$baseFolder = $PSScriptRoot
$roamingPath = [Environment]::GetFolderPath('ApplicationData')
$touchPortal = Join-Path -Path $roamingPath -ChildPath "TouchPortal"

Write-Host $touchPortal



Write-Host "Press any key to exit..."
$key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit
