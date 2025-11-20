# PowerShell script to safely upload secrets to Cloudflare Workers
# This script reads your .env file and uploads each variable as a secret

param(
    [string]$ProjectName = "bolt-ai",
    [switch]$DryRun = $false
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Cloudflare Workers Secret Upload Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if .env file exists
if (-not (Test-Path ".env")) {
    Write-Host "ERROR: .env file not found!" -ForegroundColor Red
    exit 1
}

Write-Host "Reading .env file..." -ForegroundColor Yellow
Write-Host ""

# Read .env file and parse variables
$secrets = @()
Get-Content .env | ForEach-Object {
    $line = $_.Trim()
    
    # Skip comments and empty lines
    if ($line -match '^#' -or $line -eq '') {
        return
    }
    
    # Parse KEY=VALUE
    if ($line -match '^([^=]+)=(.*)$') {
        $key = $matches[1].Trim()
        $value = $matches[2].Trim()
        
        # Remove quotes if present
        $value = $value -replace '^["'']|["'']$', ''
        
        # Skip placeholder values
        if ($value -match 'your_.*_here' -or $value -eq '') {
            Write-Host "⏭️  Skipping $key (placeholder or empty value)" -ForegroundColor Gray
            return
        }
        
        $secrets += @{
            Key = $key
            Value = $value
        }
    }
}

Write-Host "Found $($secrets.Count) secrets to upload" -ForegroundColor Green
Write-Host ""

if ($DryRun) {
    Write-Host "DRY RUN MODE - No secrets will be uploaded" -ForegroundColor Yellow
    Write-Host "The following secrets would be uploaded:" -ForegroundColor Yellow
    $secrets | ForEach-Object {
        $maskedValue = if ($_.Value.Length -gt 10) { 
            $_.Value.Substring(0, 10) + "..." 
        } else { 
            "***" 
        }
        Write-Host "  - $($_.Key) = $maskedValue" -ForegroundColor Cyan
    }
    Write-Host ""
    Write-Host "To actually upload, run without -DryRun flag" -ForegroundColor Yellow
    exit 0
}

# Confirm before proceeding
Write-Host "⚠️  WARNING: This will upload $($secrets.Count) secrets to Cloudflare Workers project '$ProjectName'" -ForegroundColor Yellow
Write-Host ""
$confirm = Read-Host "Do you want to continue? (yes/no)"

if ($confirm -ne "yes") {
    Write-Host "Aborted by user" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Uploading secrets..." -ForegroundColor Green
Write-Host ""

$successCount = 0
$failCount = 0

foreach ($secret in $secrets) {
    try {
        Write-Host "📤 Uploading: $($secret.Key)..." -NoNewline
        
        # Use wrangler secret put command for Cloudflare Workers
        $secret.Value | npx wrangler secret put $secret.Key 2>&1 | Out-Null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host " ✅ Success" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host " ❌ Failed" -ForegroundColor Red
            $failCount++
        }
    }
    catch {
        Write-Host " ❌ Error: $_" -ForegroundColor Red
        $failCount++
    }
    
    # Small delay to avoid rate limiting
    Start-Sleep -Milliseconds 500
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Upload Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ Successfully uploaded: $successCount secrets" -ForegroundColor Green
if ($failCount -gt 0) {
    Write-Host "❌ Failed to upload: $failCount secrets" -ForegroundColor Red
}
Write-Host ""
