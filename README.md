# AP-GUI

## AniPhobia Gui Y25 - Key Authenticated Edition

**AniPhobia Gui Y25** is the most advanced GUI script for the game **AniPhobia**, featuring a secure Discord-based key system, comprehensive feature set, and modern UI. While many AniPhobia scripts remain functional for only weeks or months, AP-GUI Y25 is designed with **long-term compatibility** in mind and is expected to remain operational across future anti-cheat updates.

---

## Overview

AP-GUI Y25 is a high-performance, feature-focused GUI developed specifically for **AniPhobia** on Roblox. The project prioritises stability, modularity, and longevity over short-lived or overly aggressive behaviour.

---

## Target Game

- **Game:** AniPhobia

**Game Link:** [https://www.roblox.com/games/6788434697/AniPhobia](https://www.roblox.com/games/6788434697/AniPhobia)

**Game Thumbnail:** ![AniPhobia Thumbnail](https://tr.rbxcdn.com/180DAY-a5c9e6b4cc19dcbd70a59017dee9d084/512/512/Image/Webp/noFilter)

---

## 🔑 Key System

AP-GUI Y25 uses a **Discord bot-based key system** for authentication:

### Getting a Key:
1. Join the Discord server
2. Use `/generate` command in any channel
3. Bot will DM you the loadstring
4. Copy and execute in your executor

---

## Script Architecture

AP-GUI Y25 is built using a **modular script architecture**, with each feature isolated into dedicated modules. This allows rapid updates, selective feature enabling, and reduced exposure to anti-cheat changes.

The script is designed to be loaded remotely via `loadstring`, enabling silent updates without redistributing files.

---

## Execution

**DO NOT SHARE YOUR KEY - IT'S HWID LOCKED**

Get your loadstring from the Discord bot using `/generate`. The bot will send you a unique loadstring that looks like:

```lua
getgenv().__APGUI_KEY = "your_unique_key_here"; loadstring(game:HttpGet("https://raw.githubusercontent.com/rexzcode/AP-GUI/refs/heads/main/AP%20GUI/Main/Main%20GUI/Loader.lua"))()
```
---

## Feature Breakdown
*Feature descriptions are intentionally high-level to avoid unnecessary exposure.*

###  Automation
* **Admin Detector:** Detects admins in-game with customizable alerts and optional auto server-hop
* **Auto Farm:** Automated location teleportation with enemy farming, anchoring, and customizable height offsets
* **Auto Item Collection:** Automatically collects weapons, ammo, heals, and items with distance/delay customization
* **Boss Money Auto-Collect:** Automated collection of boss money drops with retry logic

###  ESP Systems
AP-GUI Y25 includes a fully modular ESP framework with customizable colors, transparency, and text settings:

* **Enemy ESP (Waifus):** Visual tracking of game enemies with health, name, and distance display
* **Player ESP:** Track other players with customizable highlighting
* **Loot Item ESP:** Highlights weapons and collectible items with type-specific colors
* **Ammo Box ESP:** Displays ammunition box locations
* **Car ESP:** Highlights available vehicles with health and distance info

*Each ESP module runs independently and can be refreshed or cleared individually.*

###  Gun Modifications
* **Multi-Setting Gun Mod:** Infinite ammo, fire rate adjustment, damage modification, recoil/spread control, instant reload
* **Real-time Application:** Changes apply instantly to equipped weapons
* **Per-Gun Persistence:** Mods persist through respawns and character resets

###  Bullet Physics & Silent Aim
* **Silent Aim:** Auto-aim with FOV-based targeting
* **Target Body Parts:** Cycle through multiple body parts (Head, Torso, Arms, Legs) to bypass armor
* **R6/R15 Compatible:** Automatic body part detection for both rig types
* **Infinite Range:** Remove distance limitations
* **Wall Penetration:** Shoot through walls and multiple enemies
* **No Gravity:** Bullets travel straight
* **Bullet Speed Control:** Adjust projectile velocity
* **Prediction:** Lead moving targets automatically

###  Car Modifications
* **Multi-Setting Car Mod:** Infinite health, max speed, turn radius adjustments, auto-flip, no collision
* **Real-time Tuning:** Modify car stats while driving
* **Persistent Across Vehicles:** Mods apply to any vehicle you enter


---

##  User Interface

AP-GUI Y25 features a modern, fully customizable interface built with **MacLib**:

### UI Features:
* **Resizable Window:** Drag the bottom-right handle to resize
* **Tab-Based Organization:** Organized into Main, Combat, Visual, and Misc categories
* **Save Settings:** Configurations are saved automatically
* **Theme Support:** Dark theme with purple accent colors
* **Hotkey Toggle:** Press Right Control to open/close
* **Responsive Design:** Clean, modern interface that's easy to navigate

### GUI Tabs:
* **Admin Detector:** Configure admin detection and alerting
* **Auto Farm:** Teleportation and enemy farming settings
* **Auto Collect:** Item collection automation
* **Gun Mods:** Weapon modification controls
* **Bullet Mods:** Bullet physics and silent aim
* **Car Mods:** Vehicle enhancement options
* **ESP:** Visual overlay configurations
* **Settings:** Configuration management and info

---



### Maintenance Strategy
AP-GUI Y25 is maintained with:
1. Rapid response to AniPhobia updates
2. Silent backend fixes via loadstring updates
3. Modular patching without full rewrites
4. Discord-based key system prevents unauthorized distribution

The goal is **months-to-years of usability**, not short-lived public hype.

---

## Disclaimer
> This script is provided for educational and research purposes only. Use of this software is at your own risk. The developer assumes no responsibility for moderation actions taken by Roblox or game developers. Use at your own discretion.

---

## AI
This script and its contents are *NOT* created with the help of Artificial Intelligence, I dislike majority of AI Generated Luau Scripts for Roblox due to low detail. This ReadMe File is the **only** File created with the help of AI as I do not have a lot of experience with MD Formating.

## Credits
* **Developer:** Rexi
* **Project:** AP-GUI — AniPhobia Gui Y25
* **UI Library:** MacLib
* **Version:** Y25 (2025 Edition)