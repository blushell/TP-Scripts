$baseFolder = $PSScriptRoot
$binFolder = Join-Path -Path $baseFolder -ChildPath "bin"

$logFile = Join-Path -Path $baseFolder -ChildPath "log.txt"

$configFile = Join-Path -Path $binFolder -ChildPath "config.json"

$iconsBaseUrl = "https://raw.githubusercontent.com/blushell/TP-Scripts/main/Stream%20Info/bin/icons/"
$iconsToDownload = @(
    "twitch.ico",
    "kick.ico",
    "youtube.ico"
)

$catSource = 'https://raw.githubusercontent.com/blushell/TP-Scripts/main/Twitch%20Set%20Info/bin/categories.txt'

$systemLocale = (Get-WinSystemLocale).Name
#####################################################################################################
function Log-Error {
    param (
        [string]$logMessage = "No error message provided", 
        [string]$logType
    )
    $formattedError = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - [$logType] $logMessage"
    $formattedError | Out-File -FilePath $logFile -Append
    exit     
}

function File-Download {
    param (
        [string]$url, 
        [string]$filePath
    )
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $filePath)  
}
#####################################################################################################
<# BIN CHECK #>
try {
    if (-not (Test-Path -Path $binFolder -PathType Container)) {
        New-Item -Path $binFolder -ItemType Directory | Out-Null
        foreach ($icon in $iconsToDownload) {
            $iconUrl = $iconsBaseUrl + $icon
            $iconFilePath = Join-Path -Path $binFolder -ChildPath $icon
            File-Download -url $iconUrl -filePath $iconFilePath
            Write-Host "Downloaded $icon"
        }
    } else {
        Write-Host "Bin folder exists"
    }
} catch {
    $errorMessage = $_.Exception.Message
    Log-Error -logMessage $errorMessage -logType "ERROR"        
}




Write-Host "Press any key to exit..."
$key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit
