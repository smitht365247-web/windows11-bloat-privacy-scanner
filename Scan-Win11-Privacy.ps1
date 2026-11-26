<#
.SYNOPSIS
    Hardened v1.2: Read-only audit of Windows 10/11 telemetry services, advertising ID,
    startup items, and common preinstalled bloat packages.
#>
[CmdletBinding()]
param([string]$OutputFolder = $PSScriptRoot)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($OutputFolder -match '^[A-Za-z]:$') { $OutputFolder += '\' }
if (-not (Test-Path -LiteralPath $OutputFolder -PathType Container)) {
    New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
}
$OutputFolder = (Resolve-Path -LiteralPath $OutputFolder).ProviderPath

Write-Host "Auditing Windows 11 telemetry, privacy settings, and bloat packages..." -ForegroundColor Cyan

$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction SilentlyContinue
$buildNum = if ($osInfo) { $osInfo.BuildNumber } else { "Unknown" }

$diagTrack = Get-Service -Name "DiagTrack" -ErrorAction SilentlyContinue
$dmwappush = Get-Service -Name "dmwappushservice" -ErrorAction SilentlyContinue
$diagStatus = if ($diagTrack) { $diagTrack.Status } else { "NotFound" }
$dmwStatus = if ($dmwappush) { $dmwappush.Status } else { "NotFound" }

$adIdDisabled = "Unknown"
try {
    $advReg = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -ErrorAction Stop
    if ($advReg.PSObject.Properties['Enabled'] -and $null -ne $advReg.Enabled) {
        $adIdDisabled = if ($advReg.Enabled -eq 0) { "Yes (Disabled)" } else { "No (Enabled)" }
    }
} catch { $adIdDisabled = "Default/NotSet" }

$bloatPatterns = @("*Clipchamp*", "*Disney*", "*SpotifyAB.SpotifyMusic*", "*TikTok*", "*BingNews*", "*BingWeather*", "*Solitaire*", "*Teams*", "*Xbox*")
$installedBloat = @()
foreach ($pat in $bloatPatterns) {
    try {
        $pkgs = @(Get-AppxPackage -Name $pat -ErrorAction SilentlyContinue)
        foreach ($p in $pkgs) { $installedBloat += $p.Name }
    } catch { }
}
$installedBloat = @($installedBloat | Sort-Object -Unique)

$startupCount = 0
try { $startupCount = @(Get-CimInstance -ClassName Win32_StartupCommand -ErrorAction SilentlyContinue).Count } catch { $startupCount = 0 }

$score = 100
if ($diagStatus -eq "Running") { $score -= 20 }
if ($dmwStatus -eq "Running") { $score -= 10 }
if ($adIdDisabled -notlike "Yes*") { $score -= 15 }
$score -= [Math]::Min(35, ($installedBloat.Count * 5))
if ($startupCount -gt 12) { $score -= 15 }
$score = [Math]::Max(0, $score)

$reportPath = Join-Path $OutputFolder ("win11_privacy_audit_{0}.txt" -f (Get-Date -Format "yyyyMMdd_HHmmss"))
$lines = @(
    "WINDOWS 11 BLOAT, TELEMETRY & PRIVACY AUDIT (v1.2)",
    "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    "OS Build:  $buildNum",
    "------------------------------------------------------------",
    "Privacy & Lean Posture Score: $score / 100",
    "DiagTrack Service Status:     $diagStatus",
    "dmwappushservice Status:      $dmwStatus",
    "Advertising ID Disabled:      $adIdDisabled",
    "Startup Commands Detected:    $startupCount",
    "Matched Preinstalled Apps:    $($installedBloat.Count)",
    $(if ($installedBloat.Count -gt 0) { "  -> " + ($installedBloat -join ", ") } else { "  -> None matched" }),
    "------------------------------------------------------------",
    "NOTE: This scan is 100% read-only and makes zero system changes."
)

$lines | Set-Content -LiteralPath $reportPath -Encoding UTF8
$lines | ForEach-Object { Write-Host $_ }
Write-Host ""
Write-Host "Audit report saved to: $reportPath" -ForegroundColor Green
