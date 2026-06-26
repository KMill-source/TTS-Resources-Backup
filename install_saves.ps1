# install_saves.ps1
# Tabletop Simulator Save Installer for 40k Resources Backup
#
# This script automates the installation of the backed-up 40k table saves.
# It automatically:
# 1. Finds your Tabletop Simulator Saves folder (supporting standard & OneDrive paths).
# 2. Scans your current saves to find the next available save number.
# 3. Extracts and renames the backups to prevent overwriting your existing saves.
# 4. Installs the saves directly into your game's directory.

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Warhammer 40k TTS Save Files Installer     " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# Fix #3: Resolve script root reliably regardless of how the script is launched
# $PSScriptRoot can be empty when using "Right-click > Run with PowerShell"
$scriptRoot = if ($PSScriptRoot -and $PSScriptRoot -ne "") {
    $PSScriptRoot
} else {
    Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
}

if (-not $scriptRoot -or -not (Test-Path $scriptRoot)) {
    Write-Warning "Could not determine the script's directory. Please run this script from within its folder."
    Write-Host "Tip: Open PowerShell, navigate to the script's folder with 'cd', then run '.\install_saves.ps1'" -ForegroundColor Yellow
    exit 1
}

Write-Host "Script directory: $scriptRoot" -ForegroundColor DarkGray

# 1. Check for USERPROFILE/HOME environment variable
$userProfile = $env:USERPROFILE
if (-not $userProfile) {
    Write-Warning "USERPROFILE environment variable is not defined on this system."
    Write-Host "Attempting to use the HOME directory instead..." -ForegroundColor Yellow
    $userProfile = $env:HOME
}

if (-not $userProfile -or -not (Test-Path $userProfile)) {
    Write-Warning "Could not determine your user profile directory (USERPROFILE or HOME is missing/invalid)."
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
    Write-Warning "Could not find your Tabletop Simulator Saves directory."
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

# 3. Scan saves once and track next index in-memory to avoid collisions across installs
# Fix #1: Scan disk once, then increment an in-memory counter per successful install
function Get-StartingSaveIndex($path) {
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

# Scan disk ONCE before the loop, then increment in-memory
$nextIndex = Get-StartingSaveIndex $targetSavesPath
Write-Host "Next available save index: #$nextIndex" -ForegroundColor DarkGray
Write-Host ""

# 4. Define the zip files to process
$zipFiles = @(
    @{ Name = "ForceOrg Utilities"; ZipPath = "ForceOrg.zip" },
    @{ Name = "Hutber Base Map";    ZipPath = "Hutber.zip" },
    @{ Name = "LTC Base Table";     ZipPath = "LTC_Table.zip" }
)

# Temporary extraction folder
$tempDir = Join-Path $scriptRoot "temp_extraction"
try {
    if (Test-Path $tempDir) {
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
} catch {
    Write-Warning "Could not clear pre-existing temporary folder '$tempDir': $_"
}

$successCount = 0

foreach ($item in $zipFiles) {
    $zipFullPath = Join-Path $scriptRoot $item.ZipPath

    if (-not (Test-Path $zipFullPath)) {
        Write-Warning "Could not find '$($item.ZipPath)' in the script directory ($scriptRoot). Skipping '$($item.Name)'."
        continue
    }

    Write-Host "Processing $($item.Name)..." -ForegroundColor Cyan

    try {
        # Extract ZIP into temp folder
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

        try {
            Expand-Archive -Path $zipFullPath -DestinationPath $tempDir -Force -ErrorAction Stop
        } catch {
            throw "Failed to extract ZIP archive '$($item.ZipPath)'. The file may be corrupt: $_"
        }

        # Find the JSON and PNG files recursively inside the extracted folder
        $jsonFile = Get-ChildItem -Path $tempDir -Filter "*.json" -Recurse -ErrorAction Stop | Select-Object -First 1
        $pngFile  = Get-ChildItem -Path $tempDir -Filter "*.png"  -Recurse -ErrorAction Stop | Select-Object -First 1

        if (-not $jsonFile) {
            throw "No .json save file found inside '$($item.ZipPath)'. The archive may be incomplete."
        }
        if (-not $pngFile) {
            throw "No .png preview image found inside '$($item.ZipPath)'. The archive may be incomplete."
        }

        # Build destination paths using the in-memory counter (Fix #1)
        $newJsonName  = "TS_Save_$nextIndex.json"
        $newPngName   = "TS_Save_$nextIndex.png"
        $destJsonPath = Join-Path $targetSavesPath $newJsonName
        $destPngPath  = Join-Path $targetSavesPath $newPngName

        # Safety check: warn if something already exists at that path
        if (Test-Path $destJsonPath) {
            throw "Save slot #$nextIndex is already occupied ('$newJsonName' exists). Aborting to prevent overwrite. Please report this as a bug."
        }

        # Copy files
        try {
            Copy-Item -Path $jsonFile.FullName -Destination $destJsonPath -Force -ErrorAction Stop
            Copy-Item -Path $pngFile.FullName  -Destination $destPngPath  -Force -ErrorAction Stop
        } catch {
            throw "Failed to copy files to Tabletop Simulator Saves directory. Is TTS currently open? Try closing it first. Error: $_"
        }

        Write-Host "[+] '$($item.Name)' installed as Save #$nextIndex ($newJsonName)" -ForegroundColor Green

        # Increment in-memory counter ONLY after a successful install
        $nextIndex++
        $successCount++

    } catch {
        Write-Warning "Skipping '$($item.Name)': $_"
    } finally {
        # Always clean up temp folder
        try {
            if (Test-Path $tempDir) {
                Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
            }
        } catch {
            Write-Warning "Could not clean up temporary folder '$tempDir'. You may delete it manually."
        }
    }
}

# Final summary
Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
if ($successCount -eq $zipFiles.Count) {
    Write-Host "  All tables ($successCount/$($zipFiles.Count)) successfully installed!  " -ForegroundColor Green
    Write-Host "  Launch TTS -> Create -> Games -> Save & Load  " -ForegroundColor Green
} elseif ($successCount -gt 0) {
    Write-Host "  Partial success: $successCount/$($zipFiles.Count) tables installed.  " -ForegroundColor Yellow
    Write-Host "  Review the warnings above for details on failures. " -ForegroundColor Yellow
} else {
    Write-Host "  No tables were installed. Check warnings above.  " -ForegroundColor Red
}
Write-Host "=============================================" -ForegroundColor Cyan
