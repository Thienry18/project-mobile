import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('id'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Projek Mobile'**
  String get appTitle;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @mandarin.
  ///
  /// In en, this message translates to:
  /// **'Mandarin (中文)'**
  String get mandarin;

  /// No description provided for @korean.
  ///
  /// In en, this message translates to:
  /// **'Korean (한국어)'**
  String get korean;

  /// No description provided for @japanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese (日本語)'**
  String get japanese;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian (Bahasa Indonesia)'**
  String get indonesian;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German (Deutsch)'**
  String get german;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @basic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basic;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signUpDescription.
  ///
  /// In en, this message translates to:
  /// **'Registration with your email and sign up to continue using our app.'**
  String get signUpDescription;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enterUsername;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @reEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reEnterPassword;

  /// No description provided for @agreeToTermsText.
  ///
  /// In en, this message translates to:
  /// **'By creating this account, I acknowledge that I have read and agree to the '**
  String get agreeToTermsText;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered (Firebase).'**
  String get emailAlreadyRegistered;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @insertPin.
  ///
  /// In en, this message translates to:
  /// **'Insert PIN'**
  String get insertPin;

  /// No description provided for @forgotPin.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN'**
  String get forgotPin;

  /// No description provided for @buildProfile.
  ///
  /// In en, this message translates to:
  /// **'Build Profile'**
  String get buildProfile;

  /// No description provided for @buildYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Build Your Profile'**
  String get buildYourProfile;

  /// No description provided for @descBuildProfile.
  ///
  /// In en, this message translates to:
  /// **'Take a moment to fill in your profile so we can create a more personalized and seamless journey for you.'**
  String get descBuildProfile;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @notificationsDeleted.
  ///
  /// In en, this message translates to:
  /// **'Notifications deleted'**
  String get notificationsDeleted;

  /// No description provided for @itemsDeletedFromCart.
  ///
  /// In en, this message translates to:
  /// **'Items deleted from cart'**
  String get itemsDeletedFromCart;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'UNDO'**
  String get undo;

  /// No description provided for @clearPurchaseHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear Purchase History'**
  String get clearPurchaseHistory;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteCartContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete selected items from cart?'**
  String get confirmDeleteCartContent;

  /// No description provided for @confirmDeleteNotifications.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete selected notifications?'**
  String get confirmDeleteNotifications;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @selectVoucher.
  ///
  /// In en, this message translates to:
  /// **'Select a Voucher'**
  String get selectVoucher;

  /// No description provided for @discount20.
  ///
  /// In en, this message translates to:
  /// **'DISCOUNT20 - Save \$16.3'**
  String get discount20;

  /// No description provided for @freeship.
  ///
  /// In en, this message translates to:
  /// **'FREESHIP - Free Shipping'**
  String get freeship;

  /// No description provided for @failedToDeleteItems.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete items'**
  String get failedToDeleteItems;

  /// No description provided for @historyCleared.
  ///
  /// In en, this message translates to:
  /// **'History cleared.'**
  String get historyCleared;

  /// No description provided for @noNewCoursesToPurchase.
  ///
  /// In en, this message translates to:
  /// **'No new courses to purchase.'**
  String get noNewCoursesToPurchase;

  /// No description provided for @courseVideosTitle.
  ///
  /// In en, this message translates to:
  /// **'Course Videos'**
  String get courseVideosTitle;

  /// No description provided for @moduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Module {number} - Introduction'**
  String moduleTitle(Object number);

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @resource.
  ///
  /// In en, this message translates to:
  /// **'Resource'**
  String get resource;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @pleaseCompleteFields.
  ///
  /// In en, this message translates to:
  /// **'Please complete all fields.'**
  String get pleaseCompleteFields;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @toKeepConnected.
  ///
  /// In en, this message translates to:
  /// **'To keep connected with us please sign in with your personal info.'**
  String get toKeepConnected;

  /// No description provided for @forgotPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordQuestion;

  /// No description provided for @doNotHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get doNotHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @aboutCourse.
  ///
  /// In en, this message translates to:
  /// **'About Course'**
  String get aboutCourse;

  /// No description provided for @whatSkillYouGain.
  ///
  /// In en, this message translates to:
  /// **'What Skill You\'ll gain'**
  String get whatSkillYouGain;

  /// No description provided for @syllabus.
  ///
  /// In en, this message translates to:
  /// **'Syllabus'**
  String get syllabus;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @whatInterestsYou.
  ///
  /// In en, this message translates to:
  /// **'What Interests You?'**
  String get whatInterestsYou;

  /// No description provided for @chooseYourInterest.
  ///
  /// In en, this message translates to:
  /// **'Choose your interest to get started with our courses.'**
  String get chooseYourInterest;

  /// No description provided for @chooseInterest.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Interest'**
  String get chooseInterest;

  /// No description provided for @setYourPIN.
  ///
  /// In en, this message translates to:
  /// **'Set Your PIN'**
  String get setYourPIN;

  /// No description provided for @pinDescription.
  ///
  /// In en, this message translates to:
  /// **'Set a secure PIN to protect your account and ensure only you can access it.'**
  String get pinDescription;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePIN.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePIN;

  /// No description provided for @setupComplete.
  ///
  /// In en, this message translates to:
  /// **'Setup Complete!'**
  String get setupComplete;

  /// No description provided for @certificateTitle.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get certificateTitle;

  /// No description provided for @apiDemo.
  ///
  /// In en, this message translates to:
  /// **'API Demo'**
  String get apiDemo;

  /// No description provided for @instructor.
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get instructor;

  /// No description provided for @instructorLabel.
  ///
  /// In en, this message translates to:
  /// **'Instructor: {instructor}'**
  String instructorLabel(Object instructor);

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String status(Object status);

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status:'**
  String get statusLabel;

  /// No description provided for @myCourses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get myCourses;

  /// No description provided for @myCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get myCoursesTitle;

  /// No description provided for @noCourses.
  ///
  /// In en, this message translates to:
  /// **'No courses'**
  String get noCourses;

  /// No description provided for @purchasedDate.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get purchasedDate;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration successful. Continue to build your profile.'**
  String get registrationSuccessful;

  /// No description provided for @emailValidation.
  ///
  /// In en, this message translates to:
  /// **'Email must be a valid @gmail.com address.'**
  String get emailValidation;

  /// No description provided for @passwordValidation.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 chars and include uppercase, lowercase, and a symbol.'**
  String get passwordValidation;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordMismatch;

  /// No description provided for @agreeTerms.
  ///
  /// In en, this message translates to:
  /// **'You must agree to the Terms and Privacy Policy.'**
  String get agreeTerms;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields.'**
  String get fillAllFields;

  /// No description provided for @emailPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Email and password must not be empty.'**
  String get emailPasswordRequired;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get invalidCredentials;

  /// No description provided for @passwordUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully.'**
  String get passwordUpdateSuccess;

  /// No description provided for @pinUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'PIN updated successfully.'**
  String get pinUpdateSuccess;

  /// No description provided for @passwordSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Security'**
  String get passwordSecurityTitle;

  /// No description provided for @resetYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Your Password'**
  String get resetYourPassword;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @noOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get noOrdersFound;

  /// No description provided for @reviewSlider.
  ///
  /// In en, this message translates to:
  /// **'Review Slider'**
  String get reviewSlider;

  /// No description provided for @myCertificates.
  ///
  /// In en, this message translates to:
  /// **'My Certificates'**
  String get myCertificates;

  /// No description provided for @noCertificates.
  ///
  /// In en, this message translates to:
  /// **'No Certificates Yet'**
  String get noCertificates;

  /// No description provided for @emptyCart.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get emptyCart;

  /// No description provided for @databaseReset.
  ///
  /// In en, this message translates to:
  /// **'Database Reset'**
  String get databaseReset;

  /// No description provided for @resetDatabase.
  ///
  /// In en, this message translates to:
  /// **'Reset Database'**
  String get resetDatabase;

  /// No description provided for @resettingDatabases.
  ///
  /// In en, this message translates to:
  /// **'Resetting databases...'**
  String get resettingDatabases;

  /// No description provided for @readyStatus.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get readyStatus;

  /// No description provided for @databaseResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Databases reset successfully!'**
  String get databaseResetSuccess;

  /// No description provided for @bestseller.
  ///
  /// In en, this message translates to:
  /// **'Bestseller'**
  String get bestseller;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @availableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Available Subtitle: {subtitle}'**
  String availableSubtitle(Object subtitle);

  /// No description provided for @youMayLikeTheseCourses.
  ///
  /// In en, this message translates to:
  /// **'You May Like These Courses'**
  String get youMayLikeTheseCourses;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get addedToCart;

  /// No description provided for @addedToCartOffline.
  ///
  /// In en, this message translates to:
  /// **'Added to cart (offline)'**
  String get addedToCartOffline;

  /// No description provided for @alreadyInCart.
  ///
  /// In en, this message translates to:
  /// **'Already in cart'**
  String get alreadyInCart;

  /// No description provided for @buyCourse.
  ///
  /// In en, this message translates to:
  /// **'Buy Course'**
  String get buyCourse;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @itemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsLabel;

  /// No description provided for @emptyCartDescription.
  ///
  /// In en, this message translates to:
  /// **'Add courses you\'re interested in to your wishlist and check out whenever you\'re ready to start learning.'**
  String get emptyCartDescription;

  /// No description provided for @allNotifications.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allNotifications;

  /// No description provided for @unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// No description provided for @noNotification.
  ///
  /// In en, this message translates to:
  /// **'No Notification Yet'**
  String get noNotification;

  /// No description provided for @noNotificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Fresh start! We\'ll let you know when there\'s something worth your attention.'**
  String get noNotificationDescription;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as Read'**
  String get markAsRead;

  /// No description provided for @markAsUnread.
  ///
  /// In en, this message translates to:
  /// **'Mark as Unread'**
  String get markAsUnread;

  /// No description provided for @reminderSet.
  ///
  /// In en, this message translates to:
  /// **'Reminder has been set!'**
  String get reminderSet;

  /// No description provided for @reminderSetOn.
  ///
  /// In en, this message translates to:
  /// **'Reminder set on: {datetime}'**
  String reminderSetOn(Object datetime);

  /// No description provided for @startContinueCourse.
  ///
  /// In en, this message translates to:
  /// **'Start/Continue Course'**
  String get startContinueCourse;

  /// No description provided for @viewCertificate.
  ///
  /// In en, this message translates to:
  /// **'View Certificate'**
  String get viewCertificate;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @subtitles.
  ///
  /// In en, this message translates to:
  /// **'Subtitles'**
  String get subtitles;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @learnPrompt.
  ///
  /// In en, this message translates to:
  /// **'What would you want\nto learn today?'**
  String get learnPrompt;

  /// No description provided for @trendingNow.
  ///
  /// In en, this message translates to:
  /// **'Trending Now'**
  String get trendingNow;

  /// No description provided for @recommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for You'**
  String get recommendedForYou;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @popularForPrefix.
  ///
  /// In en, this message translates to:
  /// **'Popular for '**
  String get popularForPrefix;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @shareCourse.
  ///
  /// In en, this message translates to:
  /// **'Share Course'**
  String get shareCourse;

  /// No description provided for @setReminder.
  ///
  /// In en, this message translates to:
  /// **'Set Reminder/Schedule'**
  String get setReminder;

  /// No description provided for @viewCourseDetails.
  ///
  /// In en, this message translates to:
  /// **'View Course Details'**
  String get viewCourseDetails;

  /// No description provided for @findYourCourse.
  ///
  /// In en, this message translates to:
  /// **'Find Your Course'**
  String get findYourCourse;

  /// No description provided for @discoverCourses.
  ///
  /// In en, this message translates to:
  /// **'Discover courses you\'re actually into and start learning in a way that feels easy and fun.'**
  String get discoverCourses;

  /// No description provided for @searchCourse.
  ///
  /// In en, this message translates to:
  /// **'Search Course'**
  String get searchCourse;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear your history? This action cannot be undone.'**
  String get clearHistoryConfirm;

  /// No description provided for @yourPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Your Payment Methods'**
  String get yourPaymentMethods;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get paymentSuccessful;

  /// No description provided for @addNewCard.
  ///
  /// In en, this message translates to:
  /// **'Add new card'**
  String get addNewCard;

  /// No description provided for @certificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get certificate;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @videoPlay.
  ///
  /// In en, this message translates to:
  /// **'Play Video'**
  String get videoPlay;

  /// No description provided for @areYouSureSignOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get areYouSureSignOut;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @uploadChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload/Change Photo'**
  String get uploadChangePhoto;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @cvvLabel.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvvLabel;

  /// No description provided for @enterCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter card number'**
  String get enterCardNumber;

  /// No description provided for @enterExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Enter expiry date'**
  String get enterExpiryDate;

  /// No description provided for @enterCVV.
  ///
  /// In en, this message translates to:
  /// **'Enter CVV'**
  String get enterCVV;

  /// No description provided for @saveCardDetails.
  ///
  /// In en, this message translates to:
  /// **'Save this card and details for faster payments'**
  String get saveCardDetails;

  /// No description provided for @addCard.
  ///
  /// In en, this message translates to:
  /// **'Add Card'**
  String get addCard;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @noActiveSession.
  ///
  /// In en, this message translates to:
  /// **'No active session. Please sign in again.'**
  String get noActiveSession;

  /// No description provided for @cardAlreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'This card has already been added.'**
  String get cardAlreadyAdded;

  /// No description provided for @videoPlayer.
  ///
  /// In en, this message translates to:
  /// **'Video Player'**
  String get videoPlayer;

  /// No description provided for @certificateOfAchievement.
  ///
  /// In en, this message translates to:
  /// **'Certificate of Achievement'**
  String get certificateOfAchievement;

  /// No description provided for @viewCourseClicked.
  ///
  /// In en, this message translates to:
  /// **'View Course clicked'**
  String get viewCourseClicked;

  /// No description provided for @searchForACourse.
  ///
  /// In en, this message translates to:
  /// **'Search for a course'**
  String get searchForACourse;

  /// No description provided for @subtitleClicked.
  ///
  /// In en, this message translates to:
  /// **'Subtitle clicked'**
  String get subtitleClicked;

  /// No description provided for @previousClicked.
  ///
  /// In en, this message translates to:
  /// **'Previous clicked'**
  String get previousClicked;

  /// No description provided for @nextClicked.
  ///
  /// In en, this message translates to:
  /// **'Next clicked'**
  String get nextClicked;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @historyEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Browse courses you like, add them to your cart, and check out when you’re ready to learn something new.'**
  String get historyEmptyDescription;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @permissionNotGrantedTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission required'**
  String get permissionNotGrantedTitle;

  /// No description provided for @permissionNotGrantedMessage.
  ///
  /// In en, this message translates to:
  /// **'This feature requires permission. Please grant it in Settings.'**
  String get permissionNotGrantedMessage;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @selectInterestsDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the tech topics that excite you the most, and we\'ll build your journey around what you truly want to explore.'**
  String get selectInterestsDescription;

  /// No description provided for @selectAtLeastOneInterest.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one interest.'**
  String get selectAtLeastOneInterest;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'id',
    'ja',
    'ko',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
