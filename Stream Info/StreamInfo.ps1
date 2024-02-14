$baseFolder = $PSScriptRoot
$binFolder = Join-Path -Path $baseFolder -ChildPath "bin"

$logFile = Join-Path -Path $baseFolder -ChildPath "log.txt"

$configFile = Join-Path -Path $binFolder -ChildPath "config.json"
$ico = Join-Path -Path $binFolder -ChildPath "twitch.ico"

$catSource = 'https://raw.githubusercontent.com/blushell/TP-Scripts/main/Twitch%20Set%20Info/bin/categories.txt'

$systemLocale = (Get-WinSystemLocale).Name
#####################################################################################################
function Log-Error {
    param ([string]$logMessage = "No error message provided", [string]$logType)
    $formattedError = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - [$logType] $logMessage"
    $formattedError | Out-File -FilePath $logFilePath -Append
    exit     
}

function File-Download {
    param ([string]$url, [string]$filePath)
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $filePath)  
}
#####################################################################################################

$systemLocale = (Get-WinSystemLocale).Name
$filePath = "Twitch%20Set%20Info/languages/$systemLocale.json" # Example: "languages/english.txt"

# GitHub API endpoint to check for file existence
$apiUrl = "https://api.github.com/repos/blushell/TP-Scripts/contents/$filePath"


try {
    $response = Invoke-RestMethod -Uri $apiUrl -Method Get -Headers @{ Accept = "application/vnd.github.v3+json" }

    # If the script reaches this point, it means the request was successful, and the file exists
    Write-Output "The file exists in the GitHub repository."
} catch {
    # If an error occurs during the request, it's caught here, which likely means the file does not exist
    Write-Output "The file does not exist in the GitHub repository."
}



Write-Host "Press any key to exit..."
$key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit
