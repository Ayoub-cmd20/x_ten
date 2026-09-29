import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'X Ten'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @uploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get uploadFile;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @accountTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'What brings you to X Ten?'**
  String get accountTypeTitle;

  /// No description provided for @accountTypeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the best path for you...'**
  String get accountTypeSubtitle;

  /// No description provided for @contentCreator.
  ///
  /// In en, this message translates to:
  /// **'Content Creator / Influencer'**
  String get contentCreator;

  /// No description provided for @contentCreatorDesc.
  ///
  /// In en, this message translates to:
  /// **'Grow your presence, present your work, and connect with top brands.'**
  String get contentCreatorDesc;

  /// No description provided for @brandOrCompany.
  ///
  /// In en, this message translates to:
  /// **'Brand / Company'**
  String get brandOrCompany;

  /// No description provided for @brandOrCompanyDesc.
  ///
  /// In en, this message translates to:
  /// **'Discover content creators, collaborate, and launch campaigns.'**
  String get brandOrCompanyDesc;

  /// No description provided for @freelancer.
  ///
  /// In en, this message translates to:
  /// **'Freelancer'**
  String get freelancer;

  /// No description provided for @freelancerDesc.
  ///
  /// In en, this message translates to:
  /// **'Offer your creative services to brands and content creators.'**
  String get freelancerDesc;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company / Brand Name'**
  String get companyName;

  /// No description provided for @businessType.
  ///
  /// In en, this message translates to:
  /// **'Business Type'**
  String get businessType;

  /// No description provided for @commercialRegister.
  ///
  /// In en, this message translates to:
  /// **'Commercial Register (RC)'**
  String get commercialRegister;

  /// No description provided for @taxId.
  ///
  /// In en, this message translates to:
  /// **'Tax Identification Number (NIF)'**
  String get taxId;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National Identification Number (NIS)'**
  String get nationalId;

  /// No description provided for @officialEmail.
  ///
  /// In en, this message translates to:
  /// **'Official Email'**
  String get officialEmail;

  /// No description provided for @officialPhone.
  ///
  /// In en, this message translates to:
  /// **'Official Phone Number'**
  String get officialPhone;

  /// No description provided for @storeName.
  ///
  /// In en, this message translates to:
  /// **'Store Name'**
  String get storeName;

  /// No description provided for @storeUrl.
  ///
  /// In en, this message translates to:
  /// **'Store Link'**
  String get storeUrl;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

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

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @wilaya.
  ///
  /// In en, this message translates to:
  /// **'Wilaya'**
  String get wilaya;

  /// No description provided for @socialAccounts.
  ///
  /// In en, this message translates to:
  /// **'Social Media Accounts'**
  String get socialAccounts;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @niches.
  ///
  /// In en, this message translates to:
  /// **'Categories / Niches'**
  String get niches;

  /// No description provided for @contentTypes.
  ///
  /// In en, this message translates to:
  /// **'Content Types'**
  String get contentTypes;

  /// No description provided for @demographics.
  ///
  /// In en, this message translates to:
  /// **'Audience Demographics'**
  String get demographics;

  /// No description provided for @bankRib.
  ///
  /// In en, this message translates to:
  /// **'Bank RIB'**
  String get bankRib;

  /// No description provided for @ccpAccount.
  ///
  /// In en, this message translates to:
  /// **'CCP Account'**
  String get ccpAccount;

  /// No description provided for @verificationStatus.
  ///
  /// In en, this message translates to:
  /// **'Verification Status'**
  String get verificationStatus;

  /// No description provided for @pendingVerification.
  ///
  /// In en, this message translates to:
  /// **'Pending Verification'**
  String get pendingVerification;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Creative Dashboard'**
  String get dashboardTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @managementAndMarketing.
  ///
  /// In en, this message translates to:
  /// **'Management & Marketing'**
  String get managementAndMarketing;

  /// No description provided for @activeAgreements.
  ///
  /// In en, this message translates to:
  /// **'Active Agreements'**
  String get activeAgreements;

  /// No description provided for @influencersList.
  ///
  /// In en, this message translates to:
  /// **'Influencers List'**
  String get influencersList;

  /// No description provided for @influencerCategories.
  ///
  /// In en, this message translates to:
  /// **'Influencers by Category'**
  String get influencerCategories;

  /// No description provided for @onDemandPromotion.
  ///
  /// In en, this message translates to:
  /// **'On-Demand Promotion'**
  String get onDemandPromotion;

  /// No description provided for @professionalServices.
  ///
  /// In en, this message translates to:
  /// **'Professional Services'**
  String get professionalServices;

  /// No description provided for @inviteUser.
  ///
  /// In en, this message translates to:
  /// **'Invite Influencer or Brand'**
  String get inviteUser;

  /// No description provided for @myPromotionRequests.
  ///
  /// In en, this message translates to:
  /// **'My Promotion Requests'**
  String get myPromotionRequests;

  /// No description provided for @financialInfo.
  ///
  /// In en, this message translates to:
  /// **'Financial Information'**
  String get financialInfo;

  /// No description provided for @savedItems.
  ///
  /// In en, this message translates to:
  /// **'Saved Items'**
  String get savedItems;

  /// No description provided for @articlesAndNews.
  ///
  /// In en, this message translates to:
  /// **'Articles & News'**
  String get articlesAndNews;

  /// No description provided for @advertisingFormats.
  ///
  /// In en, this message translates to:
  /// **'Advertising Formats'**
  String get advertisingFormats;

  /// No description provided for @browsePortfolio.
  ///
  /// In en, this message translates to:
  /// **'Browse Portfolio'**
  String get browsePortfolio;

  /// No description provided for @browseProjects.
  ///
  /// In en, this message translates to:
  /// **'Browse Projects'**
  String get browseProjects;

  /// No description provided for @aboutPlatform.
  ///
  /// In en, this message translates to:
  /// **'About X10 Platform'**
  String get aboutPlatform;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @contracts.
  ///
  /// In en, this message translates to:
  /// **'Contracts & Agreements'**
  String get contracts;

  /// No description provided for @contractId.
  ///
  /// In en, this message translates to:
  /// **'Contract ID'**
  String get contractId;

  /// No description provided for @contractValue.
  ///
  /// In en, this message translates to:
  /// **'Contract Value'**
  String get contractValue;

  /// No description provided for @authorizationCode.
  ///
  /// In en, this message translates to:
  /// **'Ad Authorization Code'**
  String get authorizationCode;

  /// No description provided for @promotionDuration.
  ///
  /// In en, this message translates to:
  /// **'Promotion Duration'**
  String get promotionDuration;

  /// No description provided for @disputedWorks.
  ///
  /// In en, this message translates to:
  /// **'Disputed Works'**
  String get disputedWorks;

  /// No description provided for @revisionRequired.
  ///
  /// In en, this message translates to:
  /// **'Revision Required'**
  String get revisionRequired;

  /// No description provided for @pendingDelivery.
  ///
  /// In en, this message translates to:
  /// **'Pending Delivery'**
  String get pendingDelivery;

  /// No description provided for @pendingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Pending Confirmation'**
  String get pendingConfirmation;

  /// No description provided for @pendingPublishing.
  ///
  /// In en, this message translates to:
  /// **'Pending Publishing'**
  String get pendingPublishing;

  /// No description provided for @submitDeliverable.
  ///
  /// In en, this message translates to:
  /// **'Submit Deliverables'**
  String get submitDeliverable;

  /// No description provided for @releasePayment.
  ///
  /// In en, this message translates to:
  /// **'Release Payment'**
  String get releasePayment;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
