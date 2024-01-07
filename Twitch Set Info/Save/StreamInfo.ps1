$baseFolder = $PSScriptRoot
$roamingPath = [Environment]::GetFolderPath('ApplicationData')
$binFolder = Join-Path -Path $baseFolder -ChildPath "bin"
$configFile = Join-Path -Path $binFolder -ChildPath "config.json"
$logFilePath = Join-Path -Path $baseFolder -ChildPath "log.txt"
$ico = Join-Path -Path $binFolder -ChildPath "twitch.ico"

$catSource = 'https://raw.githubusercontent.com/blushell/TP-Scripts/main/Twitch%20Set%20Info/bin/categories.txt'


function Log-Error {
    param ([string]$logMessage = "No error message provided", [string]$logType)
    $formattedError = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - [$logType] $logMessage"
    $formattedError | Out-File -FilePath $logFilePath -Append
    exit     
}
#############################################################################
<# BIN CHECK #>
try {
    if (-not (Test-Path -Path $configFile)) {
        $configOptions = [ordered]@{
            "language" = "en-US"
        }
        $configOptions | ConvertTo-Json | Out-File -FilePath $configFile -Force
    }
    if (-not (Test-Path -Path $ico)) {
        $icoUrl = "https://raw.githubusercontent.com/blushell/TP-Scripts/main/Twitch%20Set%20Info/bin/twitch.ico"
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($icoUrl, $ico)
    }
}
catch {
    $errorMessage = $_.Exception.Message
    Log-Error -logMessage $errorMessage -logType "ERROR"
}
$systemLocale = (Get-WinSystemLocale).Name
Write-Host $systemLocale

#############################################################################
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
<# FORM START #>
<# $form = New-Object System.Windows.Forms.Form
$form.Icon = New-Object System.Drawing.Icon $ico
$form.Size = New-Object System.Drawing.Size(440,310)
$form.BackColor = [System.Drawing.Color]::FromArgb(14, 14, 16)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.StartPosition = 'CenterScreen'


# Show the form
$form.ShowDialog() #>


  Write-Host "Press any key to exit..."
  $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  exit
