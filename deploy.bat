@echo off
echo ========================================
echo Cloudflare Pages Deployment Script
echo ========================================
echo.

echo Step 1: Checking if wrangler is installed...
where wrangler >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Wrangler not found. Installing...
    npm install -g wrangler
) else (
    echo Wrangler is already installed.
)
echo.

echo Step 2: Logging into Cloudflare...
wrangler login
echo.

echo Step 3: Installing dependencies...
call pnpm install
echo.

echo Step 4: Building the application...
call pnpm run build
if %ERRORLEVEL% NEQ 0 (
    echo Build failed! Please check the errors above.
    pause
    exit /b 1
)
echo.

echo Step 5: Deploying to Cloudflare Pages...
call wrangler pages deploy ./build/client --project-name=bolt-ai
if %ERRORLEVEL% NEQ 0 (
    echo Deployment failed! Please check the errors above.
    pause
    exit /b 1
)
echo.

echo ========================================
echo Deployment Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Go to Cloudflare Dashboard to set environment variables
echo 2. Update Clerk allowed domains with your Pages URL
echo 3. Update Stripe webhook endpoints
echo 4. Update Supabase redirect URLs
echo.
echo See DEPLOYMENT_GUIDE.md for detailed instructions.
echo.
pause
