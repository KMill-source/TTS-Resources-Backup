#!/bin/bash
# install_saves.sh
# Tabletop Simulator Save Installer for 40k Resources Backup (macOS & Linux)
#
# This script automates the installation of the backed-up 40k table saves.

# Color definitions
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}=============================================${NC}"
echo -e "${CYAN}  Warhammer 40k TTS Save Files Installer     ${NC}"
echo -e "${CYAN}=============================================${NC}"

# Resolve script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "$SCRIPT_DIR" ] || [ ! -d "$SCRIPT_DIR" ]; then
    echo -e "${RED}Error: Could not determine the script's directory.${NC}"
    read -p "Press Enter to close this window..."
    exit 1
fi

echo -e "Script directory: $SCRIPT_DIR"

# 1. Locate the Tabletop Simulator Saves directory
POSSIBLE_PATHS=(
    "$HOME/Library/Tabletop Simulator/Saves"
    "$HOME/.local/share/Tabletop Simulator/Saves"
    "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Tabletop Simulator/Saves"
)

TARGET_SAVES_PATH=""
for path in "${POSSIBLE_PATHS[@]}"; do
    if [ -d "$path" ]; then
        TARGET_SAVES_PATH="$path"
        break
    fi
done

# Prompt user manually if auto-detection failed
if [ -z "$TARGET_SAVES_PATH" ]; then
    echo -e "${YELLOW}Warning: Could not automatically locate your Tabletop Simulator Saves directory.${NC}"
    echo -e "Please enter the path to your Tabletop Simulator Saves folder manually."
    echo -e "Example: /home/user/.local/share/Tabletop Simulator/Saves"
    read -p "Saves Folder Path: " USER_INPUT
    
    # Expand tilde (~) manually to $HOME
    USER_INPUT="${USER_INPUT/#\~/$HOME}"
    
    if [ -d "$USER_INPUT" ]; then
        TARGET_SAVES_PATH="$USER_INPUT"
    else
        echo -e "${RED}Error: The entered path does not exist or is not a directory.${NC}"
        echo "Aborting installation."
        read -p "Press Enter to close this window..."
        exit 1
    fi
fi

echo -e "${GREEN}Found Tabletop Simulator Saves folder at:${NC}"
echo -e " -> $TARGET_SAVES_PATH"
echo ""

# 2. Check if unzip utility exists
if ! command -v unzip &> /dev/null; then
    echo -e "${RED}Error: 'unzip' utility is not installed on this system.${NC}"
    echo "Please install 'unzip' using your package manager and try again."
    echo "Example (Ubuntu/Debian): sudo apt install unzip"
    echo "Example (macOS): brew install unzip"
    read -p "Press Enter to close this window..."
    exit 1
fi

# 3. Scan saves once to find starting index
get_starting_save_index() {
    local dir="$1"
    local max_index=0
    
    for file in "$dir"/TS_Save_*.json; do
        [ -e "$file" ] || continue
        local filename=$(basename "$file")
        if [[ "$filename" =~ ^TS_Save_([0-9]+)\.json$ ]]; then
            local index="${BASH_REMATCH[1]}"
            # Strip leading zeros to prevent octal numbers evaluation
            index=$((10#$index))
            if (( index > max_index )); then
                max_index=$index
            fi
        fi
    done
    echo $((max_index + 1))
}

NEXT_INDEX=$(get_starting_save_index "$TARGET_SAVES_PATH")
echo "Next available save index: #$NEXT_INDEX"
echo ""

# 4. Define the zip files to process
ZIP_FILES=(
    "ForceOrg.zip|ForceOrg Utilities"
    "Hutber.zip|Hutber Base Map"
    "LTC_Table.zip|LTC Base Table"
)

TEMP_DIR="$SCRIPT_DIR/temp_extraction"
if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

SUCCESS_COUNT=0

for item in "${ZIP_FILES[@]}"; do
    IFS="|" read -r zip_path name <<< "$item"
    ZIP_FULL_PATH="$SCRIPT_DIR/$zip_path"
    
    if [ ! -f "$ZIP_FULL_PATH" ]; then
        echo -e "${YELLOW}Warning: Could not find '$zip_path' in the script directory. Skipping '$name'.${NC}"
        continue
    fi
    
    echo -e "${CYAN}Processing $name...${NC}"
    
    # Extract zip into temp folder
    mkdir -p "$TEMP_DIR"
    if ! unzip -q -o "$ZIP_FULL_PATH" -d "$TEMP_DIR"; then
        echo -e "${RED}Warning: Failed to extract ZIP archive '$zip_path'. Skipping '$name'.${NC}"
        rm -rf "$TEMP_DIR"
        continue
    fi
    
    # Find JSON and PNG recursively
    JSON_FILE=$(find "$TEMP_DIR" -type f -name "*.json" | head -n 1)
    PNG_FILE=$(find "$TEMP_DIR" -type f -name "*.png" | head -n 1)
    
    if [ -z "$JSON_FILE" ] || [ -z "$PNG_FILE" ]; then
        echo -e "${RED}Warning: Missing save files inside '$zip_path'. Skipping '$name'.${NC}"
        rm -rf "$TEMP_DIR"
        continue
    fi
    
    # Build destination paths
    NEW_JSON_NAME="TS_Save_$NEXT_INDEX.json"
    NEW_PNG_NAME="TS_Save_$NEXT_INDEX.png"
    DEST_JSON_PATH="$TARGET_SAVES_PATH/$NEW_JSON_NAME"
    DEST_PNG_PATH="$TARGET_SAVES_PATH/$NEW_PNG_NAME"
    
    # Check for collision
    if [ -f "$DEST_JSON_PATH" ]; then
        echo -e "${RED}Warning: Save slot #$NEXT_INDEX is already occupied. Skipping '$name' to prevent overwriting.${NC}"
        rm -rf "$TEMP_DIR"
        continue
    fi
    
    # Copy
    if cp "$JSON_FILE" "$DEST_JSON_PATH" && cp "$PNG_FILE" "$DEST_PNG_PATH"; then
        echo -e "${GREEN}[+] '$name' installed as Save #$NEXT_INDEX ($NEW_JSON_NAME)${NC}"
        NEXT_INDEX=$((NEXT_INDEX + 1))
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        echo -e "${RED}Warning: Failed to copy saves for '$name'. Check directory permissions.${NC}"
    fi
    
    # Clean temp dir
    rm -rf "$TEMP_DIR"
done

# Final Summary
echo ""
echo -e "${CYAN}=============================================${NC}"
TOTAL_ZIPS=${#ZIP_FILES[@]}
if [ "$SUCCESS_COUNT" -eq "$TOTAL_ZIPS" ]; then
    echo -e "${GREEN}  All tables ($SUCCESS_COUNT/$TOTAL_ZIPS) successfully installed!  ${NC}"
    echo -e "${GREEN}  Launch TTS -> Create -> Games -> Save & Load  ${NC}"
elif [ "$SUCCESS_COUNT" -gt 0 ]; then
    echo -e "${YELLOW}  Partial success: $SUCCESS_COUNT/$TOTAL_ZIPS tables installed.  ${NC}"
    echo -e "${YELLOW}  Review the warnings above for details. ${NC}"
else
    echo -e "${RED}  No tables were installed. Check warnings above.  ${NC}"
fi
echo -e "${CYAN}=============================================${NC}"
echo ""

read -p "Press Enter to close this window..."
