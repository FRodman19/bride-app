# Performance Tracker App - Implementation Plan

> **IMPORTANT: This is the SINGLE SOURCE OF TRUTH for building this app.**
>
> **Before building ANY feature:**
> 1. Read this document first
> 2. Check if the feature is already built (marked with [x])
> 3. Check if wireframe exists in `performance-section-wireframe.md`
> 4. If wireframe missing, ASK user to provide it before building
> 5. After completing a feature, mark the checkbox and add completion date

---

## How To Use This Plan

### For Every New Conversation:
```
1. READ this file: bride_app/IMPLEMENTATION_PLAN.md
2. CHECK what phase we're in
3. CHECK what's already built (checkboxes)
4. CONTINUE from where we left off
5. UPDATE checkboxes when done
```

### Golden Rules:
- **DO NOT** create new planning documents - this is the only one
- **DO NOT** build screens without wireframes
- **DO NOT** skip phases - they build on each other
- **DO** mark checkboxes immediately after completing work
- **DO** reference wireframe file for all screen designs

---

## MANDATORY: Use GOL Design System

> **Using the Grow Out Loud (GOL) design system is MANDATORY for all UI development.**

### Design System Location:
- **Components**: `lib/grow_out_loud/components/`
- **Foundation**: `lib/grow_out_loud/foundation/`
- **Gallery/Reference**: `lib/screens/grow_out_loud_gallery_screen.dart`

### What You MUST Use:
| Category | Use This | NOT This |
|----------|----------|----------|
| Buttons | `GOLButton` | `ElevatedButton`, `TextButton` |
| Cards | `GOLCard` | `Card`, custom containers |
| Inputs | `GOLTextField`, `GOLSearchField` | `TextField`, `TextFormField` |
| Spacing | `GOLSpacing.space2`, `GOLSpacing.space4` | `SizedBox(height: 15)` |
| Colors | `colors.textPrimary`, `colors.interactivePrimary` | `Color(0xFF123456)` |
| Typography | `textTheme.headlineSmall`, `textTheme.bodyMedium` | `TextStyle(fontSize: 17)` |
| Icons | Iconsax outline variants | Emojis, custom icons |
| Platform Icons | `assets/icons/facebook.svg`, `assets/icons/tiktok.svg` | New icon files |

### Rejection Criteria (Code will be rejected if):
- Custom UI components created instead of using GOL components
- Arbitrary spacing values not from `GOLSpacing`
- Hardcoded colors instead of semantic colors
- Emojis used anywhere in the UI
- New icon files created instead of using existing assets

### Quick Reference:
```dart
// Get colors and typography in any widget
final colors = GOLSemanticColors.of(context);
final textTheme = Theme.of(context).textTheme;

// Use SVG platform icons
SvgPicture.asset('assets/icons/facebook.svg', width: 24, height: 24)
SvgPicture.asset('assets/icons/tiktok.svg', width: 24, height: 24)
```

See `CLAUDE.md` and `lib/grow_out_loud/foundation/DESIGN_PATTERNS.md` for detailed patterns.

---

### Wireframe Reference:
All screen designs are in: `performance-section-wireframe.md`

**Screens WITH wireframes:** 1-35 (except Settings which needs to be added)
**Screens MISSING wireframes:** Settings page details (user must provide before building)

---

## Build Progress Tracker

### Current Phase: PHASE 7 - IN PROGRESS
### Last Updated: 2026-01-07

### Phase 1: Foundation Setup
- [x] Dependencies added to pubspec.yaml (2026-01-02)
- [x] Supabase project connected via MCP (2026-01-02)
- [x] Supabase tables created - 8 tables with RLS (2026-01-02)
- [x] Drift database configured (2026-01-02)
- [x] Auth service implemented (2026-01-02)
- [x] Connectivity service implemented (2026-01-02)
- [x] Basic routing with go_router (2026-01-02)

### Phase 2: Core Flow
- [x] Screen 1: Performance Dashboard (2026-01-02)
- [x] Screen 2: Create Tracker (manual) (2026-01-02)
- [x] Screen 3: Tracker Hub - Overview Tab (2026-01-03)
- [x] Screen 21: Dashboard Empty State (2026-01-02)
- [x] Screen 29: Success Toast (2026-01-03)
- [x] Screen 35: Trackers List View (2026-01-02)
- [x] Bottom navigation working (2026-01-02)
- [x] Tracker CRUD operations (2026-01-02)

### Phase 3: Daily Entry Flow
- [x] Screen 7: Log Daily Entry (2026-01-03)
- [x] Screen 8: Entry Detail View (2026-01-03)
- [x] Screen 9: Edit Entry (2026-01-03)
- [x] Screen 4: Daily Entries Tab (2026-01-03)
- [x] Screen 10: Entry History (2026-01-03)
- [x] Screen 17: Add Platform Spend Row (2026-01-03) (integrated in Log Entry)
- [x] Screen 22: Entries Empty State (2026-01-03)
- [x] Screen 26: Delete Entry Confirmation (2026-01-03)
- [x] Entry validation (no future dates, no duplicates) (2026-01-03)
- [x] Offline entry queuing (2026-01-03)

### Phase 4: Reports & Analytics
- [x] Screen 5: Reports Tab (2026-01-03)
- [x] Total profit/loss calculation (2026-01-03)
- [x] Revenue vs Spend breakdown (2026-01-03)
- [x] Burn rate calculation (2026-01-03)
- [x] Best/worst days logic (2026-01-03)
- [x] Time periods filters (Daily/Weekly/Monthly) (2026-01-03)
- [x] Export to CSV (2026-01-03)

### Phase 5: Posts & Archive
- [x] Screen 11: Posts List (2026-01-03)
- [x] Screen 12: Add Post Modal (2026-01-03)
- [x] Screen 13: Edit/Delete Post Modal (2026-01-03)
- [x] Screen 23: Posts Empty State (2026-01-03)
- [x] Screen 27: Delete Post Confirmation (2026-01-03)
- [x] Screen 6: Archive View (2026-01-03)
- [x] Screen 24: Archive Empty State (2026-01-03)
- [x] Archive/Restore functionality (2026-01-03)

### Phase 6: Settings & Management
- [x] Screen 34: Settings Page (2026-01-04)
- [x] Screen 14: Edit Tracker Settings (2026-01-07)
- [x] Screen 15: Delete Tracker Confirmation (2026-01-07) (integrated in edit screen)
- [x] Screen 16: Platform Management (2026-01-07) (deferred - only 2 hardcoded platforms, inline chips sufficient)
- [x] Screen 19: Quick Actions Menu (2026-01-07) (implemented as _showActionsMenu in tracker_hub)
- [ ] Screen 20: Historical Data Edit (optional - bulk editing feature)
- [x] Screen 28: Delete Platform Confirmation (2026-01-07) (deferred - only 2 hardcoded platforms)
- [x] Screen 31: General Error State (2026-01-07) (EmptyState.error(), EmptyState.networkError())
- [x] Screen 32: Export Success Modal (2026-01-07) (covered by system share sheet on mobile)
- [ ] Screen 33: Bulk Actions Modal (optional enhanced feature)
- [x] Screen 25: Entry History Empty State (2026-01-07) (implemented in entry_history_screen)
- [x] 20 tracker limit enforcement (2026-01-07) (in create_tracker_screen + tracker_provider)
- [ ] Copy/duplicate tracker feature (optional)

### Phase 7: Polish & Sync
- [x] Sync engine complete (2026-01-07) (auto-sync on reconnect, queue management)
- [x] Offline indicator banner (2026-01-07) (OfflineBanner widget available, disabled for silent sync UX)
- [x] Conflict resolution (last-write-wins) (2026-01-07) (atomic conditional update in sync_provider)
- [x] Sync Now button in settings (2026-01-07)
- [x] Exponential backoff for sync retries (2026-01-07) (1s base, 5min max, 5 max failures)
- [x] Last sync timestamp tracking (2026-01-07) (SyncState.lastSyncTime)
- [x] Animated banner transitions (2026-01-07) (slide + fade with AnimatedSwitcher)
- [x] Sync progress indicator (2026-01-07) (shows "X / Y" during sync)
- [x] Tap-to-sync on pending banner (2026-01-07) (InkWell with refresh icon)
- [x] Tracker sync support (2026-01-07) (syncs trackers, platforms, goals to Supabase)
- [ ] Push notifications configured (requires Firebase setup)
- [ ] Daily reminder notifications working (requires Firebase)
- [ ] Performance optimization
- [ ] Testing complete

### Phase 8: AI Features (DEFERRED)
- [ ] OpenRouter integration
- [ ] Screen 18: AI Quick Start Modal
- [ ] Screen 30: AI Loading State
- [ ] AI form pre-fill working

---

## Overview
Build a standalone 35-screen Performance Tracker Flutter app for tracking campaign ROI, daily revenue, ad spend, and profitability across platforms.

---

## Tech Stack Decisions

| Component | Choice | Rationale |
|-----------|--------|-----------|
| **Framework** | Flutter (existing) | Already configured with GOL design system |
| **State Management** | Riverpod | Modern, type-safe, testable |
| **Backend/Auth** | Supabase | Open-source, PostgreSQL, auth included |
| **Local Database** | Drift (SQLite) | Offline-first support, SQL-based (matches Supabase schema) |
| **AI Provider** | OpenRouter | Unified API for multiple LLMs |
| **AI Model** | GPT-4.1 (gpt-4-turbo) | User preference via OpenRouter |
| **Navigation** | go_router | Declarative routing, deep linking support |
| **Push Notifications** | Firebase Cloud Messaging | Daily reminders for tracking |

---

## Architecture: Offline-First Design

```
┌─────────────────────────────────────────────────────────────┐
│                        Flutter App                          │
├─────────────────────────────────────────────────────────────┤
│  UI Layer (Screens)                                         │
│  └── Uses GOL Design System components                      │
├─────────────────────────────────────────────────────────────┤
│  State Layer (Riverpod Providers)                           │
│  └── TrackerNotifier, EntryNotifier, AuthNotifier, etc.     │
├─────────────────────────────────────────────────────────────┤
│  Repository Layer                                           │
│  └── Abstracts data source (decides local vs remote)        │
├─────────────────────────────────────────────────────────────┤
│  Data Sources                                               │
│  ├── Local: Drift (SQLite) - Always available               │
│  └── Remote: Supabase - When online                         │
├─────────────────────────────────────────────────────────────┤
│  Sync Engine                                                │
│  └── Queues changes offline, syncs when connected           │
└─────────────────────────────────────────────────────────────┘
```

### Offline Behavior
- **Always Available (Offline):**
  - View existing trackers, entries, posts
  - Create new entries (queued for sync)
  - Edit existing data (queued for sync)
  - View cached reports

- **Requires Connection:**
  - User authentication (login/signup)
  - AI Quick Start feature
  - Initial data sync after login
  - Real-time sync with other devices

---

## Database Schema (Supabase + Drift Mirror)

### Tables (from architecture doc)

1. **users** (Supabase Auth handles this)
2. **trackers** - Main campaign/project entity
3. **daily_entries** - Daily performance logs
4. **entry_platform_spends** - Per-platform ad spend
5. **tracker_platforms** - N:M resolver for tracker platforms
6. **posts** - Optional content references
7. **tracker_goals** - Goal tags/chips

### Sync Metadata Tables (Local Only)
- **sync_queue** - Pending changes to sync
- **sync_status** - Last sync timestamps per table

---

## Project Structure

```
lib/
├── main.dart
├── app.dart                           # App widget with routing
├── grow_out_loud/                     # [EXISTING - DO NOT MODIFY]
│
├── core/
│   ├── config/
│   │   ├── supabase_config.dart       # Supabase initialization
│   │   ├── openrouter_config.dart     # AI API configuration
│   │   └── app_config.dart            # Environment variables
│   ├── constants/
│   │   ├── platform_constants.dart    # Platform names, icons
│   │   ├── currency_constants.dart    # Currency codes, symbols
│   │   └── goal_constants.dart        # Goal type chips
│   ├── utils/
│   │   ├── currency_formatter.dart
│   │   ├── date_formatter.dart
│   │   └── validators.dart
│   └── extensions/
│       └── context_extensions.dart
│
├── data/
│   ├── local/
│   │   ├── database.dart              # Drift database definition
│   │   ├── database.g.dart            # Generated
│   │   ├── tables/
│   │   │   ├── trackers_table.dart
│   │   │   ├── entries_table.dart
│   │   │   ├── spends_table.dart
│   │   │   ├── platforms_table.dart
│   │   │   ├── posts_table.dart
│   │   │   └── sync_queue_table.dart
│   │   └── daos/
│   │       ├── tracker_dao.dart
│   │       ├── entry_dao.dart
│   │       └── sync_dao.dart
│   │
│   ├── remote/
│   │   ├── supabase_client.dart
│   │   ├── api/
│   │   │   ├── tracker_api.dart
│   │   │   ├── entry_api.dart
│   │   │   └── ai_api.dart            # OpenRouter calls
│   │   └── dto/
│   │       ├── tracker_dto.dart
│   │       └── entry_dto.dart
│   │
│   └── repositories/
│       ├── tracker_repository.dart
│       ├── entry_repository.dart
│       ├── post_repository.dart
│       ├── auth_repository.dart
│       └── sync_repository.dart
│
├── domain/
│   ├── models/
│   │   ├── tracker.dart
│   │   ├── daily_entry.dart
│   │   ├── platform_spend.dart
│   │   ├── post.dart
│   │   ├── user.dart
│   │   └── sync_item.dart
│   └── enums/
│       ├── platform_type.dart
│       ├── goal_type.dart
│       └── sync_status.dart
│
├── providers/
│   ├── auth_provider.dart
│   ├── tracker_provider.dart
│   ├── entry_provider.dart
│   ├── reports_provider.dart
│   ├── connectivity_provider.dart
│   └── sync_provider.dart
│
├── services/
│   ├── auth_service.dart
│   ├── sync_service.dart
│   ├── ai_service.dart                # OpenRouter integration
│   └── notification_service.dart      # FCM + local notifications
│
├── routing/
│   ├── app_router.dart                # go_router configuration
│   ├── routes.dart                    # Route constants
│   └── guards/
│       └── auth_guard.dart
│
└── features/
    ├── auth/
    │   ├── screens/
    │   │   ├── login_screen.dart
    │   │   ├── signup_screen.dart
    │   │   └── forgot_password_screen.dart
    │   └── widgets/
    │       └── auth_form.dart
    │
    ├── dashboard/
    │   ├── screens/
    │   │   └── dashboard_screen.dart          # Screen 1
    │   └── widgets/
    │       ├── performance_overview_card.dart
    │       ├── quick_actions_row.dart
    │       ├── recent_tracker_card.dart
    │       └── tracker_ranking_list.dart
    │
    ├── tracker/
    │   ├── screens/
    │   │   ├── create_tracker_screen.dart     # Screen 2
    │   │   ├── tracker_hub_screen.dart        # Screen 3 (with tabs 4, 5)
    │   │   ├── trackers_list_screen.dart      # Screen 35
    │   │   ├── archive_screen.dart            # Screen 6
    │   │   └── edit_tracker_screen.dart       # Screen 14
    │   └── widgets/
    │       ├── tracker_form.dart
    │       ├── platform_selector.dart
    │       ├── goal_chips.dart
    │       └── tracker_card.dart
    │
    ├── entry/
    │   ├── screens/
    │   │   ├── log_entry_screen.dart          # Screen 7
    │   │   ├── entry_detail_screen.dart       # Screen 8
    │   │   ├── edit_entry_screen.dart         # Screen 9
    │   │   ├── entry_history_screen.dart      # Screen 10
    │   │   └── bulk_edit_screen.dart          # Screen 20
    │   └── widgets/
    │       ├── entry_form.dart
    │       ├── platform_spend_row.dart
    │       ├── entry_card.dart
    │       └── entry_summary.dart
    │
    ├── posts/
    │   ├── screens/
    │   │   └── posts_list_screen.dart         # Screen 11
    │   └── widgets/
    │       ├── post_card.dart
    │       ├── add_post_modal.dart            # Screen 12
    │       └── edit_post_modal.dart           # Screen 13
    │
    ├── reports/
    │   ├── screens/
    │   │   └── reports_tab.dart               # Screen 5
    │   └── widgets/
    │       ├── profit_card.dart
    │       ├── revenue_breakdown_card.dart
    │       ├── spend_analysis_card.dart
    │       ├── burn_rate_card.dart
    │       └── performance_days_card.dart
    │
    ├── ai/
    │   ├── screens/
    │   │   └── ai_quick_start_modal.dart      # Screen 18
    │   └── widgets/
    │       ├── ai_question_card.dart
    │       └── ai_loading_state.dart          # Screen 30
    │
    ├── settings/
    │   ├── screens/
    │   │   ├── settings_screen.dart           # Screen 34
    │   │   └── platform_management_screen.dart # Screen 16
    │   └── widgets/
    │       └── settings_tile.dart
    │
    └── shared/
        ├── widgets/
        │   ├── empty_state.dart               # Screens 21-25
        │   ├── delete_confirmation_dialog.dart # Screens 15, 26-28
        │   ├── success_toast.dart             # Screen 29
        │   ├── error_state.dart               # Screen 31
        │   ├── export_modal.dart              # Screen 32
        │   ├── bulk_actions_modal.dart        # Screen 33
        │   ├── quick_actions_menu.dart        # Screen 19
        │   ├── add_spend_modal.dart           # Screen 17
        │   ├── time_filter_pills.dart
        │   └── offline_banner.dart
        └── layouts/
            └── scaffold_with_nav.dart         # Bottom navigation wrapper
```

---

## Implementation Phases

### Phase 1: Foundation Setup
**Goal:** Set up project infrastructure and dependencies

**Implementation Notes - What NOT To Do:**
```
BAD: Hardcoding Supabase credentials in Dart files
GOOD: Use .env file with flutter_dotenv package

BAD: Creating new UI components from scratch
GOOD: Use existing GOL design system components

BAD: Storing auth tokens in SharedPreferences without encryption
GOOD: Use Supabase's built-in session management (handles token refresh)

BAD: Skipping Drift database setup "to do later"
GOOD: Set up local DB from the start - it's foundational for offline

BAD: Making everything async without error handling
GOOD: Wrap async calls in try-catch, handle SupabaseException

BAD: Testing only happy path
GOOD: Test login with wrong password, test signup with existing email
```

**Tasks:**
1. Add dependencies to pubspec.yaml:
   - `flutter_riverpod` - State management
   - `supabase_flutter` - Backend
   - `drift` + `sqlite3_flutter_libs` - Local database
   - `go_router` - Navigation
   - `connectivity_plus` - Network detection
   - `http` - For OpenRouter API
   - `uuid` - Generate unique IDs
   - `intl` - Date/currency formatting
   - `shared_preferences` - Simple key-value storage

2. Create Supabase project and configure:
   - Create tables matching schema
   - Set up Row Level Security (RLS) policies
   - Configure auth providers (email/password)

3. Set up Drift local database:
   - Define tables mirroring Supabase schema
   - Create DAOs for each table
   - Generate database code

4. Implement core services:
   - Connectivity monitoring
   - Sync queue management
   - Auth service wrapper

**Deliverables:**
- Working Supabase connection
- Local database operational
- Basic sync infrastructure
- Auth flow (login/signup)

---

### Phase 2: Core Flow - Dashboard & Tracker CRUD
**Goal:** Build the main user journey from dashboard to tracker creation

**Implementation Notes - What NOT To Do:**
```
BAD: Using emojis in the UI (like "📊" for dashboard icon)
GOOD: Use Iconsax icons (Iconsax.chart, Iconsax.add_circle, etc.)

BAD: Showing "Loading..." text forever when offline
GOOD: Check connectivity, show cached data with "Offline mode" banner

BAD: Allowing user to create 21st tracker without validation
GOOD: Check tracker count BEFORE showing create form, show limit reached message

BAD: Storing tracker ID as int (autoincrement)
GOOD: Use UUID for all IDs (works offline, syncs properly)

BAD: Navigation using Navigator.push with hardcoded routes
GOOD: Use go_router with named routes and type-safe parameters

BAD: Building custom cards, buttons, inputs
GOOD: Use GOLCard, GOLButton, GOLTextField from design system

BAD: Allowing empty tracker name
GOOD: Validate: min 3 characters, max 50 characters

BAD: Not handling duplicate tracker creation (user taps Save twice)
GOOD: Disable button after tap, show loading, prevent double-submit
```

**Screens to Build:**
- Screen 1: Performance Dashboard
- Screen 2: Create Tracker (manual only - AI deferred)
- Screen 3: Tracker Hub - Overview Tab
- Screen 21: Dashboard Empty State
- Screen 29: Success Toast
- Screen 35: Trackers List View

**Tasks:**
1. Implement navigation with go_router:
   - Bottom navigation (Dashboard, Trackers, Settings)
   - Screen routing with parameters

2. Build Dashboard (Screen 1):
   - Performance overview card
   - Quick actions row
   - Recent tracker card
   - Top/worst projects lists
   - FAB for creating tracker

3. Build Create Tracker (Screen 2):
   - Form with all fields from wireframe
   - Platform selection (Facebook, TikTok - hardcoded)
   - Currency dropdown (default: CFA)
   - Goal chips (optional)
   - NO AI Quick Start in this phase (deferred)

4. Build Tracker Hub Overview (Screen 3):
   - Tab structure (Overview, Daily Entries, Reports)
   - Key metrics display
   - Recent entries list
   - Posts section (optional)

**Deliverables:**
- User can sign up/login
- User can view empty dashboard
- User can create tracker manually
- User can view tracker hub

---

### Phase 3: Daily Entry Flow
**Goal:** Enable daily performance logging

**Implementation Notes - What NOT To Do:**
```
BAD: Allowing entry date = tomorrow or any future date
GOOD: Date picker maxDate = DateTime.now() (today)

BAD: Allowing two entries for same date silently (overwriting)
GOOD: Check if entry exists, show "Entry already exists for this date" error

BAD: Calculating profit in the UI layer
GOOD: Calculate in repository/model layer: profit = revenue - facebookSpend - tiktokSpend

BAD: Using double for money calculations (floating point errors)
GOOD: Store as integer (FCFA has no decimals) or use Decimal package

BAD: Showing "500.00 FCFA" for CFA amounts
GOOD: Show "500 FCFA" - no decimals for CFA currency

BAD: Letting negative revenue or spend pass validation
GOOD: Validate: amount >= 0, show error for negative input

BAD: Not disabling platform spend fields for platforms not in tracker
GOOD: Only show spend fields for Facebook and TikTok (hardcoded platforms)

BAD: Saving entry without showing confirmation
GOOD: Show success toast "Entry logged successfully" using showGOLToast

BAD: Date selector showing MM/DD/YYYY format
GOOD: Use DD/MM/YYYY format (West African standard)
```

**Screens to Build:**
- Screen 7: Log Daily Entry
- Screen 8: Entry Detail View
- Screen 9: Edit Entry
- Screen 4: Daily Entries Tab
- Screen 10: Entry History
- Screen 17: Add Platform Spend Row
- Screen 22: Entries Empty State
- Screen 26: Delete Entry Confirmation

**Tasks:**
1. Build Log Entry form (Screen 7):
   - Date selector with navigation
   - Revenue input
   - Dynamic platform spend rows
   - DMs/Leads counter
   - Auto-calculated profit display
   - Save with offline support

2. Build Entry Detail (Screen 8):
   - Read-only view of entry
   - Profit breakdown
   - Platform spend breakdown
   - Edit/Delete/Duplicate actions

3. Build Edit Entry (Screen 9):
   - Pre-filled form from existing entry
   - Save changes

4. Build Daily Entries Tab (Screen 4):
   - Summary stats
   - Filter pills (This Week, This Month, All Time)
   - Entry list grouped by date
   - FAB for quick entry

5. Build Entry History (Screen 10):
   - Complete chronological list
   - Search/filter functionality

**Deliverables:**
- User can log daily entries with platform spend
- User can view entry history
- User can edit/delete entries
- Offline entry logging works

---

### Phase 4: Reports & Analytics
**Goal:** Show performance reports and insights

**Implementation Notes - What NOT To Do:**
```
BAD: Calculating ROI as "spend / revenue" (inverted formula)
GOOD: ROI = ((revenue - spend) / spend) * 100, handle spend=0 edge case

BAD: Division by zero when spend is 0 (crashes app)
GOOD: if (spend == 0) return "N/A" or infinity symbol or "0 spend"

BAD: "This Week" showing rolling 7 days
GOOD: Show Monday-Sunday of current calendar week

BAD: Showing profit as positive when it's actually a loss
GOOD: Color code: green for profit (> 0), red for loss (< 0)

BAD: Using local time without considering WAT timezone
GOOD: Store all dates in UTC, display in WAT (UTC+1)

BAD: Export creating empty file when no entries exist
GOOD: Show error "No data to export" or disable export button

BAD: Burn rate showing NaN when no entries
GOOD: Show "No data yet" for empty reports, not 0 or NaN
```

**Screens to Build:**
- Screen 5: Reports Tab

**Tasks:**
1. Build Reports Tab (Screen 5):
   - Time period selector (Daily, Weekly, Monthly)
   - Total Profit/Loss card
   - Revenue vs Spend breakdown
   - Worst performing days
   - Burn rate calculations
   - Cumulative profit trend
   - Export report button

2. Implement calculation logic:
   - Total profit = revenue - spend - setup costs
   - Burn rate = average daily spend
   - ROI = revenue / spend * 100
   - Best/worst days identification

**Deliverables:**
- Comprehensive reports view
- All calculations working correctly

---

### Phase 5: Post Management & Archive
**Goal:** Complete optional features

**Implementation Notes - What NOT To Do:**
```
BAD: Making posts required for tracker creation
GOOD: Posts are completely optional, can be added anytime

BAD: Allowing post deletion to affect revenue/profit calculations
GOOD: Posts are reference-only, have no financial impact

BAD: Allowing edits on archived tracker
GOOD: Archive = read-only mode, disable all edit buttons/forms

BAD: Permanently deleting tracker without confirmation
GOOD: Show confirmation dialog, require name re-entry for extra safety

BAD: Counting archived trackers toward 20 limit
GOOD: Only active trackers count, user can archive to free up slots

BAD: Restoring archived tracker when user already has 20 active
GOOD: Show error "You have 20 active trackers, archive one first"
```

**Screens to Build:**
- Screen 11: Posts List
- Screen 12: Add Post Modal
- Screen 13: Edit/Delete Post Modal
- Screen 23: Posts Empty State
- Screen 27: Delete Post Confirmation
- Screen 6: Archive View
- Screen 24: Archive Empty State

**Tasks:**
1. Build Posts feature:
   - Posts list within Overview tab
   - Add/Edit/Delete post modals
   - Platform badges

2. Build Archive feature:
   - Archive view screen
   - Restore from archive
   - Archive action in tracker menu

**Deliverables:**
- Post management functional
- Archive/restore working

---

### Phase 6: Settings & Management
**Goal:** Complete settings and management screens

**Implementation Notes - What NOT To Do:**
```
BAD: Logout not clearing local data
GOOD: Clear Drift database, SharedPreferences, auth session on logout

BAD: Showing user email but not allowing password change
GOOD: Email change → Supabase handles this, show "Change password" link

BAD: Bulk edit saving partial changes on error
GOOD: Transaction: save all or rollback all changes together

BAD: Delete confirmation with just "Are you sure?" button
GOOD: Require typing tracker name to confirm (prevents accidental deletion)

BAD: Allowing reminder time as freeform text
GOOD: Use time picker, validate 00:00-23:59 range

BAD: Not showing "pending sync" count in settings
GOOD: Show "X changes pending sync" when offline edits exist
```

**Screens to Build:**
- Screen 14: Edit Tracker Settings
- Screen 15: Delete Tracker Confirmation
- Screen 16: Platform Management
- Screen 19: Quick Actions Menu
- Screen 20: Historical Data Edit
- Screen 28: Delete Platform Confirmation
- Screen 31: General Error State
- Screen 32: Export Success Modal
- Screen 33: Bulk Actions Modal
- Screen 34: Settings Page
- Screen 25: Entry History Empty State

**Tasks:**
1. Build Settings (Screen 34):
   - User profile section
   - Currency preference
   - Logout functionality

2. Build Edit Tracker (Screen 14):
   - Pre-filled form
   - Platform management link
   - Save changes

3. Build Platform Management (Screen 16):
   - Active platforms list
   - Add/remove platforms
   - Reorder functionality

4. Build Historical Data Edit (Screen 20):
   - Bulk selection
   - Inline editing
   - Save all changes

5. Implement modals and dialogs:
   - Quick actions menu
   - Delete confirmations
   - Export modal
   - Bulk actions

**Deliverables:**
- Complete settings functionality
- All management screens working
- All modals and dialogs implemented

---

### Phase 7: Polish & Sync
**Goal:** Complete offline sync and polish

**Implementation Notes - What NOT To Do:**
```
BAD: Syncing on every data change (battery drain, data usage)
GOOD: Batch sync on app resume, manual "Sync now" button, Wi-Fi only option

BAD: Silent sync failures with no user feedback
GOOD: Show "Sync failed - tap to retry" with error details

BAD: Push notification without checking if user enabled them
GOOD: Check notification permission, respect user_preferences.reminder_enabled

BAD: Overwriting newer server data with older offline changes
GOOD: Compare updated_at timestamps, last-write-wins by timestamp

BAD: Showing raw sync queue count like "37 pending operations"
GOOD: Show friendly message: "5 entries waiting to sync"

BAD: Notification arriving while user is in-app
GOOD: Suppress notification if app is in foreground

BAD: Not testing with airplane mode enabled
GOOD: Test full offline flow: create entry offline, turn on Wi-Fi, verify sync
```

**Tasks:**
1. Complete sync engine:
   - Queue management
   - Conflict resolution (last-write-wins or custom)
   - Sync status indicators
   - Background sync

2. Add offline UI indicators:
   - Offline banner
   - Sync status in relevant screens
   - Pending changes indicator

3. Error handling:
   - Network errors
   - Sync failures
   - Validation errors

4. Performance optimization:
   - Lazy loading for lists
   - Image/data caching
   - Memory management

5. Testing:
   - Unit tests for business logic
   - Widget tests for key screens
   - Integration tests for critical flows

**Deliverables:**
- Robust offline support
- Smooth sync experience
- Production-ready app

---

### Phase 8: AI Features (DEFERRED - Future Enhancement)
**Goal:** Add AI-powered quick start for tracker creation

**Note:** This phase is intentionally deferred. The app must be fully functional with manual flows before adding AI features.

**Prerequisites:**
- Phases 1-7 complete and tested
- Core manual flow works perfectly
- User explicitly requests AI feature

**Screens to Build (when ready):**
- Screen 18: AI Quick Start Modal
- Screen 30: AI Loading State

**Implementation (when ready):**
- OpenRouter API integration
- GPT-4 for natural language processing
- Conversational question flow
- Pre-fill tracker form from AI response

**Not Included in v1:**
- AI suggestions for entries
- AI-generated reports insights
- Any feature that relies on AI to work

---

## Push Notifications (Daily Reminders)

### Implementation Strategy
- **Service:** Firebase Cloud Messaging (FCM) for both Android & iOS
- **Purpose:** Daily reminders to track earnings/performance
- **Trigger:** Supabase Edge Function + Firebase Admin SDK

### Notification Flow
```
1. User sets reminder time in Settings (e.g., 8:00 PM daily)
2. Preference stored in Supabase user_preferences table
3. Supabase scheduled Edge Function runs hourly
4. Function checks which users need reminders now
5. Sends FCM push to those users' device tokens
6. User receives: "Time to log today's performance!"
```

### Required Setup
1. Create Firebase project (for FCM only, not database)
2. Add `firebase_messaging` package
3. Configure Android (google-services.json)
4. Configure iOS (APNs certificate + GoogleService-Info.plist)
5. Store FCM tokens in Supabase `user_devices` table
6. Create Supabase Edge Function for scheduled sends

### New Table for Notifications
```sql
create table user_preferences (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade unique,
  reminder_enabled boolean default true,
  reminder_time time default '20:00:00',
  timezone text default 'UTC',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table user_devices (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  fcm_token text not null,
  device_type text, -- 'android' or 'ios'
  created_at timestamptz default now(),
  unique(user_id, fcm_token)
);
```

---

## OpenRouter AI Integration

### Configuration
```dart
// lib/core/config/openrouter_config.dart
class OpenRouterConfig {
  static const String baseUrl = 'https://openrouter.ai/api/v1';
  static const String model = 'openai/gpt-4-turbo'; // GPT-4.1 via OpenRouter
  // API key stored in environment/secure storage
}
```

### AI Quick Start Flow
1. User taps "Quick Start with AI"
2. Modal shows conversational questions:
   - Q1: "What are you launching/promoting?"
   - Q2: "Which platforms will you focus on?"
   - Q3: "What's your revenue target?"
   - Q4: "What's your budget?"
   - Q5: "Any specific goals?"
3. Answers sent to OpenRouter
4. AI returns structured JSON with:
   - Suggested tracker name
   - Recommended platforms
   - Revenue/engagement targets
   - Goal chips
5. Pre-fill Create Tracker form

### Prompt Template
```
You are helping set up a performance tracker for a marketing campaign.

Based on the user's answers:
- Campaign: {answer1}
- Platforms: {answer2}
- Revenue target: {answer3}
- Budget: {answer4}
- Goals: {answer5}

Generate a JSON response with:
{
  "name": "suggested tracker name",
  "platforms": ["YOUTUBE", "INSTAGRAM", ...],
  "revenue_target": 10000,
  "engagement_target": 500,
  "setup_cost": 200,
  "goal_types": ["PRODUCT_LAUNCH", "LEAD_GENERATION"],
  "currency": "USD"
}
```

---

## Supabase Setup

### Tables SQL
```sql
-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Trackers table
create table trackers (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  start_date date not null,
  currency text not null default 'USD',
  revenue_target decimal,
  engagement_target integer,
  setup_cost decimal default 0,
  growth_cost_monthly decimal default 0,
  notes text,
  is_archived boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Daily entries table
create table daily_entries (
  id uuid primary key default uuid_generate_v4(),
  tracker_id uuid references trackers(id) on delete cascade not null,
  entry_date date not null,
  total_revenue decimal not null,
  total_dms_leads integer not null default 0,
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique(tracker_id, entry_date)
);

-- Entry platform spends table
create table entry_platform_spends (
  id uuid primary key default uuid_generate_v4(),
  entry_id uuid references daily_entries(id) on delete cascade not null,
  platform text not null,
  amount decimal not null default 0,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique(entry_id, platform)
);

-- Tracker platforms table
create table tracker_platforms (
  id uuid primary key default uuid_generate_v4(),
  tracker_id uuid references trackers(id) on delete cascade not null,
  platform text not null,
  display_order integer default 0,
  created_at timestamptz default now(),
  unique(tracker_id, platform)
);

-- Posts table
create table posts (
  id uuid primary key default uuid_generate_v4(),
  tracker_id uuid references trackers(id) on delete cascade not null,
  title text not null,
  platform text not null,
  url text,
  published_date date,
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Tracker goals table
create table tracker_goals (
  id uuid primary key default uuid_generate_v4(),
  tracker_id uuid references trackers(id) on delete cascade not null,
  goal_type text not null,
  created_at timestamptz default now()
);

-- Row Level Security
alter table trackers enable row level security;
alter table daily_entries enable row level security;
alter table entry_platform_spends enable row level security;
alter table tracker_platforms enable row level security;
alter table posts enable row level security;
alter table tracker_goals enable row level security;

-- Policies (users can only access their own data)
create policy "Users can manage own trackers"
  on trackers for all using (auth.uid() = user_id);

create policy "Users can manage own entries"
  on daily_entries for all using (
    tracker_id in (select id from trackers where user_id = auth.uid())
  );

-- (Similar policies for other tables...)
```

---

## Key Dependencies (pubspec.yaml additions)

```yaml
dependencies:
  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

  # Backend & Auth
  supabase_flutter: ^2.3.0

  # Local Database (Offline-first)
  drift: ^2.14.1
  sqlite3_flutter_libs: ^0.5.18

  # Navigation
  go_router: ^13.0.0

  # Networking & Connectivity
  connectivity_plus: ^5.0.2
  http: ^1.1.2

  # Push Notifications
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.10
  flutter_local_notifications: ^16.3.0

  # Utilities
  uuid: ^4.2.2
  intl: ^0.18.1
  shared_preferences: ^2.2.2
  path_provider: ^2.1.1
  path: ^1.8.3
  timezone: ^0.9.2

dev_dependencies:
  drift_dev: ^2.14.1
  build_runner: ^2.4.7
  riverpod_generator: ^2.3.9
```

---

## Supabase Project Setup Guide

### Step 1: Create Supabase Project
1. Go to https://supabase.com and sign up/login
2. Click "New Project"
3. Choose organization or create new
4. Fill in:
   - **Name:** performance-tracker (or your choice)
   - **Database Password:** Generate strong password (save it!)
   - **Region:** Choose closest to your users
5. Click "Create new project" and wait ~2 minutes

### Step 2: Get Connection Credentials
1. Go to Project Settings → API
2. Copy these values:
   - **Project URL** (e.g., https://xxxx.supabase.co)
   - **anon/public key** (for client-side use)
   - **service_role key** (for Edge Functions - keep secret!)

### Step 3: Run Database Schema
1. Go to SQL Editor in Supabase dashboard
2. Create new query
3. Paste the complete SQL from "Supabase Setup" section below
4. Run the query

### Step 4: Configure Auth
1. Go to Authentication → Providers
2. Ensure Email provider is enabled
3. Configure email templates if desired
4. Set Site URL to your app's deep link (for password reset)

### Step 5: Set Up Row Level Security
The SQL schema already includes RLS policies. Verify they're active:
1. Go to Table Editor
2. Click on each table
3. Verify "RLS Enabled" is shown

### Step 6: Configure for Flutter App
Create `.env` file in your Flutter project root:
```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
OPENROUTER_API_KEY=your-openrouter-key
```

---

## Firebase Setup (For Push Notifications Only)

### Step 1: Create Firebase Project
1. Go to https://console.firebase.google.com
2. Click "Add project"
3. Name: "performance-tracker" (or match your app name)
4. Disable Google Analytics (not needed for FCM)
5. Create project

### Step 2: Add Android App
1. Click Android icon in Firebase console
2. Package name: `com.yourcompany.performancetracker`
3. Download `google-services.json`
4. Place in `bride_app/android/app/`

### Step 3: Add iOS App (if targeting iOS)
1. Click iOS icon in Firebase console
2. Bundle ID: `com.yourcompany.performancetracker`
3. Download `GoogleService-Info.plist`
4. Place in `bride_app/ios/Runner/`
5. Configure APNs in Firebase → Project Settings → Cloud Messaging

### Step 4: Android Configuration
Add to `android/build.gradle`:
```groovy
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

Add to `android/app/build.gradle`:
```groovy
apply plugin: 'com.google.gms.google-services'
```

### Step 5: iOS Configuration
Add to `ios/Runner/AppDelegate.swift`:
```swift
import FirebaseCore
import FirebaseMessaging

// In application didFinishLaunchingWithOptions:
FirebaseApp.configure()
```

---

## Critical Files to Create First

1. `lib/core/config/supabase_config.dart` - Supabase initialization
2. `lib/data/local/database.dart` - Drift database definition
3. `lib/providers/auth_provider.dart` - Authentication state
4. `lib/providers/connectivity_provider.dart` - Network status
5. `lib/routing/app_router.dart` - Navigation setup
6. `lib/features/shared/layouts/scaffold_with_nav.dart` - Bottom nav wrapper

---

---

## Edge Cases & Business Rules

### Currency & Amounts
| Rule | Decision |
|------|----------|
| Default currency | Franc CFA (XOF) |
| CFA decimal places | 0 (show "500 FCFA" not "500.00 FCFA") |
| Other currencies | 2 decimal places |
| Max entry amount | 100,000,000 FCFA (~$160,000 USD) |
| Min amount | 0 (zero is valid) |
| Negative amounts | NOT allowed for revenue/spend |

### Tracker Limits
| Rule | Decision |
|------|----------|
| Max active trackers | 20 per user (hard limit) |
| Archived trackers | Don't count toward 20 limit |
| Max platforms per tracker | 2 initially (Facebook, TikTok hardcoded) |
| Duplicate tracker names | Allowed |
| Copy/duplicate tracker | Yes - copies settings, not entries |

### Entry Rules
| Rule | Decision |
|------|----------|
| Entries before tracker start date | Allowed (backfill historical) |
| Future date entries | NOT allowed (today or past only) |
| Multiple entries same date | NOT allowed (one per day per tracker) |
| Empty entry (0 revenue, 0 spend) | Allowed |

### Platform Management
| Rule | Decision |
|------|----------|
| Default platforms | Facebook, TikTok (hardcoded initially) |
| Custom platforms | NOT in v1 (add later) |
| Remove platform from tracker | Hide from new entries, keep historical data |
| Platform spend deleted | NO - preserve for reports |

### Sync & Offline
| Rule | Decision |
|------|----------|
| Conflict resolution | Last-write-wins (by timestamp) |
| First use without internet | Block - require login first |
| Offline capabilities | View data, create entries, edit (queued) |
| Online-only features | Login, signup, initial sync, AI features |

### Time & Region
| Rule | Decision |
|------|----------|
| Target region | West/Central Africa |
| Default timezone | WAT (West Africa Time, UTC+1) |
| Date format | DD/MM/YYYY |
| "This Week" definition | Monday to Sunday (calendar week) |

### Notifications
| Rule | Decision |
|------|----------|
| Default reminder | Enabled (user can disable in settings) |
| Missed days behavior | Same reminder daily |
| Reminder time | User configurable (default 8:00 PM local) |

### Archive
| Rule | Decision |
|------|----------|
| Archived tracker editable | NO - read only |
| New entries on archived | NOT allowed |
| Restore from archive | Yes - becomes active again |
| Delete archived permanently | Yes (with confirmation) |

---

## Success/Failure Criteria per Phase

### Phase 1: Foundation Setup
**Success:**
- [ ] Flutter app runs with no errors
- [ ] Supabase connection established (test query works)
- [ ] Local Drift database creates tables on first run
- [ ] User can sign up with email/password
- [ ] User can log in and stays logged in (session persists)
- [ ] Logged-in user sees their user ID from Supabase

**Failure (Rejection Criteria):**
- App crashes on launch
- Database tables not created
- Auth flow doesn't complete
- Session doesn't persist after app restart

### Phase 2: Core Flow
**Success:**
- [ ] Empty dashboard shows empty state with "Create First Tracker" CTA
- [ ] User can create tracker with name, start date, platforms, currency
- [ ] Created tracker appears on dashboard
- [ ] Tracker Hub opens with Overview tab showing correct data
- [ ] Navigation between screens works correctly
- [ ] Data persists after app restart

**Failure (Rejection Criteria):**
- Dashboard shows error instead of empty state
- Tracker creation fails silently
- Created tracker doesn't appear
- Navigation crashes or shows wrong screen

### Phase 3: Daily Entry Flow
**Success:**
- [ ] User can log entry with date, revenue, spend per platform, DMs
- [ ] Profit auto-calculates (revenue - total spend)
- [ ] Entry appears in Entries Tab chronologically
- [ ] User can edit existing entry
- [ ] User can delete entry (with confirmation)
- [ ] Validation prevents future dates
- [ ] Validation prevents duplicate dates for same tracker
- [ ] Offline entry creation queues for sync

**Failure (Rejection Criteria):**
- Entry saves but data is wrong
- Profit calculation is incorrect
- Future date entry is allowed
- Duplicate date entry is allowed
- App crashes on entry submission

### Phase 4: Reports & Analytics
**Success:**
- [ ] Total profit/loss shows correctly
- [ ] Revenue vs Spend breakdown accurate
- [ ] Burn rate calculation correct
- [ ] Best/worst days identified correctly
- [ ] Time period filters work (Daily/Weekly/Monthly)
- [ ] Export generates valid CSV file

**Failure (Rejection Criteria):**
- Calculations don't match manual verification
- Division by zero errors
- Filter shows wrong date range
- Export file corrupted or empty

### Phase 5: Posts & Archive
**Success:**
- [ ] User can add/edit/delete posts
- [ ] Posts display in Overview tab
- [ ] User can archive tracker from menu
- [ ] Archived tracker appears in Archive view
- [ ] Archived tracker is read-only
- [ ] User can restore from archive

**Failure (Rejection Criteria):**
- Posts don't save
- Archive action doesn't work
- User can edit archived tracker

### Phase 6: Settings & Management
**Success:**
- [ ] Settings page shows user info
- [ ] User can change reminder preferences
- [ ] User can log out
- [ ] Bulk edit saves all changes correctly
- [ ] Delete confirmations require explicit action
- [ ] 20 tracker limit enforced

**Failure (Rejection Criteria):**
- Settings don't persist
- Logout doesn't clear session
- Bulk edit corrupts data
- User can create 21st tracker

### Phase 7: Polish & Sync
**Success:**
- [ ] Offline indicator shows when disconnected
- [ ] Changes made offline sync when connected
- [ ] No data loss during sync
- [ ] Push notifications arrive at scheduled time
- [ ] App handles network errors gracefully

**Failure (Rejection Criteria):**
- Data lost during sync
- Notifications don't arrive
- App crashes on network error

---

## Notes

- **Design System:** Use existing GOL components exclusively (don't create new base components)
- **Icons:** Use Iconsax outline variants by default, NO emojis in UI
- **Offline-First:** Always write to local DB first, then sync to Supabase
- **Error Handling:** Graceful degradation when offline
- **Theme:** Already configured for light/dark mode, use semantic colors
- **Currency Default:** Franc CFA (XOF) with no decimal places
- **Region:** West/Central Africa, WAT timezone, DD/MM/YYYY format
- **AI Features:** Deferred to later phase - manual flow is the priority

---

## Key Reference Files

| File | Purpose |
|------|---------|
| `IMPLEMENTATION_PLAN.md` | What to build, progress tracking |
| `performance-section-wireframe.md` | Screen designs & layouts |
| `performance-architech.md` | Navigation flows & user journeys |
| `CLAUDE.md` | Development guidelines & rules |
