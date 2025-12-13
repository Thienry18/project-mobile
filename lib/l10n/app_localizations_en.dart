// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Projek Mobile';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get notification => 'Notification';

  @override
  String get security => 'Security';

  @override
  String get signOut => 'Sign Out';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get mandarin => 'Mandarin (中文)';

  @override
  String get korean => 'Korean (한국어)';

  @override
  String get japanese => 'Japanese (日本語)';

  @override
  String get indonesian => 'Indonesian (Bahasa Indonesia)';

  @override
  String get german => 'German (Deutsch)';

  @override
  String get premium => 'Premium';

  @override
  String get cart => 'Cart';

  @override
  String get basic => 'Basic';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signUpDescription =>
      'Registration with your email and sign up to continue using our app.';

  @override
  String get enterUsername => 'Enter your username';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get reEnterPassword => 'Re-enter your password';

  @override
  String get agreeToTermsText =>
      'By creating this account, I acknowledge that I have read and agree to the ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get and => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get emailAlreadyRegistered =>
      'This email is already registered (Firebase).';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get insertPin => 'Insert PIN';

  @override
  String get forgotPin => 'Forgot PIN';

  @override
  String get buildProfile => 'Build Profile';

  @override
  String get buildYourProfile => 'Build Your Profile';

  @override
  String get descBuildProfile =>
      'Take a moment to fill in your profile so we can create a more personalized and seamless journey for you.';

  @override
  String get history => 'History';

  @override
  String get notificationsDeleted => 'Notifications deleted';

  @override
  String get itemsDeletedFromCart => 'Items deleted from cart';

  @override
  String get undo => 'UNDO';

  @override
  String get clearPurchaseHistory => 'Clear Purchase History';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmDeleteTitle => 'Confirm Delete';

  @override
  String get confirmDeleteCartContent =>
      'Are you sure you want to delete selected items from cart?';

  @override
  String get confirmDeleteNotifications =>
      'Are you sure you want to delete selected notifications?';

  @override
  String get delete => 'Delete';

  @override
  String get selectVoucher => 'Select a Voucher';

  @override
  String get discount20 => 'DISCOUNT20 - Save \$16.3';

  @override
  String get freeship => 'FREESHIP - Free Shipping';

  @override
  String get failedToDeleteItems => 'Failed to delete items';

  @override
  String get historyCleared => 'History cleared.';

  @override
  String get noNewCoursesToPurchase => 'No new courses to purchase.';

  @override
  String get courseVideosTitle => 'Course Videos';

  @override
  String moduleTitle(Object number) {
    return 'Module $number - Introduction';
  }

  @override
  String get video => 'Video';

  @override
  String get resource => 'Resource';

  @override
  String get username => 'Username';

  @override
  String get fullName => 'Full name';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get country => 'Country';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get continueButton => 'Continue';

  @override
  String get pleaseCompleteFields => 'Please complete all fields.';

  @override
  String get welcome => 'Welcome!';

  @override
  String get toKeepConnected =>
      'To keep connected with us please sign in with your personal info.';

  @override
  String get forgotPasswordQuestion => 'Forgot Password?';

  @override
  String get doNotHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get aboutCourse => 'About Course';

  @override
  String get whatSkillYouGain => 'What Skill You\'ll gain';

  @override
  String get syllabus => 'Syllabus';

  @override
  String get getStarted => 'Get Started';

  @override
  String get whatInterestsYou => 'What Interests You?';

  @override
  String get chooseYourInterest =>
      'Choose your interest to get started with our courses.';

  @override
  String get chooseInterest => 'Choose Your Interest';

  @override
  String get setYourPIN => 'Set Your PIN';

  @override
  String get pinDescription =>
      'Set a secure PIN to protect your account and ensure only you can access it.';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changePIN => 'Change PIN';

  @override
  String get setupComplete => 'Setup Complete!';

  @override
  String get certificateTitle => 'Certificate';

  @override
  String get apiDemo => 'API Demo';

  @override
  String get instructor => 'Instructor';

  @override
  String instructorLabel(Object instructor) {
    return 'Instructor: $instructor';
  }

  @override
  String status(Object status) {
    return 'Status: $status';
  }

  @override
  String get statusLabel => 'Status:';

  @override
  String get myCourses => 'My Courses';

  @override
  String get myCoursesTitle => 'My Courses';

  @override
  String get noCourses => 'No courses';

  @override
  String get purchasedDate => 'Purchased';

  @override
  String get allCategories => 'All';

  @override
  String get registrationSuccessful =>
      'Registration successful. Continue to build your profile.';

  @override
  String get emailValidation => 'Email must be a valid @gmail.com address.';

  @override
  String get passwordValidation =>
      'Password must be at least 8 chars and include uppercase, lowercase, and a symbol.';

  @override
  String get passwordMismatch => 'Passwords do not match.';

  @override
  String get agreeTerms => 'You must agree to the Terms and Privacy Policy.';

  @override
  String get fillAllFields => 'Please fill in all fields.';

  @override
  String get emailPasswordRequired => 'Email and password must not be empty.';

  @override
  String get invalidCredentials => 'Invalid email or password.';

  @override
  String get passwordUpdateSuccess => 'Password updated successfully.';

  @override
  String get pinUpdateSuccess => 'PIN updated successfully.';

  @override
  String get passwordSecurityTitle => 'Password Security';

  @override
  String get resetYourPassword => 'Reset Your Password';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get noOrdersFound => 'No orders found';

  @override
  String get reviewSlider => 'Review Slider';

  @override
  String get myCertificates => 'My Certificates';

  @override
  String get noCertificates => 'No Certificates Yet';

  @override
  String get emptyCart => 'Your cart is empty';

  @override
  String get databaseReset => 'Database Reset';

  @override
  String get resetDatabase => 'Reset Database';

  @override
  String get resettingDatabases => 'Resetting databases...';

  @override
  String get readyStatus => 'Ready';

  @override
  String get databaseResetSuccess => 'Databases reset successfully!';

  @override
  String get bestseller => 'Bestseller';

  @override
  String get languageEnglish => 'English';

  @override
  String availableSubtitle(Object subtitle) {
    return 'Available Subtitle: $subtitle';
  }

  @override
  String get youMayLikeTheseCourses => 'You May Like These Courses';

  @override
  String get addedToCart => 'Added to cart';

  @override
  String get addedToCartOffline => 'Added to cart (offline)';

  @override
  String get alreadyInCart => 'Already in cart';

  @override
  String get buyCourse => 'Buy Course';

  @override
  String get priceLabel => 'Price';

  @override
  String get itemsLabel => 'Items';

  @override
  String get emptyCartDescription =>
      'Add courses you\'re interested in to your wishlist and check out whenever you\'re ready to start learning.';

  @override
  String get allNotifications => 'All';

  @override
  String get unread => 'Unread';

  @override
  String get noNotification => 'No Notification Yet';

  @override
  String get noNotificationDescription =>
      'Fresh start! We\'ll let you know when there\'s something worth your attention.';

  @override
  String get markAsRead => 'Mark as Read';

  @override
  String get markAsUnread => 'Mark as Unread';

  @override
  String get reminderSet => 'Reminder has been set!';

  @override
  String reminderSetOn(Object datetime) {
    return 'Reminder set on: $datetime';
  }

  @override
  String get startContinueCourse => 'Start/Continue Course';

  @override
  String get viewCertificate => 'View Certificate';

  @override
  String get explore => 'Explore';

  @override
  String get student => 'Student';

  @override
  String get subtitles => 'Subtitles';

  @override
  String get moreOptions => 'More options';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get start => 'Start';

  @override
  String get search => 'Search';

  @override
  String get learnPrompt => 'What would you want\nto learn today?';

  @override
  String get trendingNow => 'Trending Now';

  @override
  String get recommendedForYou => 'Recommended for You';

  @override
  String get categories => 'Categories';

  @override
  String get seeAll => 'See All';

  @override
  String get popularForPrefix => 'Popular for ';

  @override
  String get add => 'Add';

  @override
  String get remove => 'Remove';

  @override
  String get shareCourse => 'Share Course';

  @override
  String get setReminder => 'Set Reminder/Schedule';

  @override
  String get viewCourseDetails => 'View Course Details';

  @override
  String get findYourCourse => 'Find Your Course';

  @override
  String get discoverCourses =>
      'Discover courses you\'re actually into and start learning in a way that feels easy and fun.';

  @override
  String get searchCourse => 'Search Course';

  @override
  String get account => 'Account';

  @override
  String get support => 'Support';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get menu => 'Menu';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get clearHistoryConfirm =>
      'Are you sure you want to clear your history? This action cannot be undone.';

  @override
  String get yourPaymentMethods => 'Your Payment Methods';

  @override
  String get paymentSuccessful => 'Payment Successful!';

  @override
  String get addNewCard => 'Add new card';

  @override
  String get certificate => 'Certificate';

  @override
  String get contact => 'Contact';

  @override
  String get videoPlay => 'Play Video';

  @override
  String get areYouSureSignOut => 'Are you sure you want to sign out?';

  @override
  String get save => 'Save';

  @override
  String get uploadChangePhoto => 'Upload/Change Photo';

  @override
  String get cardNumber => 'Card Number';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get cvvLabel => 'CVV';

  @override
  String get enterCardNumber => 'Enter card number';

  @override
  String get enterExpiryDate => 'Enter expiry date';

  @override
  String get enterCVV => 'Enter CVV';

  @override
  String get saveCardDetails =>
      'Save this card and details for faster payments';

  @override
  String get addCard => 'Add Card';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully.';

  @override
  String get noActiveSession => 'No active session. Please sign in again.';

  @override
  String get cardAlreadyAdded => 'This card has already been added.';

  @override
  String get videoPlayer => 'Video Player';

  @override
  String get certificateOfAchievement => 'Certificate of Achievement';

  @override
  String get viewCourseClicked => 'View Course clicked';

  @override
  String get searchForACourse => 'Search for a course';

  @override
  String get subtitleClicked => 'Subtitle clicked';

  @override
  String get previousClicked => 'Previous clicked';

  @override
  String get nextClicked => 'Next clicked';

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get historyEmptyDescription =>
      'Browse courses you like, add them to your cart, and check out when you’re ready to learn something new.';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get permissionNotGrantedTitle => 'Permission required';

  @override
  String get permissionNotGrantedMessage =>
      'This feature requires permission. Please grant it in Settings.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get selectInterestsDescription =>
      'Select the tech topics that excite you the most, and we\'ll build your journey around what you truly want to explore.';

  @override
  String get selectAtLeastOneInterest => 'Please select at least one interest.';
}
