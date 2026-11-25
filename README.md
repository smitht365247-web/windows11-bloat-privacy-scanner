# Windows 11 Bloat, Telemetry & Privacy Scanner (Free, Portable)

A lightweight, **100% read-only** Windows 10/11 utility that audits your telemetry services, advertising ID, startup count, and preinstalled bloatware packages, then generates a **Privacy & Lean Posture Score (0–100)**—no Python, Docker, or coding required.

## What It Audits (Zero System Changes)
- **Telemetry Services:** Checks `DiagTrack` and `dmwappushservice` status.
- **Advertising ID:** Checks `HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo`.
- **Startup Commands:** Counts background startup items via `Win32_StartupCommand`.
- **Preinstalled Bloatware:** Scans for common preinstalled packages (Clipchamp, Disney, Spotify, TikTok, BingNews/Weather, Solitaire, Teams, Xbox).
- **Timestamped Report:** Saves a clean `win11_privacy_audit_*.txt` report.

## Quick Start
1. Click **Code -> Download ZIP** (or grab the free pre-packaged ZIP on [Gumroad](https://smitht365.gumroad.com/l/fydryu)).
2. Extract the ZIP folder to your PC (e.g., `C:\Tools\Win11-Bloat-Privacy-Scanner`).
3. Double-click `RUN_SCANNER.bat`, choose where to save the report (or press **Enter** for default), and review your audit score.

## Windows SmartScreen Unblock Instructions
Because `.bat` and `.ps1` files downloaded from the internet are unsigned, Windows SmartScreen may show *"Windows protected your PC"* on the first run:
- Click **More info** -> **Run anyway**, **OR**
- Right-click the downloaded `.zip` file **before extracting** -> **Properties** -> check **Unblock** -> **Apply / OK**, then extract.

## Want Safe, Reversible Debloating & Telemetry Tuning?
Upgrade to the **[Windows 11 Safe Debloat, Privacy & Telemetry Tuner ($19 on Gumroad)](https://smitht365.gumroad.com/l/cnsts)** — portable Windows 11 toolkit with:
- **System Restore Point Helper** before making any changes
- **Automatic Registry Rollback Backups** + **1-Click `.reg` Restore Utility**
- **Protected Core-App Guards** (keeps Microsoft Store, Edge/WebView, Defender, and core Windows intact)
- **Safe Telemetry & Bloatware Hardening** without breaking Windows updates
