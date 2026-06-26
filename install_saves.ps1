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

# 1. Locate the Tabletop Simulator Saves directory
$userProfile = $env:USERPROFILE
$possiblePaths = @(
    (Join-Path $userProfile "Documents\My Games\Tabletop Simulator\Saves"),
    (Join-Path $userProfile "OneDrive\Documents\My Games\Tabletop Simulator\Saves")
)

$targetSavesPath = $null
foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $targetSavesPath = $path
        break
    }
}

if (-not $targetSavesPath) {
    Write-Error "Could not find your Tabletop Simulator Saves directory."
    Write-Host "Please ensure Tabletop Simulator is installed and you have created at least one save game." -ForegroundColor Yellow
    exit 1
}

Write-Host "Found Tabletop Simulator Saves folder at:" -ForegroundColor Green
Write-Host " -> $targetSavesPath" -ForegroundColor DarkGreen
Write-Host ""

# 2. Function to scan saves and get the next available number
function Get-NextSaveIndex($path) {
    $saveFiles = Get-ChildItem -Path $path -Filter "TS_Save_*.json"
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
}

# 3. Define the zip files to process
$zipFiles = @(
    @{ Name = "ForceOrg Utilities"; ZipPath = "ForceOrg.zip" },
    @{ Name = "Hutber Base Map"; ZipPath = "Hutber.zip" },
    @{ Name = "LTC Base Table"; ZipPath = "LTC_Table.zip" }
)

# Create a temporary extraction folder
$tempDir = Join-Path $PSScriptRoot "temp_extraction"
if (Test-Path $tempDir) {
    Remove-Item -Path $tempDir -Recurse -Force
}

$successCount = 0

foreach ($item in $zipFiles) {
    $zipFullPath = Join-Path $PSScriptRoot $item.ZipPath
    if (-not (Test-Path $zipFullPath)) {
        Write-Host "[-] Skipping $($item.Name) ($($item.ZipPath) not found)." -ForegroundColor Yellow
        continue
    }

    Write-Host "Processing $($item.Name)..." -ForegroundColor Cyan
    
    # Extract ZIP
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    Expand-Archive -Path $zipFullPath -DestinationPath $tempDir -Force

    # Find the JSON and PNG files recursively in temp folder
    $jsonFile = Get-ChildItem -Path $tempDir -Filter "*.json" -Recurse | Select-Object -First 1
    $pngFile = Get-ChildItem -Path $tempDir -Filter "*.png" -Recurse | Select-Object -First 1

    if ($jsonFile -and $pngFile) {
        # Determine the next available save index dynamically
        $nextIndex = Get-NextSaveIndex $targetSavesPath
        
        $newJsonName = "TS_Save_$nextIndex.json"
        $newPngName = "TS_Save_$nextIndex.png"

        $destJsonPath = Join-Path $targetSavesPath $newJsonName
        $destPngPath = Join-Path $targetSavesPath $newPngName

        # Copy files to the target Saves folder
        Copy-Item -Path $jsonFile.FullName -Destination $destJsonPath -Force
        Copy-Item -Path $pngFile.FullName -Destination $destPngPath -Force

        Write-Host "[+] Installed as Save #$nextIndex ($newJsonName)" -ForegroundColor Green
        $successCount++
    } else {
        Write-Host "[!] Error: Could not find required .json and .png files in $($item.ZipPath)" -ForegroundColor Red
    }

    # Clean up temp folder
    Remove-Item -Path $tempDir -Recurse -Force
}

# Final summary
Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
if ($successCount -gt 0) {
    Write-Host "  Successfully installed $successCount tables!  " -ForegroundColor Green
    Write-Host "  Open TTS -> Create -> Games -> Save & Load  " -ForegroundColor Green
} else {
    Write-Host "  No tables were installed.                  " -ForegroundColor Yellow
}
Write-Host "=============================================" -ForegroundColor Cyan
