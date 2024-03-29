$baseFolder = $PSScriptRoot
$binFolder = Join-Path -Path $baseFolder -ChildPath "bin"
$logFilePath = Join-Path -Path $baseFolder -ChildPath "log.txt"
$configFile = Join-Path -Path $binFolder -ChildPath "config.json"
$ico = Join-Path -Path $binFolder -ChildPath "twitch.ico"

$catSource = 'https://raw.githubusercontent.com/blushell/TP-Scripts/main/Twitch%20Set%20Info/bin/categories.txt'

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
<# BIN CHECK #>
try {
    if (-not (Test-Path -Path $ico)) {
        $icoUrl = "https://raw.githubusercontent.com/blushell/TP-Scripts/main/Twitch%20Set%20Info/bin/twitch.ico"
        File-Download -url $icoUrl -filePath $ico
    }   
} catch {
    $errorMessage = $_.Exception.Message
    Log-Error -logMessage $errorMessage -logType "ERROR"    
}

<# $systemLocale = (Get-WinSystemLocale).Name
Write-Host $systemLocale #>


# Define the GitHub API URL for the specific file
# Replace 'owner', 'repo', and 'filepath' with the actual repository owner, repository name, and file path within the repository
$owner = "blushell"
$repo = "TP-Scripts"
$filePath = "languages/yourFileName.extension" # Example: "languages/english.txt"

# GitHub API endpoint to check for file existence
$apiUrl = "https://api.github.com/repos/$owner/$repo/contents/$filePath"

# Perform the API request
$response = Invoke-RestMethod -Uri $apiUrl -Method Get -Headers @{ Accept = "application/vnd.github.v3+json" }

if ($response) {
    Write-Output "The file exists in the GitHub repository."
} else {
    Write-Output "The file does not exist in the GitHub repository."
}


#####################################################################################################
Write-Host "Press any key to exit..."
$key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit
