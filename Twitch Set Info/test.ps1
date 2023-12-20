$url = "https://raw.githubusercontent.com/blushell/TP-Scripts/main/Twitch%20Set%20Info/bin/categories.txt"

$response = Invoke-WebRequest -Uri $url

if ($response.StatusCode -eq 200) {
    $content = $response.Content -replace '\P{IsBasicLatin}', '' # Remove non-ASCII characters
    Write-Output $content
} else {
    Write-Host "Failed to fetch the content from the URL."
}


# Prompt to press any key to exit
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
