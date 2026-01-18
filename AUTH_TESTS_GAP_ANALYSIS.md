# Sign In/Sign Up Tests - Detailed Gap Analysis

## Side-by-Side Comparison

### Edit Profile Tests vs Sign In/Sign Up Tests

```
┌─────────────────────────────────────────────────────────────────┐
│ EDIT PROFILE                    │ SIGN IN/SIGN UP              │
├─────────────────────────────────────────────────────────────────┤
│ 12 Tests                        │ 5 Tests                      │
│ 250 lines of code               │ 50 lines of code             │
│ ✓ Happy path                    │ ✓ Happy path (minimal)       │
│ ✓ Error scenarios (5+)          │ ✗ Error scenarios            │
│ ✓ Edge cases (8+)               │ ✗ Edge cases                 │
│ ✓ Field validation              │ ✓ Field validation (only)    │
│ ✓ Data integrity                │ ✗ Data integrity             │
│ ✓ Atomic operations             │ ✗ Atomic operations          │
│ ✓ Timestamps                    │ ✗ Timestamps                 │
│ ✓ Type coercion                 │ ✗ Type coercion              │
│ ✓ Concurrency                   │ ✗ Concurrency                │
│ ✓ Realistic fixtures            │ ✗ Fixtures                   │
│ ✓ Strong assertions             │ ~ Basic assertions           │
└─────────────────────────────────────────────────────────────────┘
```

---

## Method-by-Method Breakdown

### Current sign_up_test.dart - What IS Tested ✓

```dart
✓ isValidGmail() - 2 test paths
  ✓ Valid emails pass
  ✓ Invalid emails fail

✓ isValidPassword() - 1 test
  ✓ Password policy (8+ chars, upper, lower, symbol)
```

### Current sign_in_test.dart - What IS Tested ✓

```dart
✓ isValidGmail() - Same as above

✓ isValidPassword() - Same as above
```

### AuthRepository Methods - What is NOT Tested ✗

```dart
✗ register() - CRITICAL, 0 tests
  - No happy path test
  - No error handling
  - No rollback verification
  - No Firebase integration
  - No state consistency

✗ verifyCredentials() - CORE AUTH, 0 tests
  - No credential verification
  - No user lookup
  - No case sensitivity
  - No email normalization

✗ emailExists() - HELPER, 0 tests
  - No existence check
  - No case handling

✗ getUserByEmail() - DATA RETRIEVAL, 0 tests
  - No data fetching
  - No null handling
  - No field validation

✗ updateProfile() - COMPLEX LOGIC, 0 tests
  - No single field update
  - No multi-field atomic update
  - No email change logic
  - No duplicate prevention
  - No user not found error

✗ changePassword() - SECURITY, 0 tests
  - No password change logic
  - No user validation

✗ watchUserByEmail() - STREAMING, 0 tests
  - No stream behavior
  - No reactive updates
```

---

## Risk Analysis

### 🔴 CRITICAL GAPS (Must Test)

**1. Registration Rollback Logic**
```dart
// Current code handles multiple failure points:
Future<void> register(String email, String password) async {
  UserCredential? created;
  try {
    created = await FirebaseAuth.instance.createUserWithEmailAndPassword(...);
  } catch (e) {
    throw Exception('Firebase Auth error');
  }
  
  // If DB insert fails here, must rollback Firebase user!
  try {
    await DatabaseUser.insertUser(db, ...);
  } catch (e) {
    await created.user?.delete();  // ROLLBACK
    rethrow;
  }
}

// Risk: What if rollback delete fails?
// Verdict: NO TEST for this critical flow ✗
```

**2. Plaintext Password Storage**
```dart
// In verifyCredentials:
return (user['password'] as String) == password;
// ↑ Plaintext comparison!

// Risk: Database breach exposes all passwords
// Verdict: No password hashing test ✗
```

**3. Email Uniqueness**
```dart
// Must check both Firebase AND local DB
// Risk: Race condition between the two checks
// Verdict: No concurrency test ✗
```

---

### 🟠 IMPORTANT GAPS (Should Test)

**1. Error Handling**
- Firebase exceptions (email-already-in-use, weak-password)
- Database errors
- No error paths tested

**2. State Consistency**
- After failed registration, no orphaned users
- After profile update, all fields in sync
- After stream emission, listeners updated

**3. Edge Cases**
```dart
// Missing tests for:
Email.trim().toLowerCase()      // ✗ No normalization tests
User not found                   // ✗ No null handling
Multiple field updates           // ✗ No atomic tests
Concurrent operations            // ✗ No race condition tests
```

---

### 🟡 NICE-TO-HAVE GAPS

- Performance with large user lists
- Database migration scenarios
- Full integration (Firebase + SQLite together)
- SQL injection attempts

---

## Example: What's Different?

### PIN Service (Improved) - How It Tests
```dart
// ✓ Test 1: Happy path
test('setPin stores PIN in Firestore with merge=true', () async {
  when(() => mockDocRef.set(any(), any())).thenAnswer((_) async {});
  await service.setPin(uid: uid, pin: '1234');
  verify(() => mockDocRef.set(any(), any())).called(1);
});

// ✓ Test 2: Error path
test('setPin throws on Firestore write failure', () async {
  when(() => mockDocRef.set(any(), any())).thenThrow(
    FirebaseException(...)
  );
  expect(() => service.setPin(...), throwsA(isA<FirebaseException>()));
});

// ✓ Test 3: Edge case
test('setPin preserves leading zeros in PIN', () async {
  // Test that '0001' ≠ '1'
});

// ✓ Test 4: Data integrity
test('setPin uses merge to preserve other profile fields', () async {
  // Verify merge=true
});
```

### Sign In/Sign Up (Current) - How It Tests
```dart
// ✓ Test 1: Validation only
test('isValidGmail accepts proper gmail addresses', () {
  expect(repo.isValidGmail('john.doe@gmail.com'), isTrue);
});

// Missing: No Firebase tests
// Missing: No database tests
// Missing: No error handling
// Missing: No state verification
// Missing: No rollback tests
```

---

## Gap Severity Matrix

| Method | Current | Gap | Severity |
|--------|---------|-----|----------|
| isValidGmail | 2 tests | Minor | 🟡 |
| isValidPassword | 1 test | Minor | 🟡 |
| **register()** | **0 tests** | **HUGE** | 🔴 |
| **verifyCredentials()** | **0 tests** | **HUGE** | 🔴 |
| emailExists() | 0 tests | Large | 🟠 |
| getUserByEmail() | 0 tests | Large | 🟠 |
| **updateProfile()** | **0 tests** | **HUGE** | 🔴 |
| changePassword() | 0 tests | Large | 🟠 |
| watchUserByEmail() | 0 tests | Large | 🟠 |

---

## What Needs to be Added

### Phase 1: Validation Tests (Already Partial)
```dart
Current: 5 tests
Missing: +8 tests for edge cases
Total: 13 tests
```

**Add tests for:**
- Email with many dots: `user.name.test@gmail.com`
- Email with plus signs: `user+tag+subtag@gmail.com`
- Email with numbers: `user123@gmail.com`
- Password exactly 8 chars: `Aa!aaaaa`
- Password with unicode symbols
- Empty string validation
- Whitespace-only validation

### Phase 2: Authentication Tests (NEW)
```dart
Current: 0 tests
Missing: 5 tests for core auth
Total: 5 tests
```

**Add tests for:**
- verifyCredentials() happy path
- verifyCredentials() wrong password
- verifyCredentials() missing user
- emailExists() true/false
- getUserByEmail() returns full object

### Phase 3: Registration Tests (NEW)
```dart
Current: 0 tests
Missing: 10 tests for sign up
Total: 10 tests
```

**Add tests for:**
- Happy path registration
- Email already in Firebase
- Email already in local DB
- Firebase fails → DB inserted anyway (incomplete)
- DB fails → Firebase user deleted (rollback)
- Invalid email rejected
- Invalid password rejected
- User data initialized correctly
- Stream emitted after registration

### Phase 4: Profile Management (NEW)
```dart
Current: 0 tests
Missing: 13 tests for profile updates
Total: 13 tests
```

**Add tests for:**
- Update username
- Update avatar
- Update multiple fields together
- Change email to new valid email
- Change email to invalid format
- Change email to taken email
- Email normalization (case)
- Preserve unmofied fields
- User not found error
- Stream emission
- Password change
- All field types

### Phase 5: Streaming Tests (NEW)
```dart
Current: 0 tests
Missing: 5 tests for reactivity
Total: 5 tests
```

**Add tests for:**
- watchUserByEmail returns stream
- Emits user when found
- Emits null when not found
- Updates when DB changes
- Handles errors gracefully

### Phase 6: Error & Concurrency (NEW)
```dart
Current: 0 tests
Missing: 8 tests for robustness
Total: 8 tests
```

**Add tests for:**
- Firebase Auth exceptions
- Database exceptions
- Concurrent registrations
- Concurrent profile updates
- State consistency after failures

---

## Coverage Comparison

```
Sign In/Sign Up Before Enhancement:
[████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] ~15% coverage

Sign In/Sign Up After Enhancement:
[███████████████████████████████████████] ~95% coverage

Other Tests (Edit Profile/PIN/Purchases):
[███████████████████████████████████████] ~95% coverage
```

---

## File Size Comparison

```
sign_up_test.dart (current):    ~30 lines
sign_up_test.dart (enhanced):   ~200 lines

sign_in_test.dart (current):    ~20 lines
sign_in_test.dart (enhanced):   ~100 lines

auth_operations_test.dart:      ~400 lines (new)
auth_error_test.dart:           ~150 lines (new)
────────────────────────────────────────────
Total (current):                ~50 lines
Total (after):                  ~850 lines (17x expansion!)
```

---

## Quick Decision Matrix

**Choose based on priority:**

| If You Want | Time | Value | Complexity |
|-------------|------|-------|------------|
| Just expand validation | 2 hrs | Low | Easy |
| Fix registration risks | 4 hrs | High | Medium |
| Complete auth coverage | 8 hrs | Very High | Medium |
| Production-ready suite | 10 hrs | Critical | Medium |

---

## Recommendation

### 🎯 MINIMUM (2-3 hours)
- Add 8 validation edge case tests
- Add register() happy path test
- Add register() rollback test
- **Result:** 21 tests (vs current 5)

### ✅ RECOMMENDED (6-8 hours)
- All above
- Add all verifyCredentials tests
- Add all updateProfile tests
- Add error scenarios
- **Result:** 45 tests (vs current 5)

### ⭐ IDEAL (10-12 hours)
- Everything above
- Add streaming tests
- Add concurrency tests
- Add security validation
- **Result:** 51+ tests (vs current 5)

---

**Conclusion:** Sign In/Sign Up tests need **10-15x expansion** to match quality of your improved tests. The **critical** items are:
1. Registration rollback logic
2. verifyCredentials implementation
3. updateProfile atomicity
4. Password security verification

Would you like me to proceed with enhancements? If so, what's your priority level?
