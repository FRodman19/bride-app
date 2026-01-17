# 🚀 Migration to Online-First Architecture Plan

**Date Created:** January 17, 2026
**User to Rescue:** frankwultof@gmail.com (only active user)
**Goal:** Save user data + Migrate to complete online-first solution
**Strategy:** No offline-first, everything syncs directly to Supabase

---

## 📋 **PHASE 1: Emergency Data Recovery**

⏱️ **Estimated Time:** 2-3 hours
🎯 **Goal:** Upload ALL local data from frankwultof@gmail.com to Supabase

### **Tasks:**
1. Create data recovery admin script
2. Scan local database for all data
3. Upload missing data to Supabase
4. Verify data integrity

### **Acceptance Criteria:**
- [ ] Script successfully connects to local database
- [ ] All trackers from local DB are in Supabase
- [ ] All entries (including post-06/01/2026) are in Supabase
- [ ] All posts/spends/goals are in Supabase
- [ ] User can log in on NEW device and see ALL data
- [ ] No data loss detected (compare counts: local vs Supabase)
- [ ] Script generates detailed report of uploaded data

### **Rejection Criteria (Must Fix Before Proceeding):**
- ❌ Any data missing from Supabase
- ❌ Data corruption during upload
- ❌ Script fails with errors
- ❌ User cannot see data on new device

### **Implementation Checklist:**
- [ ] Create `lib/services/data_recovery_service.dart`
- [ ] Add method to fetch all local data
- [ ] Add method to check if data exists in Supabase
- [ ] Add method to upload missing data
- [ ] Add progress reporting
- [ ] Add error handling and rollback
- [ ] Test on dev account first
- [ ] Run on frankwultof@gmail.com account
- [ ] Generate recovery report

### **Verification Instructions:**
```bash
# After Phase 1 completion, run this command:
# This will trigger code review agent to verify Phase 1
flutter test test/phase1_verification_test.dart
```

### **CHECKPOINT 1: Code Review Verification**

**Code Review Agent Will Check:**
1. ✅ All data recovery code is correct
2. ✅ No data loss risks in implementation
3. ✅ Error handling is comprehensive
4. ✅ Recovery report shows 100% data uploaded
5. ✅ User can access data on new device
6. ✅ No security vulnerabilities in script
7. ✅ Code follows project conventions

**Required for Approval:**
- All 7 checks must pass ✅
- User data verified in Supabase
- Recovery report reviewed and approved

**If Checkpoint Fails:**
- Return to Phase 1 tasks
- Fix identified issues
- Re-run checkpoint

**Only proceed to Phase 2 after Checkpoint 1 approval ✅**

---

## 📋 **PHASE 2: Implement Online-First Architecture**

⏱️ **Estimated Time:** 2-3 days
🎯 **Goal:** Replace offline-first with direct Supabase operations

### **Tasks:**
1. Update TrackerProvider to use direct Supabase calls
2. Update EntryProvider to use direct Supabase calls
3. Update PostProvider to use direct Supabase calls
4. Add real-time Supabase subscriptions
5. Update UI to handle online-only operations

### **Acceptance Criteria:**
- [ ] Creating tracker writes directly to Supabase (no local-first)
- [ ] Creating entry writes directly to Supabase (no local-first)
- [ ] Updating data writes directly to Supabase
- [ ] Deleting data deletes from Supabase immediately
- [ ] Changes appear on other devices in real-time (< 2 seconds)
- [ ] No `needsSync` flags in code (removed)
- [ ] No sync queue processing (removed)
- [ ] All CRUD operations go to Supabase first
- [ ] Local database used ONLY for caching reads (optional)
- [ ] App shows proper error when offline

### **Rejection Criteria:**
- ❌ Any operation still uses offline-first pattern
- ❌ Sync queue still exists
- ❌ `needsSync` flags still in code
- ❌ Data doesn't appear on other devices
- ❌ No error handling for offline state
- ❌ Race conditions in concurrent operations

### **Implementation Checklist:**

**2.1: Update TrackerProvider**
- [ ] Remove local-first creation logic
- [ ] Replace with direct Supabase insert
- [ ] Update tracker updates to go to Supabase first
- [ ] Add optimistic UI updates
- [ ] Add error handling
- [ ] Test create/update/delete operations

**2.2: Update EntryProvider**
- [ ] Remove local-first entry creation
- [ ] Replace with direct Supabase insert
- [ ] Add real-time entry updates
- [ ] Handle offline errors gracefully
- [ ] Test daily entry flow

**2.3: Update PostProvider**
- [ ] Remove local-first post creation
- [ ] Replace with direct Supabase operations
- [ ] Add real-time sync
- [ ] Test post creation flow

**2.4: Add Real-Time Subscriptions**
- [ ] Subscribe to tracker changes
- [ ] Subscribe to entry changes
- [ ] Subscribe to post changes
- [ ] Update UI automatically on changes
- [ ] Handle subscription errors

**2.5: Update UI Components**
- [ ] Show loading states during Supabase operations
- [ ] Show error messages when offline
- [ ] Add retry buttons for failed operations
- [ ] Remove sync progress indicators (no longer needed)

### **Files to Modify:**
- `lib/providers/tracker_provider.dart`
- `lib/providers/entry_provider.dart`
- `lib/providers/post_provider.dart`
- `lib/features/tracker/screens/create_tracker_screen.dart`
- `lib/features/tracker/screens/edit_tracker_screen.dart`
- `lib/features/tracker/screens/log_entry_screen.dart`

### **Verification Instructions:**
```bash
# After Phase 2 completion, run:
flutter test test/phase2_verification_test.dart
flutter analyze
```

### **CHECKPOINT 2: Code Review Verification**

**Code Review Agent Will Check:**
1. ✅ No offline-first patterns remain
2. ✅ All operations write to Supabase directly
3. ✅ Real-time sync is working
4. ✅ Error handling is comprehensive
5. ✅ No sync queue code remains
6. ✅ No `needsSync` flags in codebase
7. ✅ UI shows proper feedback for all states
8. ✅ Multi-device sync works (< 2 second latency)
9. ✅ Code quality and conventions maintained
10. ✅ No security vulnerabilities introduced

**Required for Approval:**
- All 10 checks must pass ✅
- Manual testing confirms real-time sync works
- Performance is acceptable (< 500ms for operations)

**If Checkpoint Fails:**
- Fix identified issues
- Re-run verification
- Do NOT proceed until approved

**Only proceed to Phase 3 after Checkpoint 2 approval ✅**

---

## 📋 **PHASE 3: Remove Offline-First Infrastructure**

⏱️ **Estimated Time:** 1 day
🎯 **Goal:** Clean up all offline-first code and dependencies

### **Tasks:**
1. Delete SyncProvider completely
2. Delete SyncDAO and sync queue table
3. Remove `needsSync` columns from database
4. Remove sync-related UI components
5. Update database schema
6. Clean up unused dependencies

### **Acceptance Criteria:**
- [ ] `lib/providers/sync_provider.dart` deleted
- [ ] `lib/data/local/daos/sync_dao.dart` deleted
- [ ] `lib/data/local/tables/sync_queue_table.dart` deleted
- [ ] `needsSync` column removed from all tables
- [ ] Sync button removed from settings
- [ ] Offline banner removed (or updated for online-only)
- [ ] No sync-related dependencies in `pubspec.yaml`
- [ ] Database migration created for schema changes
- [ ] App size reduced (less code)
- [ ] No sync-related imports in any file

### **Rejection Criteria:**
- ❌ Any sync-related code remains
- ❌ `needsSync` references still exist
- ❌ Sync dependencies not removed
- ❌ Database migration missing
- ❌ Broken imports due to deletions

### **Implementation Checklist:**

**3.1: Delete Sync Files**
- [ ] Delete `lib/providers/sync_provider.dart`
- [ ] Delete `lib/data/local/daos/sync_dao.dart`
- [ ] Delete `lib/data/local/tables/sync_queue_table.dart`
- [ ] Delete any sync helper utilities

**3.2: Update Database Schema**
- [ ] Remove `needsSync` from trackers_table
- [ ] Remove `needsSync` from entries_table
- [ ] Remove `needsSync` from posts_table
- [ ] Remove `syncStatus` columns
- [ ] Create migration file
- [ ] Test migration on dev database

**3.3: Update UI**
- [ ] Remove sync button from settings screen
- [ ] Remove sync progress indicators
- [ ] Update offline banner message
- [ ] Remove "Last synced" timestamps

**3.4: Clean Dependencies**
- [ ] Check `pubspec.yaml` for unused sync packages
- [ ] Run `flutter pub get`
- [ ] Verify no broken imports

### **Files to Modify/Delete:**
- ❌ DELETE: `lib/providers/sync_provider.dart`
- ❌ DELETE: `lib/data/local/daos/sync_dao.dart`
- ❌ DELETE: `lib/data/local/tables/sync_queue_table.dart`
- ✏️ MODIFY: `lib/data/local/tables/trackers_table.dart`
- ✏️ MODIFY: `lib/data/local/tables/entries_table.dart`
- ✏️ MODIFY: `lib/data/local/tables/posts_table.dart`
- ✏️ MODIFY: `lib/features/settings/screens/settings_screen.dart`
- ✏️ MODIFY: `lib/features/shared/widgets/offline_banner.dart`

### **Verification Instructions:**
```bash
# After Phase 3 completion, run:
flutter clean
flutter pub get
flutter analyze
flutter test test/phase3_verification_test.dart
```

### **CHECKPOINT 3: Code Review Verification**

**Code Review Agent Will Check:**
1. ✅ All sync files deleted
2. ✅ No sync-related code remains
3. ✅ Database schema updated correctly
4. ✅ Migration file created and tested
5. ✅ No broken imports
6. ✅ App builds successfully
7. ✅ UI updated (no sync buttons)
8. ✅ Reduced code complexity
9. ✅ No unused dependencies

**Required for Approval:**
- All 9 checks must pass ✅
- App runs without errors
- No references to deleted files

**If Checkpoint Fails:**
- Fix broken imports
- Complete missing deletions
- Re-run verification

**Only proceed to Phase 4 after Checkpoint 3 approval ✅**

---

## 📋 **PHASE 4: Error Handling & User Feedback**

⏱️ **Estimated Time:** 1 day
🎯 **Goal:** Ensure users understand online-only behavior

### **Tasks:**
1. Add comprehensive error handling
2. Show clear offline error messages
3. Add retry functionality
4. Add loading states for all operations
5. Add success confirmations
6. Add connection status indicator

### **Acceptance Criteria:**
- [ ] All Supabase operations have try-catch blocks
- [ ] Offline errors show user-friendly messages
- [ ] Network errors show retry option
- [ ] Loading states shown during operations
- [ ] Success messages confirm completed actions
- [ ] Connection status visible in app (online/offline indicator)
- [ ] No silent failures (all errors logged and shown)
- [ ] Timeout handling for slow connections

### **Rejection Criteria:**
- ❌ Any operation fails silently
- ❌ No user feedback during operations
- ❌ Confusing error messages
- ❌ No retry mechanism
- ❌ App crashes on network errors

### **Implementation Checklist:**

**4.1: Add Error Handling**
- [ ] Wrap all Supabase calls in try-catch
- [ ] Create centralized error handler
- [ ] Log all errors to console (debug mode)
- [ ] Show user-friendly error messages
- [ ] Different messages for different error types

**4.2: Add Loading States**
- [ ] Show spinner during create operations
- [ ] Show spinner during update operations
- [ ] Show spinner during delete operations
- [ ] Show progress for bulk operations
- [ ] Prevent duplicate submissions

**4.3: Add User Feedback**
- [ ] Success toasts for completed actions
- [ ] Error toasts for failures
- [ ] Confirmation dialogs for destructive actions
- [ ] Connection status in app bar

**4.4: Add Retry Mechanism**
- [ ] Retry button on error dialogs
- [ ] Auto-retry for transient failures (max 3 attempts)
- [ ] Exponential backoff for retries
- [ ] Cancel retry option

### **Error Types to Handle:**
- Network timeout
- No internet connection
- Supabase rate limiting
- Authentication token expired
- Invalid data format
- Database constraint violations
- Server errors (500)

### **Files to Modify:**
- `lib/providers/tracker_provider.dart`
- `lib/providers/entry_provider.dart`
- `lib/providers/post_provider.dart`
- `lib/core/utils/error_handler.dart` (NEW)
- `lib/widgets/connection_indicator.dart` (NEW)
- All UI screens with data operations

### **Verification Instructions:**
```bash
# After Phase 4 completion, run:
flutter test test/phase4_verification_test.dart

# Manual testing:
# 1. Turn off internet
# 2. Try to create tracker (should show error)
# 3. Turn on internet
# 4. Retry (should succeed)
```

### **CHECKPOINT 4: Code Review Verification**

**Code Review Agent Will Check:**
1. ✅ All operations have error handling
2. ✅ User-friendly error messages
3. ✅ Loading states implemented
4. ✅ Success confirmations shown
5. ✅ Retry mechanism works
6. ✅ Connection status indicator present
7. ✅ No silent failures
8. ✅ Proper timeout handling
9. ✅ Code quality maintained
10. ✅ No security issues in error messages

**Required for Approval:**
- All 10 checks must pass ✅
- Manual testing confirms good UX
- All error scenarios handled gracefully

**Production Readiness Checklist:**
- [ ] All phases completed and approved
- [ ] User data verified safe in Supabase
- [ ] Real-time sync working across devices
- [ ] Error handling comprehensive
- [ ] UI feedback clear and helpful
- [ ] Performance acceptable
- [ ] No known bugs
- [ ] Code reviewed and approved

**If Checkpoint Fails:**
- Complete missing error handling
- Improve error messages
- Re-run verification

**Only proceed to Phase 5 after Checkpoint 4 approval ✅**

---

## 📋 **PHASE 5: Deploy & Monitor**

⏱️ **Estimated Time:** 1 day
🎯 **Goal:** Production deployment with monitoring

### **Tasks:**
1. Create production build
2. Test on physical device
3. Deploy to production
4. Monitor for errors
5. Support user during transition

### **Acceptance Criteria:**
- [ ] Production build created successfully
- [ ] Tested on physical device (Pixel 9 Pro XL)
- [ ] User can access all data on new device
- [ ] App published/deployed
- [ ] Monitoring set up for errors
- [ ] User notified of changes

### **Rejection Criteria:**
- ❌ Production build fails
- ❌ App crashes on physical device
- ❌ User data inaccessible
- ❌ No error monitoring

### **Deployment Checklist:**
- [ ] Run `flutter build apk --release`
- [ ] Test release build on device
- [ ] Verify user data loads correctly
- [ ] Test all CRUD operations
- [ ] Test multi-device sync
- [ ] Monitor Supabase logs
- [ ] Monitor app crashes (if crash reporting enabled)
- [ ] Support user for 24-48 hours after deployment

### **Post-Deployment Monitoring:**
- Watch Supabase dashboard for errors
- Monitor user's account for issues
- Check app performance
- Verify real-time sync working

---

## 📊 **Overall Progress Tracking**

| Phase | Status | Checkpoint | Approved |
|-------|--------|-----------|----------|
| Phase 1: Data Recovery | ⬜ Not Started | ⬜ Pending | ⬜ No |
| Phase 2: Online-First | ⬜ Not Started | ⬜ Pending | ⬜ No |
| Phase 3: Cleanup | ⬜ Not Started | ⬜ Pending | ⬜ No |
| Phase 4: Error Handling | ⬜ Not Started | ⬜ Pending | ⬜ No |
| Phase 5: Deploy | ⬜ Not Started | N/A | N/A |

---

## 🎯 **Success Metrics**

### **User Data Safety:**
- ✅ 100% of user data in Supabase
- ✅ User can access data on any device
- ✅ No data loss during migration

### **Architecture Goals:**
- ✅ Zero offline-first code remaining
- ✅ All operations write to Supabase directly
- ✅ Real-time sync < 2 seconds
- ✅ Codebase complexity reduced

### **User Experience:**
- ✅ Clear error messages
- ✅ Loading states for all operations
- ✅ Retry functionality for failures
- ✅ Connection status visible

---

## 🚨 **Emergency Rollback Plan**

If critical issues occur during migration:

1. **Revert to previous commit:**
   ```bash
   git revert HEAD
   git push origin main
   ```

2. **Restore user data from backup:**
   - Supabase has automatic backups
   - Can restore from any point in time

3. **Notify user:**
   - Explain issue
   - Provide timeline for fix
   - Ensure data is safe

---

## 📝 **Notes**

- **User:** frankwultof@gmail.com is the ONLY active user
- **Decision:** Complete online-first (no offline support)
- **Reason:** Simpler, more reliable, ready for AI features
- **Trade-off:** Requires internet connection (acceptable for this app)

---

**Last Updated:** January 17, 2026
**Status:** Ready to begin Phase 1
