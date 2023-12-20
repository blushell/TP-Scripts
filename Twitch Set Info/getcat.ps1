# Define your Twitch Client ID and API Endpoint
$clientId = "gp762nuuoqcoxypju8c569th9wz7q5"
$accessToken = "fuwemwfxqya1c8b6kaq92sla9n1qu9"  # Replace this with your actual access token
$apiEndpoint = "https://api.twitch.tv/helix/games/top"
$maxCategories = 100  # Maximum number of categories to fetch, adjust as needed

$allCategories = @()  # Array to store all category names

# Set headers for the API request
$headers = @{
    "Client-ID" = $clientId
    "Authorization" = "Bearer $accessToken"
}

# Loop through multiple API requests to paginate through categories
$cursor = $null
do {
    $params = @{
        "first" = $maxCategories
    }
    if ($cursor) {
        $params["after"] = $cursor
    }

    # Make the API call
    $response = Invoke-RestMethod -Uri $apiEndpoint -Headers $headers -Method Get -Body $params

    # Extract category names from the response and add to the array
    $categoryNames = $response.data.name
    $allCategories += $categoryNames

    # Update the cursor for the next page, if available
    $cursor = $response.pagination.cursor
} while ($cursor)

# Save all category names to a text file
$allCategories | Out-File -FilePath "TwitchCategories.txt"

Write-Host "All categories retrieved and saved to TwitchCategories.txt"

# Prompt to press any key to exit
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
