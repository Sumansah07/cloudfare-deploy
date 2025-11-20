@echo off
echo ========================================
echo Cloudflare Pages Secret Upload
echo ========================================
echo.
echo This will upload ALL secrets from .env to Cloudflare Pages
echo Project: bolt-ai
echo.
pause

echo.
echo Uploading secrets...
echo.

echo STRIPE_SECRET_KEY | npx wrangler pages secret put STRIPE_SECRET_KEY --project-name=bolt-ai < .dev.vars
echo VITE_STRIPE_PUBLISHABLE_KEY | npx wrangler pages secret put VITE_STRIPE_PUBLISHABLE_KEY --project-name=bolt-ai
echo CLERK_PUBLISHABLE_KEY | npx wrangler pages secret put CLERK_PUBLISHABLE_KEY --project-name=bolt-ai
echo VITE_CLERK_PUBLISHABLE_KEY | npx wrangler pages secret put VITE_CLERK_PUBLISHABLE_KEY --project-name=bolt-ai
echo CLERK_SECRET_KEY | npx wrangler pages secret put CLERK_SECRET_KEY --project-name=bolt-ai
echo CLERK_WEBHOOK_SECRET | npx wrangler pages secret put CLERK_WEBHOOK_SECRET --project-name=bolt-ai
echo VITE_SUPABASE_URL | npx wrangler pages secret put VITE_SUPABASE_URL --project-name=bolt-ai
echo VITE_SUPABASE_ANON_KEY | npx wrangler pages secret put VITE_SUPABASE_ANON_KEY --project-name=bolt-ai
echo SUPABASE_SERVICE_ROLE_KEY | npx wrangler pages secret put SUPABASE_SERVICE_ROLE_KEY --project-name=bolt-ai
echo GOOGLE_GENERATIVE_AI_API_KEY | npx wrangler pages secret put GOOGLE_GENERATIVE_AI_API_KEY --project-name=bolt-ai
echo OPEN_ROUTER_API_KEY | npx wrangler pages secret put OPEN_ROUTER_API_KEY --project-name=bolt-ai
echo STRIPE_WEBHOOK_SECRET | npx wrangler pages secret put STRIPE_WEBHOOK_SECRET --project-name=bolt-ai
echo STRIPE_PRICE_ID_FREE | npx wrangler pages secret put STRIPE_PRICE_ID_FREE --project-name=bolt-ai
echo STRIPE_PRICE_ID_PRO | npx wrangler pages secret put STRIPE_PRICE_ID_PRO --project-name=bolt-ai
echo STRIPE_PRICE_ID_ENTERPRISE | npx wrangler pages secret put STRIPE_PRICE_ID_ENTERPRISE --project-name=bolt-ai
echo STRIPE_PRICE_ID_ENTERPRISE_PLUS | npx wrangler pages secret put STRIPE_PRICE_ID_ENTERPRISE_PLUS --project-name=bolt-ai

echo.
echo ========================================
echo Upload Complete!
echo ========================================
echo.
echo Now run: npm run deploy
echo.
pause
