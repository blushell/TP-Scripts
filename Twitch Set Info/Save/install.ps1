function Exit-Func {
    Write-Host "`nPress any key to exit..."
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

function Write-Title {
    param ( [string]$Title )
    [Console]::Clear()    
    $borderNum = 36
    $titleLength = $Title.Length
    $borderLength = $titleLength + $borderNum
    $border = '=' * $borderLength
    $spaces = ' ' * ($borderNum/2)
    Write-Host $border -ForegroundColor Blue
    Write-Host ($spaces + $Title) -ForegroundColor Blue
    Write-Host "$border" -ForegroundColor Blue
}

function Reverse-Colors{
    $bColor = [System.Console]::BackgroundColor
    $fColor = [System.Console]::ForegroundColor
    [System.Console]::BackgroundColor = $fColor
    [System.Console]::ForegroundColor = $bColor    
}
function Show-Menu {
    param(
        [string]$title,
        [Int32]$menuStart = 0,
        [parameter(Mandatory=$true)][System.Collections.Generic.List[string]]$menuItems
    )

    $invalidChoice = $false
    $selectIndex = 0
    $outChar = 'a'

    [System.Console]::CursorVisible = $false

    while (([System.Int16]$inputChar.Key -ne [System.ConsoleKey]::Enter) -and ([System.Int16]$inputChar.Key -ne [System.ConsoleKey]::Escape)){
        [System.Console]::CursorTop = 4 + $menuStart
        $tempColor = [System.Console]::ForegroundColor
        [System.Console]::ForegroundColor = 'DarkGreen'
        [System.Console]::WriteLine("$title`n")
        [System.Console]::ForegroundColor = $tempColor

        for ($i = 0; $i -lt $menuItems.Count; $i++) {
            [System.Console]::Write("[$i] ")
            if ($selectIndex -eq $i){
                Reverse-Colors
                [System.Console]::WriteLine($menuItems[$i])
                Reverse-Colors      
            }
            else{            
                [System.Console]::WriteLine($menuItems[$i])
            }         
        }

        [System.Console]::WriteLine("`nUse arrows keys or type the number. 'Enter' - Run, 'ESC' - Exit`n")

        if ($invalidChoice){
            [System.Console]::ForegroundColor = 'red'
            [System.Console]::WriteLine("Invalid button! Try again...")
            [System.Console]::ForegroundColor = $tempColor            
        }
        else{
            [System.Console]::Write([System.String]::new(' ',[System.Console]::WindowWidth))
            [System.Console]::SetCursorPosition(0,[System.Console]::CursorTop)
        }
        $invalidChoice = $false

        $inputChar=[System.Console]::ReadKey($true)

        try{
            $number = [System.Int32]::Parse($inputChar.KeyChar)
        }
        catch{
            $number = -1
        }
        
        if ([System.Int16]$inputChar.Key -eq [System.ConsoleKey]::DownArrow){
            if ($selectIndex -lt $menuItems.Count -1){
                $selectIndex++
            }
        }
        elseif ([System.Int16]$inputChar.Key -eq [System.ConsoleKey]::UpArrow){
            if ($selectIndex -gt 0){
                $selectIndex--
            }
        }
        elseif ($number -ge 0 -and $number -lt $menuItems.Count){
            $timestamp = Get-Date       
            while (![System.Console]::KeyAvailable -and ((get-date) - $timestamp).TotalMilliseconds -lt 500){
                Start-Sleep -Milliseconds 250
            }
            if ([System.Console]::KeyAvailable){
                $secondChar = [System.Console]::ReadKey($true).KeyChar
                $fullChar = "$($inputChar.KeyChar)$($secondChar)"
                try{
                    $number = [System.Int32]::Parse($fullChar)
                    if ($number -ge 0 -and $number -lt $menuItems.Count){
                        $selectIndex = $number
                    }
                    else{
                        $invalidChoice = $true
                    }                
                }
                catch{
                    $invalidChoice = $true
                }
            }
            else{
                $selectIndex = $number
            }
        }
        else {
            $invalidChoice = $true
        }
        $outChar = $inputChar
    }

    if ($outChar.Key -eq [System.ConsoleKey]::Enter){
        return $selectIndex
    }
    return -1
}

function Log-Error {
    param ([string]$logMessage = "No error message provided", [string]$logType)
    $formattedError = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - [$logType] $logMessage"
    $formattedError | Out-File -FilePath $logFilePath -Append
    exit     
}
####################################################################################
$baseFolder = $PSScriptRoot
$logFilePath = Join-Path -Path $baseFolder -ChildPath "log.txt"
$roamingPath = [Environment]::GetFolderPath('ApplicationData')
$scriptFolder = Join-Path -Path $roamingPath -ChildPath "TouchPortal\misc\scripts\Stream Info"
####################################################################################

try {
    if (-not (Test-Path -Path $scriptFolder)) {
        New-Item -Path $scriptFolder -ItemType Directory -Force | Out-Null
    }
} catch {
    $errorMessage = $_.Exception.Message
    Log-Error -logMessage $errorMessage -logType "ERROR"
}


Exit-Func;
