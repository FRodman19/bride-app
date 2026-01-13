
⏺ Google Cloud Console Setup for Rhydle OAuth

  Overview

  This guide will help you configure Google OAuth so users see
  "Rhydle" with your app logo when they click "Continue
  with Google" - not generic Supabase branding.

  ---
  Part 1: Create Google Cloud Project

  Step 1: Access Google Cloud Console

  1. Go to: https://console.cloud.google.com
  2. Sign in with your Google account
  3. Click "Select a project" dropdown at the top
  4. Click "NEW PROJECT"

  Step 2: Create Project

  - Project name: Rhydle
  - Organization: Leave as "No organization" (unless you have one)
  - Click "CREATE"
  - Wait for project creation (takes ~30 seconds)

  ---
  Part 2: Enable Required APIs

  Step 3: Enable Google+ API (or People API)

  1. In the left sidebar, go to "APIs & Services" > "Library"
  2. Search for: "Google+ API" OR "People API"
  3. Click on it, then click "ENABLE"
  4. Wait for activation

  ---
  Part 3: Configure OAuth Consent Screen (CRITICAL FOR BRANDING)

  Step 4: Set Up Consent Screen

  1. Go to "APIs & Services" > "OAuth consent screen" (left sidebar)
  2. Select "External" user type (unless you have Google Workspace)
  3. Click "CREATE"

  Step 5: App Information (This is what users will see!)

  Fill in the form with YOUR app branding:

  App information:
  - App name: Rhydle ✅ (Users will see this!)
  - User support email: Your email address
  - App logo:
    - Click "Upload logo"
    - Requirements:
        - PNG or JPG format
      - Square image (120px × 120px recommended)
      - Less than 1MB
    - Upload your app logo ✅ (Users will see this!)

  App domain:
  - Application home page: Leave empty for now (or add if you have a
  website)
  - Application privacy policy link: Leave empty for testing (required
  for production)
  - Application terms of service link: Leave empty for testing (required
   for production)

  Authorized domains:
  ⚠️ IMPORTANT: LEAVE THIS EMPTY for now!
  - DO NOT add supabase.co here (you don't own this domain)
  - This section is only for domains YOU own (like your company website)
  - The Supabase redirect URL is configured later in OAuth credentials
  - Click "SAVE AND CONTINUE"

  Step 6: Scopes

  1. Click "ADD OR REMOVE SCOPES"
  2. Select these scopes (filter or search for them):
    - ../auth/userinfo.email ✅ (Read email address)
    - ../auth/userinfo.profile ✅ (Read basic profile info)
    - openid ✅ (Required for OAuth)
  3. Click "UPDATE"
  4. Click "SAVE AND CONTINUE"

  Step 7: Test Users (for development)

  Since app is in "Testing" mode, add your Google account(s):
  1. Click "+ ADD USERS"
  2. Enter your email(s) that you'll test with
  3. Click "ADD"
  4. Click "SAVE AND CONTINUE"

  Step 8: Summary & Publish

  1. Review the summary
  2. For now, leave app in "Testing" mode (you can publish later)
  3. Click "BACK TO DASHBOARD"

  ---
  Part 4: Create OAuth Credentials

  Step 9: Create Web Application Client (for Supabase callback)

  1. Go to "APIs & Services" > "Credentials" (left sidebar)
  2. Click "+ CREATE CREDENTIALS" > "OAuth client ID"
  3. Select Application type: "Web application"
  4. Fill in:
    - Name: Rhydle Web Client
    - Authorized JavaScript origins: Leave empty
    - Authorized redirect URIs: Click "+ ADD URI"
        - Add:
  https://YOUR_SUPABASE_PROJECT_REF.supabase.co/auth/v1/callback
      - (Replace YOUR_SUPABASE_PROJECT_REF with your actual Supabase
  project reference)
      - Example: https://abcdefghij.supabase.co/auth/v1/callback
  5. Click "CREATE"

  📋 IMPORTANT: Copy these credentials!
  - Client ID: Copy this (looks like:
  123456789-abc123.apps.googleusercontent.com)
  - Client secret: Copy this (looks like: GOCSPX-AbC123...)
  - You'll need both for Supabase configuration

  Step 10: Get Your Supabase Project Reference

  Open a new tab and:
  1. Go to your Supabase dashboard: https://supabase.com/dashboard
  2. Select your project
  3. Go to Settings > API
  4. Find your Project URL: https://YOUR_PROJECT_REF.supabase.co
  5. Copy the project reference part (e.g., if URL is
  https://abcdefghij.supabase.co, copy abcdefghij)

  ---
  Part 5: Create Android OAuth Client

  Step 11: Get Your Android SHA-1 Certificate Fingerprint

  For DEBUG builds (development):
  Run this command in your terminal:
  cd /Users/MAC/Documents/test\ mobile\ app/bride_app/android
  ./gradlew signingReport

  Look for the SHA-1 under Variant: debug. It looks like:
  SHA-1: A1:B2:C3:D4:E5:F6:...
  Copy this SHA-1 fingerprint.

  For RELEASE builds (production - do this later):
  You'll need to create a keystore first, but for now, use the debug
  SHA-1.

  Step 12: Create Android OAuth Client

  1. Back in Google Cloud Console > "Credentials"
  2. Click "+ CREATE CREDENTIALS" > "OAuth client ID"
  3. Select Application type: "Android"
  4. Fill in:
    - Name: Rhydle Android
    - Package name: com.example.my_first_app (from your
  AndroidManifest.xml)
    - SHA-1 certificate fingerprint: Paste the SHA-1 from step 11
  5. Click "CREATE"

  📋 IMPORTANT: Copy this credential!
  - Client ID: Copy this Android client ID (looks like:
  123456789-xyz789.apps.googleusercontent.com)

  ---
  Part 6: Update Your App Configuration

  Step 13: Update .env File

  Open /Users/MAC/Documents/test mobile app/bride_app/.env and update:

  # Google OAuth Configuration (Phase 9)
  # Web client ID (for Supabase OAuth callback)
  GOOGLE_CLIENT_ID_WEB=123456789-abc123.apps.googleusercontent.com

  # Android client ID (from Step 12)
  GOOGLE_CLIENT_ID_ANDROID=123456789-xyz789.apps.googleusercontent.com

  Replace with your actual client IDs from Steps 9 and 12.

  ---
  Part 7: Configure Supabase Google Provider

  Step 14: Enable Google Provider in Supabase

  1. Go to Supabase Dashboard: https://supabase.com/dashboard
  2. Select your project
  3. Go to Authentication > Providers (left sidebar)
  4. Find Google in the list
  5. Toggle it ON (enabled)
  6. Fill in:
    - Client ID (for OAuth): Paste Web Client ID from Step 9
    - Client Secret (for OAuth): Paste Client Secret from Step 9
    - Authorized Client IDs: Paste Android Client ID from Step 12
  7. Click "Save"

  ---
  Part 8: Verify Configuration

  Step 15: Double-Check Everything

  Google Cloud Console checklist:
  - ✅ OAuth consent screen shows "Rhydle" as app name
  - ✅ Your app logo is uploaded and visible
  - ✅ Web OAuth client created with Supabase redirect URI
  - ✅ Android OAuth client created with correct package name and SHA-1
  - ✅ Test user(s) added (your email)

  Supabase checklist:
  - ✅ Google provider enabled
  - ✅ Web client ID and secret configured
  - ✅ Android client ID added to authorized clients

  .env file checklist:
  - ✅ GOOGLE_CLIENT_ID_WEB filled with web client ID
  - ✅ GOOGLE_CLIENT_ID_ANDROID filled with Android client ID

  ---
  What You Should Have Now

  1. Google Cloud Console project named "Rhydle"
  2. OAuth consent screen with your app name and logo ✅
  3. 2 OAuth clients:
    - Web client (for Supabase)
    - Android client (for mobile app)
  4. Supabase configured with Google provider
  5. .env file updated with both client IDs

  ---
  Next Steps (When You Return)

  Once you've completed the above configuration, come back and we'll:
  1. Test the Google sign-in flow on your Android device
  2. Verify users see "Rhydle" with your logo in the Google auth screen
  3. Ensure successful authentication redirects to dashboard
  4. Handle any issues that come up during testing

  ---
  Quick Reference: What Users Will See

  When users click "Continue with Google", they'll see:
  ┌────────────────────────────────┐
  │  [Your App Logo]               │
  │  Rhydle                        │ ← Your app name
  │                                │
  │  wants to access your Google   │
  │  Account                       │
  │                                │
  │  [Your Email]                  │
  │  ○ View your email address     │
  │  ○ View your basic profile     │
  │                                │
  │  [Cancel]  [Continue]          │
  └────────────────────────────────┘

  ---
  Take your time with the configuration. When you're done, just let me 
  know and we'll test it together!