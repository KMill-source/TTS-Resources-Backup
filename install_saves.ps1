# install_saves.ps1
# Tabletop Simulator Save Installer for 40k Resources Backup
#
# This script automates the installation of the backed-up 40k table saves.
# It automatically:
# 1. Finds your Tabletop Simulator Saves folder (supporting standard & OneDrive paths).
# 2. Scans your current saves to find the next available save number.
# 3. Extracts and renames the backups to prevent overwriting your existing saves.
# 4. Installs the saves directly into your game's directory.

$ErrorActionPreference = "Stop"

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Warhammer 40k TTS Save Files Installer     " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# 1. Check for USERPROFILE/HOME environment variable
$userProfile = $env:USERPROFILE
if (-not $userProfile) {
    Write-Warning "USERPROFILE environment variable is not defined on this system."
    Write-Host "Attempting to use the HOME directory instead..." -ForegroundColor Yellow
    $userProfile = $env:HOME
}

if (-not $userProfile -or -not (Test-Path $userProfile)) {
    Write-Error "Could not determine your user profile directory (USERPROFILE or HOME is missing/invalid)."
    Write-Host "Please ensure you run this script with proper user privileges." -ForegroundColor Red
    exit 1
}

# 2. Locate the Tabletop Simulator Saves directory
$possiblePaths = @(
    (Join-Path $userProfile "Documents\My Games\Tabletop Simulator\Saves"),
    (Join-Path $userProfile "OneDrive\Documents\My Games\Tabletop Simulator\Saves")
)

$targetSavesPath = $null
foreach ($path in $possiblePaths) {
    try {
        if (Test-Path $path) {
            $targetSavesPath = $path
            break
        }
    } catch {
        Write-Warning "Error checking path '$path': $_"
    }
}

if (-not $targetSavesPath) {
    Write-Error "Could not find your Tabletop Simulator Saves directory."
    Write-Host "Checked locations:" -ForegroundColor Yellow
    foreach ($path in $possiblePaths) {
        Write-Host " - $path" -ForegroundColor Yellow
    }
    Write-Host "`nPlease ensure Tabletop Simulator is installed and you have created/saved at least one game in-game to initialize the directory." -ForegroundColor Yellow
    exit 1
}

Write-Host "Found Tabletop Simulator Saves folder at:" -ForegroundColor Green
Write-Host " -> $targetSavesPath" -ForegroundColor DarkGreen
Write-Host ""

# 3. Function to scan saves and get the next available number
function Get-NextSaveIndex($path) {
    try {
        $saveFiles = Get-ChildItem -Path $path -Filter "TS_Save_*.json" -ErrorAction Stop
        $maxIndex = 0
        foreach ($file in $saveFiles) {
            if ($file.BaseName -match '^TS_Save_(\d+)$') {
                $index = [int]$matches[1]
                if ($index -gt $maxIndex) {
                    $maxIndex = $index
                }
            }
        }
        return $maxIndex + 1
    } catch {
        Write-Warning "Failed to scan existing save files in '$path': $_"
        Write-Host "Defaulting to save index #1." -ForegroundColor Yellow
        return 1
    }
}

# 4. Define the zip files to process
$zipFiles = @(
    @{ Name = "ForceOrg Utilities"; ZipPath = "ForceOrg.zip" },
    @{ Name = "Hutber Base Map"; ZipPath = "Hutber.zip" },
    @{ Name = "LTC Base Table"; ZipPath = "LTC_Table.zip" }
)

# Create a temporary extraction folder
$tempDir = Join-Path $PSScriptRoot "temp_extraction"
try {
    if (Test-Path $tempDir) {
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
} catch {
    Write-Warning "Could not clear pre-existing temporary folder '$tempDir': $_"
}

$successCount = 0

foreach ($item in $zipFiles) {
    $zipFullPath = Join-Path $PSScriptRoot $item.ZipPath
    if (-not (Test-Path $zipFullPath)) {
        Write-Warning "Could not find $($item.ZipPath) in the current directory ($PSScriptRoot). Skipping this table."
        continue
    }

    Write-Host "Processing $($item.Name)..." -ForegroundColor Cyan
    
    try {
        # Extract ZIP
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        
        try {
            Expand-Archive -Path $zipFullPath -DestinationPath $tempDir -Force -ErrorAction Stop
        } catch {
            throw "Failed to extract ZIP archive '$($item.ZipPath)': $_"
        }

        # Find the JSON and PNG files recursively in temp folder
        $jsonFile = Get-ChildItem -Path $tempDir -Filter "*.json" -Recurse | Select-Object -First 1
        $pngFile = Get-ChildItem -Path $tempDir -Filter "*.png" -Recurse | Select-Object -First 1

        if (-not $jsonFile -or -not $pngFile) {
            throw "The ZIP archive did not contain both a .json save file and a matching .png image file."
        }

        # Determine the next available save index dynamically
        $nextIndex = Get-NextSaveIndex $targetSavesPath
        
        $newJsonName = "TS_Save_$nextIndex.json"
        $newPngName = "TS_Save_$nextIndex.png"

        $destJsonPath = Join-Path $targetSavesPath $newJsonName
        $destPngPath = Join-Path $targetSavesPath $newPngName

        # Copy files to the target Saves folder
        try {
            Copy-Item -Path $jsonFile.FullName -Destination $destJsonPath -Force -ErrorAction Stop
            Copy-Item -Path $pngFile.FullName -Destination $destPngPath -Force -ErrorAction Stop
        } catch {
            throw "Failed to copy files to Tabletop Simulator Saves directory: $_"
        }

        Write-Host "[+] Installed successfully as Save #$nextIndex ($newJsonName)" -ForegroundColor Green
        $successCount++

    } catch {
        Write-Warning "Failed to install $($item.Name): $_"
    } finally {
        # Clean up temp folder
        try {
            if (Test-Path $tempDir) {
                Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
            }
        } catch {
            Write-Warning "Could not clean up temporary folder '$tempDir': $_"
        }
    }
}

# Final summary
Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
if ($successCount -eq $zipFiles.Count) {
    Write-Host "  All tables ($successCount/$($zipFiles.Count)) successfully installed!  " -ForegroundColor Green
    Write-Host "  Open TTS -> Create -> Games -> Save & Load  " -ForegroundColor Green
} elseif ($successCount -gt 0) {
    Write-Host "  Partially completed: $successCount/$($zipFiles.Count) tables installed. " -ForegroundColor Yellow
    Write-Host "  Please review the warnings above for failures.   " -ForegroundColor Yellow
} else {
    Write-Host "  No tables were installed.                  " -ForegroundColor Red
}
Write-Host "=============================================" -ForegroundColor Cyan
