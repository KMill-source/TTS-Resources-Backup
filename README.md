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
    *   **ForceOrg Team**
    Please support these creators directly on Steam Workshop and their respective community Discord servers.

---

## 📦 What's Inside?
This backup contains saves for three major 40k table and utility frameworks:
1.  **LTC Table (`LTC_Table.zip`):** The standard map layout and base setup maintained by the LTC community.
2.  **Hutber Base (`Hutber.zip`):** Highly optimized competitive tournament map layout.
3.  **ForceOrg Backup (`ForceOrg.zip`):** The essential utility and scripting tool used to manage model bases, army scaling, rules binding, and more.

---

## 🛡️ Security & File Verification

To ensure that these backup files are safe and have not been modified, we provide the SHA-256 hashes for the core `.json` Tabletop Simulator save files, along with direct scan report links on **VirusTotal**.

### 🔍 File Hashes & VirusTotal Reports

| File Name | SHA-256 Hash | VirusTotal Scan Report |
| :--- | :--- | :--- |
| **`ForceOrg/TS_Save_1.json`** | `80b514ebfaa25f31abfa2a29d3660606b925e04667fe6c26ea4deb43590e3afe` | [View Report](https://www.virustotal.com/gui/file/80b514ebfaa25f31abfa2a29d3660606b925e04667fe6c26ea4deb43590e3afe) |
| **`Hutber/TS_Save_1.json`** | `f62515a844feae20dd4f37e4f3b5f1e37660d9fe59e194920502af5c7e0d755b` | [View Report](https://www.virustotal.com/gui/file/f62515a844feae20dd4f37e4f3b5f1e37660d9fe59e194920502af5c7e0d755b) |
| **`LTC_Table/TS_Save_1.json`** | `d360000d4aa411051705416275494df94d25a221ab35708dc734f42f9865c538` | [View Report](https://www.virustotal.com/gui/file/d360000d4aa411051705416275494df94d25a221ab35708dc734f42f9865c538) |

> [!TIP]
> If a file has not been analyzed by VirusTotal yet when you click the link, you can upload the `.json` save file directly to [VirusTotal](https://www.virustotal.com/) to trigger a fresh scan. Since these are plain text JSON files, they will scan clean.

### 🖥️ How to Verify Hashes Locally

You can check the hash of any file you download to confirm it matches the hashes listed above:

#### Windows (PowerShell):
```powershell
Get-FileHash -Path "C:\path\to\downloaded-file.zip" -Algorithm SHA256
```

#### macOS / Linux (Terminal):
```bash
shasum -a 256 /path/to/downloaded-file.zip
```

---

## 🚀 Installation Guide

Choose either the automated script method (easiest for Windows users) or the manual method.

---

### Method 1: Automated Script (Windows Only - Recommended)

This repository includes a PowerShell script `install_saves.ps1` that automates the entire installation. It will automatically:
1. Locate your Tabletop Simulator Saves folder (supporting both standard and OneDrive paths).
2. Scan your current saves to find the next available save number.
3. Extract, rename, and install the save files directly into your game's directory so they do not conflict with or overwrite any of your current saves.

#### How to use it:
1. Click the green **Code** button at the top-right of this page and select **Download ZIP** (or download the files to your PC).
2. Extract the downloaded ZIP file.
3. Right-click the `install_saves.ps1` file and select **Run with PowerShell**.
   * *Alternatively*, open a PowerShell window in the folder and run:
     ```powershell
     Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
     .\install_saves.ps1
     ```
4. The script will output a success message showing which save numbers the tables were imported as.

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

### 3. Spawn Models (ForceOrg)
*   Load the **ForceOrg** save table.
*   Paste your Yellowscribe roster code into the ForceOrg console.
*   Spawn your models. Once spawned, select your entire army, right-click, and select **Save Object**.
*   This adds your army to your TTS inventory. You can now load any map (e.g., LTC Table or Hutber) and drag your saved army onto the table!
