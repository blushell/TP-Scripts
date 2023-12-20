$baseFolder = $PSScriptRoot
$binFolder = Join-Path -Path $baseFolder -ChildPath "bin"
$configFile = Join-Path -Path $binFolder -ChildPath "config.json"
$ico = Join-Path -Path $binFolder -ChildPath "twitch.ico"

$catSource = 'https://raw.githubusercontent.com/blushell/TP-Scripts/main/Twitch%20Set%20Info/bin/categories.txt'

<# CONFIG SETUP #>
try {
    if (-not (Test-Path $configFile)) {
        $configOptions = [ordered]@{       
            "language" = "en"
        }
        $configOptions | ConvertTo-Json | Out-File -FilePath $configFile -Force
    }  
} catch {
    $errorMessage = $_.Exception.Message
    Log-Error -logMessage $errorMessage -logType "ERROR"
}

#############################################################################

try {
    # Check if config file exists
    if (-not (Test-Path -Path $configFile)) {
        $configOptions = [ordered]@{
            "language" = "en"
        }
        $configOptions | ConvertTo-Json | Out-File -FilePath $configFile -Force
    }

    # Check if ICO file exists
    if (-not (Test-Path -Path $ico)) {
        # Download ICO file from URL if it's missing
        # Replace 'YOUR_ICO_URL_HERE' with the actual URL of the ICO file
        $icoUrl = "YOUR_ICO_URL_HERE"
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($icoUrl, $ico)
    }
}
catch {
    Write-Host "Error occurred: $_.Exception.Message"
    # Handle specific error cases if needed
}

