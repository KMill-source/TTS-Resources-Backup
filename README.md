# 40k Tabletop Simulator Resources Backup

A public, free backup repository containing pre-configured Warhammer 40,000 map and base saves for Tabletop Simulator (TTS).

---

## ⚠️ Important Disclaimer & Community Credits
This repository is provided purely as a **free community service backup location** to ensure that players can access essential table setups should main hosting services or workshop files ever experience downtime.
*   **Ownership:** The creator of this repository **does not own** any of the assets, models, maps, or code contained in these files.
*   **No Monetization:** This project is 100% free. The repository creator makes no money from this project.
*   **Credits:** All content, designs, scripts, and tables are created, updated, and supported by the outstanding developers and community members of:
    *   **LTC (League of Tactical Commanders)**
    *   **Hutber (Hutber 40k Competitive Maps)**
    *   **ForceOrg Team** (Special thanks to **Raikoh** for creating and maintaining the official [ForceOrg Downloader](https://gitlab.com/forceorg1/ForceOrg-Downloader))
    Please support these creators directly on Steam Workshop and their respective community Discord servers.

---

## 📦 What's Inside?
This backup contains saves for three major 40k table and utility frameworks:
1.  **LTC Table (`LTC_Table.zip`):** The standard map layout and base setup maintained by the LTC community.
2.  **Hutber Base (`Hutber.zip`):** Highly optimized competitive tournament map layout.
3.  **ForceOrg Backup (`ForceOrg.zip`):** The essential utility and scripting tool used to manage model bases, army scaling, rules binding, and more.

---

## 🛡️ Security & File Verification

To ensure that these backup files are safe and have not been modified, we provide the SHA-256 hashes for the core `.json` Tabletop Simulator save files and the installer scripts, along with direct scan report links on **VirusTotal**.

### 🔍 File Hashes & VirusTotal Reports

| File Name | SHA-256 Hash | VirusTotal Scan Report |
| :--- | :--- | :--- |
| **`install_saves.ps1`** | `f221861b3e8532e06a5a234a33f03af19eef1852aca2e27a8905e0ea359f0e6a` | [View Report](https://www.virustotal.com/gui/file/f221861b3e8532e06a5a234a33f03af19eef1852aca2e27a8905e0ea359f0e6a) |
| **`install_saves.sh`** | `77d22b7dbdf22b435f6dd4ae245130a0dce55936529e9fd7e2a2e4b8e47b3daf` | [View Report](https://www.virustotal.com/gui/file/77d22b7dbdf22b435f6dd4ae245130a0dce55936529e9fd7e2a2e4b8e47b3daf) |
| **`ForceOrg/TS_Save_1.json`** | `c0aab17f21be471312fab9e6afeffcce69b3f04dd65ee4998eb47910d3089563` | [View Report](https://www.virustotal.com/gui/file/c0aab17f21be471312fab9e6afeffcce69b3f04dd65ee4998eb47910d3089563) |
| **`Hutber/TS_Save_1.json`** | `f62515a844feae20dd4f37e4f3b5f1e37660d9fe59e194920502af5c7e0d755b` | [View Report](https://www.virustotal.com/gui/file/f62515a844feae20dd4f37e4f3b5f1e37660d9fe59e194920502af5c7e0d755b) |
| **`LTC_Table/TS_Save_1.json`** | `596a879c99219315e4604f521112dd807c9a68f89fa966ee642f45e082606504` | [View Report](https://www.virustotal.com/gui/file/596a879c99219315e4604f521112dd807c9a68f89fa966ee642f45e082606504) |

> [!TIP]
> If a file has not been analyzed by VirusTotal yet when you click the link, you can upload the file directly to [VirusTotal](https://www.virustotal.com/) to trigger a fresh scan. Since these are plain text JSON files and open-source installer scripts, they will scan clean.

### 🖥️ How to Verify Hashes Locally

You can check the hash of any file you download to confirm it matches the hashes listed above:

#### Windows (PowerShell):
```powershell
Get-FileHash -Path "C:\path\to\downloaded-file" -Algorithm SHA256
```

#### macOS / Linux (Terminal):
```bash
shasum -a 256 /path/to/downloaded-file
```

---

## 🚀 Installation Guide

Choose either the automated script method (easiest) or the manual method.

---

### Method 1: Automated Script (Recommended)

This repository includes installer scripts that automate the entire setup:
1. Locate your Tabletop Simulator Saves folder.
2. Scan your current saves to find the next available save number.
3. Extract, rename, and install the save files directly into your game's directory so they do not conflict with or overwrite any of your current saves.

#### For Windows:
1. Click the green **Code** button at the top-right of this page and select **Download ZIP** (or download the files to your PC).
2. Extract the downloaded ZIP file.
3. Right-click the `install_saves.ps1` file and select **Run with PowerShell**.
   * *Alternatively*, open a PowerShell window in the folder and run:
     ```powershell
     Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
     .\install_saves.ps1
     ```
4. The script will output a success message showing which save numbers the tables were imported as.

#### For macOS & Linux / Steam Deck:
1. Open your Terminal and navigate to the extracted repository folder.
2. Make the script executable and run it:
   ```bash
   chmod +x install_saves.sh
   ./install_saves.sh
   ```
3. The script will output a success message showing which save numbers the tables were imported as.

---

### Method 2: Manual Installation (macOS, Linux, or Custom)

#### Step 1: Download the Backups
You can download the save folders in one of two ways:
*   **Option A (Recommended):** Click on any of the `.zip` files in the file list above (e.g., `LTC_Table.zip`), click the **Download** button on GitHub, and save it to your computer.
*   **Option B (All Saves):** Click the green **Code** button at the top-right of this page and select **Download ZIP** to download all backups at once.

#### Step 2: Copy to Tabletop Simulator Saves
Tabletop Simulator looks for save files in a specific directory on your operating system. You need to copy the unzipped folders into your game's `Saves` folder.

##### Save Folder Locations by OS:
*   **Windows (Standard):**
    `%USERPROFILE%\Documents\My Games\Tabletop Simulator\Saves`
    *(Alternatively: `C:\Users\<Your-Username>\Documents\My Games\Tabletop Simulator\Saves`)*
*   **Windows (OneDrive Synced):**
    `C:\Users\<Your-Username>\OneDrive\Documents\My Games\Tabletop Simulator\Saves`
*   **macOS:**
    `~/Library/Tabletop Simulator/Saves`
*   **Linux / Steam Deck:**
    `~/.local/share/Tabletop Simulator/Saves`

##### Copying the Files:
1.  Extract/unzip the downloaded file. You will get a folder (e.g. `LTC_Table`).
2.  Inside this folder, you will see `TS_Save_1.json` and `TS_Save_1.png`.
3.  Copy the entire folder (e.g., `LTC_Table/`, `Hutber/`, or `ForceOrg/`) directly into the `Saves/` folder listed above.
    *   *Resulting path example:* `.../Tabletop Simulator/Saves/LTC_Table/TS_Save_1.json`

> [!WARNING]
> **Preventing Save Overwrites & Conflicts:**
> *   **If using Subfolders (Recommended):** Because each save is in its own folder, they can all be named `TS_Save_1` without conflicting. TTS will display these folders in your in-game Save & Load menu.
> *   **If copying files directly to the root `Saves/` folder:** You **must** rename the `.json` and `.png` files to the next available number in your saves. For example, if you already have files up to `TS_Save_30.json`, you must rename the imported files to `TS_Save_31.json` and `TS_Save_31.png` so you do not overwrite your own saved games!

#### Step 3: Launch TTS & Load the Save
1.  Launch **Tabletop Simulator** via Steam.
2.  Select **Create** -> **Singleplayer** (or **Multiplayer** to host a game).
3.  Click **Games** in the top menu bar, then click **Save & Load**.
4.  If you copied the entire **subfolder** (e.g. `LTC_Table/`), you will see a folder with that name in the list — double-click it, then click the save image inside to load it.
5.  If you copied the files **directly into the root** `Saves/` folder (renaming them to `TS_Save_31.json` etc.), they will appear individually in the root of your save list by their in-game save name.

---

## 🛠️ Complete Warhammer 40k TTS Toolchain Guide
To build and play with your army on Tabletop Simulator, you should use the following modern community tools:

### 1. Build Your List (New Recruit)
*   **New Recruit** ([newrecruit.eu](https://www.newrecruit.eu/)) is the recommended, modern web-based army builder for Warhammer 40k. It is fast, free, and updates rules dynamically.
*   Once you finish building your roster, click the **Yellowscribe Export** button (or copy the Yellowscribe roster code).

### 2. Subscribe to Yellowscribe V2
*   **Yellowscribe V2** is a Steam Workshop mod that imports your army data from list builders into TTS.
*   Subscribe to it on Steam: [Yellowscribe V2 Workshop Page](https://steamcommunity.com/sharedfiles/filedetails/?id=2888164016)
*   Yellowscribe binds your list's stats, weapon options, and rules directly to your models in TTS, showing rules on hover and handling range/movement trackers.

### 3. Build Army (ForceOrg)
*   **ForceOrg** is the standard tool used to bind stats and format armies. Special thanks to **Raikoh** for creating and maintaining the official [ForceOrg Downloader](https://gitlab.com/forceorg1/ForceOrg-Downloader).

#### How to use ForceOrg:
1. Load the **ForceOrg** save table.
2. Paste your Yellowscribe roster code into the Yellowscribe Helper on the table.
3. Drag your models to the staging area.
4. Map your models to the Yellowscribe cards.
5. Create your army. Once created, select your entire army, right-click, and select **Save Object** to add it to your TTS inventory. You can now load any map (e.g., LTC Table or Hutber) and drag your saved army onto the table!
