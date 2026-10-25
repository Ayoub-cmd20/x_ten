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
  /// In ar, this message translates to:
  /// **'X Ten'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @explore.
  ///
  /// In ar, this message translates to:
  /// **'استكشاف'**
  String get explore;

  /// No description provided for @work.
  ///
  /// In ar, this message translates to:
  /// **'أعمالي'**
  String get work;

  /// No description provided for @messages.
  ///
  /// In ar, this message translates to:
  /// **'الرسائل'**
  String get messages;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اختر اللغة'**
  String get selectLanguage;

  /// No description provided for @continueText.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get continueText;

  /// No description provided for @next.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In ar, this message translates to:
  /// **'السابق'**
  String get previous;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @submit.
  ///
  /// In ar, this message translates to:
  /// **'إرسال'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get close;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In ar, this message translates to:
  /// **'تصفية'**
  String get filter;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @viewDetails.
  ///
  /// In ar, this message translates to:
  /// **'عرض التفاصيل'**
  String get viewDetails;

  /// No description provided for @uploadFile.
  ///
  /// In ar, this message translates to:
  /// **'رفع ملف'**
  String get uploadFile;

  /// No description provided for @downloadPdf.
  ///
  /// In ar, this message translates to:
  /// **'تحميل بصيغة PDF'**
  String get downloadPdf;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد أنك تريد تسجيل الخروج؟'**
  String get logoutConfirm;

  /// No description provided for @fullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get confirmPassword;

  /// No description provided for @phone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phone;

  /// No description provided for @rememberMe.
  ///
  /// In ar, this message translates to:
  /// **'تذكرني'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In ar, this message translates to:
  /// **'إعادة ضبط كلمة المرور'**
  String get resetPassword;

  /// No description provided for @sendCode.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الرمز'**
  String get sendCode;

  /// No description provided for @verify.
  ///
  /// In ar, this message translates to:
  /// **'تحقق'**
  String get verify;

  /// No description provided for @resendCode.
  ///
  /// In ar, this message translates to:
  /// **'إعادة إرسال الرمز'**
  String get resendCode;

  /// No description provided for @dontHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟'**
  String get dontHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب جديد'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'هل لديك حساب بالفعل؟'**
  String get alreadyHaveAccount;

  /// No description provided for @accountTypeTitle.
  ///
  /// In ar, this message translates to:
  /// **'ما الذي يجلبك إلى X Ten؟'**
  String get accountTypeTitle;

  /// No description provided for @accountTypeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر المسار الأنسب لك، وسنخصص تجربتك...'**
  String get accountTypeSubtitle;

  /// No description provided for @contentCreator.
  ///
  /// In ar, this message translates to:
  /// **'صانع محتوى / مؤثر'**
  String get contentCreator;

  /// No description provided for @contentCreatorDesc.
  ///
  /// In ar, this message translates to:
  /// **'نمِّ حضورك، اعرض أعمالك، وتواصل مع العلامات التجارية المناسبة لك.'**
  String get contentCreatorDesc;

  /// No description provided for @brandOrCompany.
  ///
  /// In ar, this message translates to:
  /// **'علامة تجارية / شركة'**
  String get brandOrCompany;

  /// No description provided for @brandOrCompanyDesc.
  ///
  /// In ar, this message translates to:
  /// **'اكتشف صُنّاع المحتوى، تعاون معهم، وأطلق حملاتك التسويقية بسهولة.'**
  String get brandOrCompanyDesc;

  /// No description provided for @freelancer.
  ///
  /// In ar, this message translates to:
  /// **'مستقل'**
  String get freelancer;

  /// No description provided for @freelancerDesc.
  ///
  /// In ar, this message translates to:
  /// **'قدّم خدماتك الإبداعية للعلامات التجارية وصُنّاع المحتوى.'**
  String get freelancerDesc;

  /// No description provided for @privacyPolicy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get privacyPolicy;

  /// No description provided for @termsConditions.
  ///
  /// In ar, this message translates to:
  /// **'الشروط والأحكام'**
  String get termsConditions;

  /// No description provided for @helpCenter.
  ///
  /// In ar, this message translates to:
  /// **'مركز المساعدة'**
  String get helpCenter;

  /// No description provided for @companyName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الشركة / العلامة التجارية'**
  String get companyName;

  /// No description provided for @businessType.
  ///
  /// In ar, this message translates to:
  /// **'نوع النشاط التجاري'**
  String get businessType;

  /// No description provided for @commercialRegister.
  ///
  /// In ar, this message translates to:
  /// **'رقم السجل التجاري (RC)'**
  String get commercialRegister;

  /// No description provided for @taxId.
  ///
  /// In ar, this message translates to:
  /// **'الرقم الجبائي (NIF)'**
  String get taxId;

  /// No description provided for @nationalId.
  ///
  /// In ar, this message translates to:
  /// **'الرقم الإحصائي (NIS)'**
  String get nationalId;

  /// No description provided for @officialEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني الرسمي'**
  String get officialEmail;

  /// No description provided for @officialPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف الرسمي'**
  String get officialPhone;

  /// No description provided for @storeName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المتجر الإلكتروني'**
  String get storeName;

  /// No description provided for @storeUrl.
  ///
  /// In ar, this message translates to:
  /// **'رابط المتجر'**
  String get storeUrl;

  /// No description provided for @personalInfo.
  ///
  /// In ar, this message translates to:
  /// **'البيانات الشخصية'**
  String get personalInfo;

  /// No description provided for @gender.
  ///
  /// In ar, this message translates to:
  /// **'الجنس'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In ar, this message translates to:
  /// **'ذكر'**
  String get male;

  /// No description provided for @female.
  ///
  /// In ar, this message translates to:
  /// **'أنثى'**
  String get female;

  /// No description provided for @dateOfBirth.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الميلاد'**
  String get dateOfBirth;

  /// No description provided for @wilaya.
  ///
  /// In ar, this message translates to:
  /// **'الولاية'**
  String get wilaya;

  /// No description provided for @socialAccounts.
  ///
  /// In ar, this message translates to:
  /// **'حسابات التواصل الاجتماعي'**
  String get socialAccounts;

  /// No description provided for @followers.
  ///
  /// In ar, this message translates to:
  /// **'المتابعين'**
  String get followers;

  /// No description provided for @niches.
  ///
  /// In ar, this message translates to:
  /// **'مجالات التأثير'**
  String get niches;

  /// No description provided for @contentTypes.
  ///
  /// In ar, this message translates to:
  /// **'أنواع المحتوى'**
  String get contentTypes;

  /// No description provided for @demographics.
  ///
  /// In ar, this message translates to:
  /// **'إحصائيات الجمهور'**
  String get demographics;

  /// No description provided for @bankRib.
  ///
  /// In ar, this message translates to:
  /// **'الحساب البنكي (RIB)'**
  String get bankRib;

  /// No description provided for @ccpAccount.
  ///
  /// In ar, this message translates to:
  /// **'حساب CCP'**
  String get ccpAccount;

  /// No description provided for @verificationStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة التوثيق'**
  String get verificationStatus;

  /// No description provided for @pendingVerification.
  ///
  /// In ar, this message translates to:
  /// **'قيد المراجعة'**
  String get pendingVerification;

  /// No description provided for @verified.
  ///
  /// In ar, this message translates to:
  /// **'موثق'**
  String get verified;

  /// No description provided for @dashboardTitle.
  ///
  /// In ar, this message translates to:
  /// **'لوحة التحكم الإبداعية'**
  String get dashboardTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك مجدداً'**
  String get welcomeBack;

  /// No description provided for @managementAndMarketing.
  ///
  /// In ar, this message translates to:
  /// **'الإدارة والتسويق'**
  String get managementAndMarketing;

  /// No description provided for @activeAgreements.
  ///
  /// In ar, this message translates to:
  /// **'الإتفاقيات قيد العمل'**
  String get activeAgreements;

  /// No description provided for @influencersList.
  ///
  /// In ar, this message translates to:
  /// **'قائمة المؤثرين'**
  String get influencersList;

  /// No description provided for @influencerCategories.
  ///
  /// In ar, this message translates to:
  /// **'قائمة المؤثرين حسب المجالات'**
  String get influencerCategories;

  /// No description provided for @onDemandPromotion.
  ///
  /// In ar, this message translates to:
  /// **'ترويج حسب الطلب'**
  String get onDemandPromotion;

  /// No description provided for @professionalServices.
  ///
  /// In ar, this message translates to:
  /// **'خدمات المنصة الإحترافية'**
  String get professionalServices;

  /// No description provided for @inviteUser.
  ///
  /// In ar, this message translates to:
  /// **'دعوة مؤثر أو معلن'**
  String get inviteUser;

  /// No description provided for @myPromotionRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الترويج الخاصة بي'**
  String get myPromotionRequests;

  /// No description provided for @financialInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلوماتي المالية'**
  String get financialInfo;

  /// No description provided for @savedItems.
  ///
  /// In ar, this message translates to:
  /// **'العناصر المحفوظة'**
  String get savedItems;

  /// No description provided for @articlesAndNews.
  ///
  /// In ar, this message translates to:
  /// **'مقالات و أخبار'**
  String get articlesAndNews;

  /// No description provided for @advertisingFormats.
  ///
  /// In ar, this message translates to:
  /// **'أنواع و صيغ الإشهار'**
  String get advertisingFormats;

  /// No description provided for @browsePortfolio.
  ///
  /// In ar, this message translates to:
  /// **'تصفح معرض الأعمال'**
  String get browsePortfolio;

  /// No description provided for @browseProjects.
  ///
  /// In ar, this message translates to:
  /// **'تصفح المشاريع'**
  String get browseProjects;

  /// No description provided for @aboutPlatform.
  ///
  /// In ar, this message translates to:
  /// **'التعرف على المنصة : X10'**
  String get aboutPlatform;

  /// No description provided for @aboutUs.
  ///
  /// In ar, this message translates to:
  /// **'من نحن'**
  String get aboutUs;

  /// No description provided for @faq.
  ///
  /// In ar, this message translates to:
  /// **'أسئلة شائعة'**
  String get faq;

  /// No description provided for @contactUs.
  ///
  /// In ar, this message translates to:
  /// **'اتصل بنا'**
  String get contactUs;

  /// No description provided for @contracts.
  ///
  /// In ar, this message translates to:
  /// **'العقود والاتفاقيات'**
  String get contracts;

  /// No description provided for @contractId.
  ///
  /// In ar, this message translates to:
  /// **'رقم العقد'**
  String get contractId;

  /// No description provided for @contractValue.
  ///
  /// In ar, this message translates to:
  /// **'قيمة العقد'**
  String get contractValue;

  /// No description provided for @authorizationCode.
  ///
  /// In ar, this message translates to:
  /// **'كود التفويض والترخيص'**
  String get authorizationCode;

  /// No description provided for @promotionDuration.
  ///
  /// In ar, this message translates to:
  /// **'مدة الترويج'**
  String get promotionDuration;

  /// No description provided for @disputedWorks.
  ///
  /// In ar, this message translates to:
  /// **'أعمال معترض عليها'**
  String get disputedWorks;

  /// No description provided for @revisionRequired.
  ///
  /// In ar, this message translates to:
  /// **'تعديل مطلوب'**
  String get revisionRequired;

  /// No description provided for @pendingDelivery.
  ///
  /// In ar, this message translates to:
  /// **'في انتظار التسليم'**
  String get pendingDelivery;

  /// No description provided for @pendingConfirmation.
  ///
  /// In ar, this message translates to:
  /// **'في انتظار التأكيد'**
  String get pendingConfirmation;

  /// No description provided for @pendingPublishing.
  ///
  /// In ar, this message translates to:
  /// **'في انتظار النشر'**
  String get pendingPublishing;

  /// No description provided for @submitDeliverable.
  ///
  /// In ar, this message translates to:
  /// **'تسليم العمل النهائي'**
  String get submitDeliverable;

  /// No description provided for @releasePayment.
  ///
  /// In ar, this message translates to:
  /// **'تحرير المبلغ'**
  String get releasePayment;

  /// No description provided for @loginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سجّل الدخول إلى حسابك للمتابعة'**
  String get loginSubtitle;

  /// No description provided for @passwordHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كلمة المرور'**
  String get passwordHint;

  /// No description provided for @emailRequired.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال البريد الإلكتروني'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال بريد إلكتروني صحيح'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال كلمة المرور'**
  String get passwordRequired;

  /// No description provided for @showPassword.
  ///
  /// In ar, this message translates to:
  /// **'إظهار كلمة المرور'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In ar, this message translates to:
  /// **'إخفاء كلمة المرور'**
  String get hidePassword;

  /// No description provided for @loginUnsupportedAccount.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحساب لا يمكنه استعمال التطبيق.'**
  String get loginUnsupportedAccount;

  /// No description provided for @errorNetwork.
  ///
  /// In ar, this message translates to:
  /// **'تعذر الاتصال بالخادم، تحقق من الإنترنت وحاول مجددًا.'**
  String get errorNetwork;

  /// No description provided for @errorThrottled.
  ///
  /// In ar, this message translates to:
  /// **'محاولات كثيرة، حاول مجددًا بعد {seconds, plural, =1{ثانية واحدة} =2{ثانيتين} few{{seconds} ثوانٍ} many{{seconds} ثانية} other{{seconds} ثانية}}.'**
  String errorThrottled(int seconds);

  /// No description provided for @errorThrottledGeneric.
  ///
  /// In ar, this message translates to:
  /// **'محاولات كثيرة، انتظر قليلًا ثم حاول مجددًا.'**
  String get errorThrottledGeneric;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني أو كلمة المرور غير صحيحة، أو أن الحساب موقوف.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorSessionExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت جلستك، سجّل الدخول من جديد.'**
  String get errorSessionExpired;

  /// No description provided for @errorPermission.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك صلاحية للقيام بهذا الإجراء.'**
  String get errorPermission;

  /// No description provided for @errorNotFound.
  ///
  /// In ar, this message translates to:
  /// **'العنصر غير موجود.'**
  String get errorNotFound;

  /// No description provided for @errorConflict.
  ///
  /// In ar, this message translates to:
  /// **'تغيّرت حالة هذا العنصر، حدّث الصفحة وحاول مجددًا.'**
  String get errorConflict;

  /// No description provided for @errorValidation.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من البيانات المدخلة.'**
  String get errorValidation;

  /// No description provided for @errorUnexpected.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع، حاول مجددًا.'**
  String get errorUnexpected;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @comingSoon.
  ///
  /// In ar, this message translates to:
  /// **'قريبًا'**
  String get comingSoon;

  /// No description provided for @changePhone.
  ///
  /// In ar, this message translates to:
  /// **'تغيير رقم الهاتف'**
  String get changePhone;

  /// No description provided for @newPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الجديدة'**
  String get newPassword;

  /// No description provided for @signupTitle.
  ///
  /// In ar, this message translates to:
  /// **'انضم إلى X Ten'**
  String get signupTitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حسابك وابدأ رحلتك مع أقوى منصة للمؤثرين والعلامات التجارية.'**
  String get signupSubtitle;

  /// No description provided for @fullNameHint.
  ///
  /// In ar, this message translates to:
  /// **'اسمك الكامل'**
  String get fullNameHint;

  /// No description provided for @fullNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال الاسم الكامل'**
  String get fullNameRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال رقم الهاتف'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم هاتف جزائري صحيح يبدأ بـ 05 أو 06 أو 07'**
  String get phoneInvalid;

  /// No description provided for @passwordWeak.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل وألا تكون أرقامًا فقط'**
  String get passwordWeak;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمتا المرور غير متطابقتين'**
  String get passwordsDoNotMatch;

  /// No description provided for @otpTitle.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من رقمك'**
  String get otpTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا رمز التحقق إلى {phone}'**
  String otpSentTo(String phone);

  /// No description provided for @otpInvalid.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرمز المكون من 6 أرقام'**
  String get otpInvalid;

  /// No description provided for @resendCodeIn.
  ///
  /// In ar, this message translates to:
  /// **'إعادة إرسال الرمز بعد {time}'**
  String resendCodeIn(String time);

  /// No description provided for @codeResent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال رمز جديد'**
  String get codeResent;

  /// No description provided for @registrationExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت صلاحية جلسة التسجيل، يرجى البدء من جديد.'**
  String get registrationExpired;

  /// No description provided for @startOver.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ من جديد'**
  String get startOver;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In ar, this message translates to:
  /// **'استعادة كلمة المرور'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم هاتفك وسنرسل لك رمزًا لإعادة تعيين كلمة المرور.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @resetCodeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرمز المرسل إلى {phone} وكلمة المرور الجديدة.'**
  String resetCodeSubtitle(String phone);

  /// No description provided for @passwordResetSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تغيير كلمة المرور بنجاح، سجّل الدخول الآن.'**
  String get passwordResetSuccess;

  /// No description provided for @accountSuspended.
  ///
  /// In ar, this message translates to:
  /// **'تم إيقاف حسابك، تواصل مع الدعم.'**
  String get accountSuspended;

  /// No description provided for @registrationTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملف المؤثر'**
  String get registrationTitle;

  /// No description provided for @stepBasicInfo.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الأساسية'**
  String get stepBasicInfo;

  /// No description provided for @stepAudience.
  ///
  /// In ar, this message translates to:
  /// **'التصنيفات والجمهور'**
  String get stepAudience;

  /// No description provided for @stepAccounts.
  ///
  /// In ar, this message translates to:
  /// **'الحسابات والأعمال'**
  String get stepAccounts;

  /// No description provided for @stepPhoto.
  ///
  /// In ar, this message translates to:
  /// **'الصورة الشخصية'**
  String get stepPhoto;

  /// No description provided for @stepFinancial.
  ///
  /// In ar, this message translates to:
  /// **'الدفع والمستندات'**
  String get stepFinancial;

  /// No description provided for @stepCounter.
  ///
  /// In ar, this message translates to:
  /// **'الخطوة {current} من {total}'**
  String stepCounter(int current, int total);

  /// No description provided for @back.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get back;

  /// No description provided for @saveAndContinue.
  ///
  /// In ar, this message translates to:
  /// **'حفظ ومتابعة'**
  String get saveAndContinue;

  /// No description provided for @add.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get add;

  /// No description provided for @optional.
  ///
  /// In ar, this message translates to:
  /// **'اختياري'**
  String get optional;

  /// No description provided for @fix.
  ///
  /// In ar, this message translates to:
  /// **'إكمال'**
  String get fix;

  /// No description provided for @upload.
  ///
  /// In ar, this message translates to:
  /// **'رفع'**
  String get upload;

  /// No description provided for @fieldRequired.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get fieldRequired;

  /// No description provided for @urlInvalid.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رابطًا صحيحًا يبدأ بـ https://'**
  String get urlInvalid;

  /// No description provided for @listSeparator.
  ///
  /// In ar, this message translates to:
  /// **'، '**
  String get listSeparator;

  /// No description provided for @firstName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In ar, this message translates to:
  /// **'اللقب'**
  String get lastName;

  /// No description provided for @displayName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم المعروض'**
  String get displayName;

  /// No description provided for @displayNameHint.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الذي تراه الشركات'**
  String get displayNameHint;

  /// No description provided for @birthPlace.
  ///
  /// In ar, this message translates to:
  /// **'مكان الميلاد'**
  String get birthPlace;

  /// No description provided for @bio.
  ///
  /// In ar, this message translates to:
  /// **'نبذة عنك'**
  String get bio;

  /// No description provided for @bioHint.
  ///
  /// In ar, this message translates to:
  /// **'عرّف بنفسك وبالمحتوى الذي تقدمه'**
  String get bioHint;

  /// No description provided for @whatsapp.
  ///
  /// In ar, this message translates to:
  /// **'رقم واتساب'**
  String get whatsapp;

  /// No description provided for @primaryCategories.
  ///
  /// In ar, this message translates to:
  /// **'تصنيفاتك الأساسية'**
  String get primaryCategories;

  /// No description provided for @secondaryCategories.
  ///
  /// In ar, this message translates to:
  /// **'تصنيفات ثانوية'**
  String get secondaryCategories;

  /// No description provided for @chooseUpTo.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأقصى: {count}'**
  String chooseUpTo(int count);

  /// No description provided for @optionalChooseUpTo.
  ///
  /// In ar, this message translates to:
  /// **'اختياري، الحد الأقصى: {count}'**
  String optionalChooseUpTo(int count);

  /// No description provided for @selectAtLeastOne.
  ///
  /// In ar, this message translates to:
  /// **'اختر عنصرًا واحدًا على الأقل'**
  String get selectAtLeastOne;

  /// No description provided for @audienceAge.
  ///
  /// In ar, this message translates to:
  /// **'أعمار الجمهور'**
  String get audienceAge;

  /// No description provided for @audienceGender.
  ///
  /// In ar, this message translates to:
  /// **'جنس الجمهور'**
  String get audienceGender;

  /// No description provided for @audienceLocations.
  ///
  /// In ar, this message translates to:
  /// **'أماكن الجمهور'**
  String get audienceLocations;

  /// No description provided for @audienceInterests.
  ///
  /// In ar, this message translates to:
  /// **'اهتمامات الجمهور'**
  String get audienceInterests;

  /// No description provided for @addLocation.
  ///
  /// In ar, this message translates to:
  /// **'إضافة ولاية'**
  String get addLocation;

  /// No description provided for @percentTotal.
  ///
  /// In ar, this message translates to:
  /// **'المجموع {total}'**
  String percentTotal(String total);

  /// No description provided for @audienceMustTotal.
  ///
  /// In ar, this message translates to:
  /// **'مجموع نسب الأعمار يجب أن يكون 100%'**
  String get audienceMustTotal;

  /// No description provided for @socialAccountsHint.
  ///
  /// In ar, this message translates to:
  /// **'حساب واحد على الأقل'**
  String get socialAccountsHint;

  /// No description provided for @socialAccountsEmpty.
  ///
  /// In ar, this message translates to:
  /// **'أضف حسابًا اجتماعيًا واحدًا على الأقل'**
  String get socialAccountsEmpty;

  /// No description provided for @followersCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} متابع'**
  String followersCount(String count);

  /// No description provided for @addSocialAccount.
  ///
  /// In ar, this message translates to:
  /// **'إضافة حساب اجتماعي'**
  String get addSocialAccount;

  /// No description provided for @platformLabel.
  ///
  /// In ar, this message translates to:
  /// **'المنصة'**
  String get platformLabel;

  /// No description provided for @accountUrl.
  ///
  /// In ar, this message translates to:
  /// **'رابط الحساب'**
  String get accountUrl;

  /// No description provided for @username.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستخدم'**
  String get username;

  /// No description provided for @accountName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الحساب'**
  String get accountName;

  /// No description provided for @descriptionOptional.
  ///
  /// In ar, this message translates to:
  /// **'وصف (اختياري)'**
  String get descriptionOptional;

  /// No description provided for @portfolioTitle.
  ///
  /// In ar, this message translates to:
  /// **'معرض الأعمال'**
  String get portfolioTitle;

  /// No description provided for @portfolioEmpty.
  ///
  /// In ar, this message translates to:
  /// **'أضف أعمالك السابقة لتبرز أمام الشركات'**
  String get portfolioEmpty;

  /// No description provided for @addPortfolioItem.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عمل'**
  String get addPortfolioItem;

  /// No description provided for @portfolioItemTitle.
  ///
  /// In ar, this message translates to:
  /// **'عنوان العمل'**
  String get portfolioItemTitle;

  /// No description provided for @portfolioItemLink.
  ///
  /// In ar, this message translates to:
  /// **'رابط العمل'**
  String get portfolioItemLink;

  /// No description provided for @portfolioItemDescription.
  ///
  /// In ar, this message translates to:
  /// **'وصف العمل'**
  String get portfolioItemDescription;

  /// No description provided for @photoTitle.
  ///
  /// In ar, this message translates to:
  /// **'صورتك الشخصية'**
  String get photoTitle;

  /// No description provided for @photoSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'صورة واضحة لوجهك تزيد ثقة الشركات. هذه الخطوة اختيارية.'**
  String get photoSubtitle;

  /// No description provided for @choosePhoto.
  ///
  /// In ar, this message translates to:
  /// **'اختيار صورة'**
  String get choosePhoto;

  /// No description provided for @changePhoto.
  ///
  /// In ar, this message translates to:
  /// **'تغيير الصورة'**
  String get changePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In ar, this message translates to:
  /// **'حذف الصورة'**
  String get removePhoto;

  /// No description provided for @fromGallery.
  ///
  /// In ar, this message translates to:
  /// **'من المعرض'**
  String get fromGallery;

  /// No description provided for @fromCamera.
  ///
  /// In ar, this message translates to:
  /// **'من الكاميرا'**
  String get fromCamera;

  /// No description provided for @payoutMethod.
  ///
  /// In ar, this message translates to:
  /// **'طريقة استلام الأرباح'**
  String get payoutMethod;

  /// No description provided for @accountTypeCcp.
  ///
  /// In ar, this message translates to:
  /// **'CCP'**
  String get accountTypeCcp;

  /// No description provided for @accountTypeBank.
  ///
  /// In ar, this message translates to:
  /// **'بنك'**
  String get accountTypeBank;

  /// No description provided for @accountTypeBoth.
  ///
  /// In ar, this message translates to:
  /// **'الاثنين'**
  String get accountTypeBoth;

  /// No description provided for @ccpKey.
  ///
  /// In ar, this message translates to:
  /// **'المفتاح'**
  String get ccpKey;

  /// No description provided for @ccpKeyInvalid.
  ///
  /// In ar, this message translates to:
  /// **'رقمين بالضبط'**
  String get ccpKeyInvalid;

  /// No description provided for @bankName.
  ///
  /// In ar, this message translates to:
  /// **'اسم البنك'**
  String get bankName;

  /// No description provided for @bankAccount.
  ///
  /// In ar, this message translates to:
  /// **'رقم الحساب البنكي'**
  String get bankAccount;

  /// No description provided for @documentsTitle.
  ///
  /// In ar, this message translates to:
  /// **'المستندات'**
  String get documentsTitle;

  /// No description provided for @documentsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'JPG أو PNG أو PDF، حتى 5MB'**
  String get documentsSubtitle;

  /// No description provided for @documentUploaded.
  ///
  /// In ar, this message translates to:
  /// **'تم الرفع'**
  String get documentUploaded;

  /// No description provided for @documentVerified.
  ///
  /// In ar, this message translates to:
  /// **'تم التحقق'**
  String get documentVerified;

  /// No description provided for @missingDocumentsWarning.
  ///
  /// In ar, this message translates to:
  /// **'مستندات ناقصة: {documents}'**
  String missingDocumentsWarning(String documents);

  /// No description provided for @fileBadExtension.
  ///
  /// In ar, this message translates to:
  /// **'صيغة الملف غير مدعومة'**
  String get fileBadExtension;

  /// No description provided for @fileTooLarge.
  ///
  /// In ar, this message translates to:
  /// **'حجم الملف أكبر من 5MB'**
  String get fileTooLarge;

  /// No description provided for @docIdentityFront.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة التعريف (الوجه)'**
  String get docIdentityFront;

  /// No description provided for @docIdentityBack.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة التعريف (الظهر)'**
  String get docIdentityBack;

  /// No description provided for @docCcpCheque.
  ///
  /// In ar, this message translates to:
  /// **'صك CCP مشطوب'**
  String get docCcpCheque;

  /// No description provided for @docBankRib.
  ///
  /// In ar, this message translates to:
  /// **'كشف RIB'**
  String get docBankRib;

  /// No description provided for @docOther.
  ///
  /// In ar, this message translates to:
  /// **'مستند آخر'**
  String get docOther;

  /// No description provided for @notificationsTitle.
  ///
  /// In ar, this message translates to:
  /// **'كيف نتواصل معك؟'**
  String get notificationsTitle;

  /// No description provided for @notifyInApp.
  ///
  /// In ar, this message translates to:
  /// **'داخل التطبيق'**
  String get notifyInApp;

  /// No description provided for @notifyWhatsapp.
  ///
  /// In ar, this message translates to:
  /// **'واتساب'**
  String get notifyWhatsapp;

  /// No description provided for @notifySms.
  ///
  /// In ar, this message translates to:
  /// **'رسائل SMS'**
  String get notifySms;

  /// No description provided for @notifyPhone.
  ///
  /// In ar, this message translates to:
  /// **'مكالمة هاتفية'**
  String get notifyPhone;

  /// No description provided for @consentsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الموافقات'**
  String get consentsTitle;

  /// No description provided for @consentVerification.
  ///
  /// In ar, this message translates to:
  /// **'أوافق على إجراءات التحقق من هويتي'**
  String get consentVerification;

  /// No description provided for @consentContact.
  ///
  /// In ar, this message translates to:
  /// **'أوافق على أن تتواصل معي المنصة'**
  String get consentContact;

  /// No description provided for @acceptAll.
  ///
  /// In ar, this message translates to:
  /// **'الموافقة على الكل'**
  String get acceptAll;

  /// No description provided for @acceptAllConsents.
  ///
  /// In ar, this message translates to:
  /// **'يرجى قبول كل الموافقات'**
  String get acceptAllConsents;

  /// No description provided for @submitForReview.
  ///
  /// In ar, this message translates to:
  /// **'إرسال للمراجعة'**
  String get submitForReview;

  /// No description provided for @submitMissingTitle.
  ///
  /// In ar, this message translates to:
  /// **'أكمل هذه العناصر قبل الإرسال'**
  String get submitMissingTitle;

  /// No description provided for @missingNames.
  ///
  /// In ar, this message translates to:
  /// **'الاسم واللقب والاسم المعروض'**
  String get missingNames;

  /// No description provided for @missingContact.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني أو رقم الهاتف'**
  String get missingContact;

  /// No description provided for @statusSubmittedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال ملفك'**
  String get statusSubmittedTitle;

  /// No description provided for @statusSubmittedBody.
  ///
  /// In ar, this message translates to:
  /// **'سيراجع فريقنا ملفك قريبًا، وسنعلمك بأي تحديث.'**
  String get statusSubmittedBody;

  /// No description provided for @statusUnderReviewTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملفك قيد المراجعة'**
  String get statusUnderReviewTitle;

  /// No description provided for @statusMeetingRequiredTitle.
  ///
  /// In ar, this message translates to:
  /// **'نحتاج مكالمة تحقق قصيرة'**
  String get statusMeetingRequiredTitle;

  /// No description provided for @statusMeetingRequiredBody.
  ///
  /// In ar, this message translates to:
  /// **'سنحدد معك موعد المكالمة قريبًا.'**
  String get statusMeetingRequiredBody;

  /// No description provided for @statusMeetingScheduledTitle.
  ///
  /// In ar, this message translates to:
  /// **'موعد مكالمة التحقق'**
  String get statusMeetingScheduledTitle;

  /// No description provided for @statusMeetingScheduledBody.
  ///
  /// In ar, this message translates to:
  /// **'كن متاحًا في الموعد التالي.'**
  String get statusMeetingScheduledBody;

  /// No description provided for @statusNeedsChangesTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملفك يحتاج تعديلات'**
  String get statusNeedsChangesTitle;

  /// No description provided for @statusNeedsChangesBody.
  ///
  /// In ar, this message translates to:
  /// **'عدّل المعلومات المطلوبة في ملفك ثم أعد إرساله.'**
  String get statusNeedsChangesBody;

  /// No description provided for @statusRejectedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض ملفك'**
  String get statusRejectedTitle;

  /// No description provided for @statusRejectedBody.
  ///
  /// In ar, this message translates to:
  /// **'للاستفسار يمكنك التواصل مع إدارة المنصة.'**
  String get statusRejectedBody;

  /// No description provided for @refreshStatus.
  ///
  /// In ar, this message translates to:
  /// **'تحديث الحالة'**
  String get refreshStatus;

  /// No description provided for @platformWebsite.
  ///
  /// In ar, this message translates to:
  /// **'موقع إلكتروني'**
  String get platformWebsite;

  /// No description provided for @platformBlog.
  ///
  /// In ar, this message translates to:
  /// **'مدونة'**
  String get platformBlog;

  /// No description provided for @platformOther.
  ///
  /// In ar, this message translates to:
  /// **'منصة أخرى'**
  String get platformOther;

  /// No description provided for @facebookProfile.
  ///
  /// In ar, this message translates to:
  /// **'حساب شخصي'**
  String get facebookProfile;

  /// No description provided for @facebookPage.
  ///
  /// In ar, this message translates to:
  /// **'صفحة'**
  String get facebookPage;

  /// No description provided for @catTechnology.
  ///
  /// In ar, this message translates to:
  /// **'التقنية و التكنولوجيا'**
  String get catTechnology;

  /// No description provided for @catGaming.
  ///
  /// In ar, this message translates to:
  /// **'الألعاب'**
  String get catGaming;

  /// No description provided for @catSports.
  ///
  /// In ar, this message translates to:
  /// **'رياضة'**
  String get catSports;

  /// No description provided for @catFootball.
  ///
  /// In ar, this message translates to:
  /// **'كرة القدم'**
  String get catFootball;

  /// No description provided for @catFitness.
  ///
  /// In ar, this message translates to:
  /// **'اللياقة البدنية'**
  String get catFitness;

  /// No description provided for @catHealth.
  ///
  /// In ar, this message translates to:
  /// **'صحة'**
  String get catHealth;

  /// No description provided for @catBeauty.
  ///
  /// In ar, this message translates to:
  /// **'جمال'**
  String get catBeauty;

  /// No description provided for @catFashion.
  ///
  /// In ar, this message translates to:
  /// **'الموضة'**
  String get catFashion;

  /// No description provided for @catLifestyle.
  ///
  /// In ar, this message translates to:
  /// **'نمط الحياة'**
  String get catLifestyle;

  /// No description provided for @catCooking.
  ///
  /// In ar, this message translates to:
  /// **'طبخ و تغذية'**
  String get catCooking;

  /// No description provided for @catTravel.
  ///
  /// In ar, this message translates to:
  /// **'السياحة و الأسفار'**
  String get catTravel;

  /// No description provided for @catCars.
  ///
  /// In ar, this message translates to:
  /// **'سيارات و ماكينات'**
  String get catCars;

  /// No description provided for @catEducation.
  ///
  /// In ar, this message translates to:
  /// **'تعليم و تطوير'**
  String get catEducation;

  /// No description provided for @catBusiness.
  ///
  /// In ar, this message translates to:
  /// **'المال و الأعمال'**
  String get catBusiness;

  /// No description provided for @catFinance.
  ///
  /// In ar, this message translates to:
  /// **'المال'**
  String get catFinance;

  /// No description provided for @catMarketing.
  ///
  /// In ar, this message translates to:
  /// **'التسويق'**
  String get catMarketing;

  /// No description provided for @catEcommerce.
  ///
  /// In ar, this message translates to:
  /// **'تجارة إلكترونية'**
  String get catEcommerce;

  /// No description provided for @catArt.
  ///
  /// In ar, this message translates to:
  /// **'الفن'**
  String get catArt;

  /// No description provided for @catMusic.
  ///
  /// In ar, this message translates to:
  /// **'الموسيقى و الطرب'**
  String get catMusic;

  /// No description provided for @catEntertainment.
  ///
  /// In ar, this message translates to:
  /// **'الترفيه'**
  String get catEntertainment;

  /// No description provided for @catFamily.
  ///
  /// In ar, this message translates to:
  /// **'العائلة والأمومة'**
  String get catFamily;

  /// No description provided for @catPhotography.
  ///
  /// In ar, this message translates to:
  /// **'التصوير'**
  String get catPhotography;

  /// No description provided for @ctPost.
  ///
  /// In ar, this message translates to:
  /// **'منشور'**
  String get ctPost;

  /// No description provided for @ctReel.
  ///
  /// In ar, this message translates to:
  /// **'ريلز'**
  String get ctReel;

  /// No description provided for @ctStory.
  ///
  /// In ar, this message translates to:
  /// **'ستوري'**
  String get ctStory;

  /// No description provided for @ctVideo.
  ///
  /// In ar, this message translates to:
  /// **'فيديو طويل'**
  String get ctVideo;

  /// No description provided for @ctLive.
  ///
  /// In ar, this message translates to:
  /// **'بث مباشر'**
  String get ctLive;

  /// No description provided for @ctPodcast.
  ///
  /// In ar, this message translates to:
  /// **'بودكاست'**
  String get ctPodcast;

  /// No description provided for @ctReview.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة منتج'**
  String get ctReview;

  /// No description provided for @ctTutorial.
  ///
  /// In ar, this message translates to:
  /// **'شرح'**
  String get ctTutorial;

  /// No description provided for @companyTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملف الشركة'**
  String get companyTitle;

  /// No description provided for @companyStepType.
  ///
  /// In ar, this message translates to:
  /// **'نوع النشاط'**
  String get companyStepType;

  /// No description provided for @companyStepContact.
  ///
  /// In ar, this message translates to:
  /// **'التواصل'**
  String get companyStepContact;

  /// No description provided for @businessTypeQuestion.
  ///
  /// In ar, this message translates to:
  /// **'هل لديك سجل تجاري؟'**
  String get businessTypeQuestion;

  /// No description provided for @businessTypeHint.
  ///
  /// In ar, this message translates to:
  /// **'نحدد على أساسه المعلومات والوثائق المطلوبة.'**
  String get businessTypeHint;

  /// No description provided for @businessRegistered.
  ///
  /// In ar, this message translates to:
  /// **'نعم، مؤسسة مسجلة'**
  String get businessRegistered;

  /// No description provided for @businessRegisteredDesc.
  ///
  /// In ar, this message translates to:
  /// **'لديك سجل تجاري ورقم جبائي.'**
  String get businessRegisteredDesc;

  /// No description provided for @businessIndividual.
  ///
  /// In ar, this message translates to:
  /// **'لا، نشاط فردي'**
  String get businessIndividual;

  /// No description provided for @businessIndividualDesc.
  ///
  /// In ar, this message translates to:
  /// **'تعمل لحسابك دون سجل تجاري.'**
  String get businessIndividualDesc;

  /// No description provided for @address.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get address;

  /// No description provided for @legalInfo.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات القانونية'**
  String get legalInfo;

  /// No description provided for @docCommercialRegister.
  ///
  /// In ar, this message translates to:
  /// **'السجل التجاري'**
  String get docCommercialRegister;

  /// No description provided for @companyNeedsChangesBanner.
  ///
  /// In ar, this message translates to:
  /// **'طلبت الإدارة تعديلات على ملفك. عدّل المعلومات وأعد الإرسال.'**
  String get companyNeedsChangesBanner;

  /// No description provided for @companySubmittedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال ملفك للمراجعة'**
  String get companySubmittedSuccess;

  /// No description provided for @companyRejectedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض ملف الشركة'**
  String get companyRejectedTitle;

  /// No description provided for @companyRejectedBody.
  ///
  /// In ar, this message translates to:
  /// **'تواصل مع الدعم لمعرفة السبب.'**
  String get companyRejectedBody;

  /// No description provided for @featuredWorks.
  ///
  /// In ar, this message translates to:
  /// **'أعمال مميزة'**
  String get featuredWorks;

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get all;

  /// No description provided for @yes.
  ///
  /// In ar, this message translates to:
  /// **'نعم'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In ar, this message translates to:
  /// **'لا'**
  String get no;

  /// No description provided for @adStatusDraft.
  ///
  /// In ar, this message translates to:
  /// **'مسودة'**
  String get adStatusDraft;

  /// No description provided for @adStatusSubmitted.
  ///
  /// In ar, this message translates to:
  /// **'عند المنصة'**
  String get adStatusSubmitted;

  /// No description provided for @adStatusAwaitingInfluencer.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار المؤثر'**
  String get adStatusAwaitingInfluencer;

  /// No description provided for @adStatusInfluencerReplied.
  ///
  /// In ar, this message translates to:
  /// **'ردّ المؤثر'**
  String get adStatusInfluencerReplied;

  /// No description provided for @adStatusClientReviewing.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار المعلن'**
  String get adStatusClientReviewing;

  /// No description provided for @adStatusClientReviewingYou.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار ردّك'**
  String get adStatusClientReviewingYou;

  /// No description provided for @adStatusClientReplied.
  ///
  /// In ar, this message translates to:
  /// **'ردّ المعلن'**
  String get adStatusClientReplied;

  /// No description provided for @adStatusAgreed.
  ///
  /// In ar, this message translates to:
  /// **'تم الاتفاق'**
  String get adStatusAgreed;

  /// No description provided for @adStatusRejected.
  ///
  /// In ar, this message translates to:
  /// **'مرفوض'**
  String get adStatusRejected;

  /// No description provided for @adFormatPost.
  ///
  /// In ar, this message translates to:
  /// **'منشور'**
  String get adFormatPost;

  /// No description provided for @adFormatReel.
  ///
  /// In ar, this message translates to:
  /// **'ريلز'**
  String get adFormatReel;

  /// No description provided for @adFormatStory.
  ///
  /// In ar, this message translates to:
  /// **'ستوري'**
  String get adFormatStory;

  /// No description provided for @adEntryTemplate.
  ///
  /// In ar, this message translates to:
  /// **'حسب النموذج'**
  String get adEntryTemplate;

  /// No description provided for @adEntryTemplateDesc.
  ///
  /// In ar, this message translates to:
  /// **'تختار نوع المحتوى ومصدره من خيارات جاهزة'**
  String get adEntryTemplateDesc;

  /// No description provided for @adEntryFreeText.
  ///
  /// In ar, this message translates to:
  /// **'حسب الطلب'**
  String get adEntryFreeText;

  /// No description provided for @adEntryFreeTextDesc.
  ///
  /// In ar, this message translates to:
  /// **'تكتب طلبك بكلماتك'**
  String get adEntryFreeTextDesc;

  /// No description provided for @adMediaImage.
  ///
  /// In ar, this message translates to:
  /// **'صورة'**
  String get adMediaImage;

  /// No description provided for @adMediaVideo.
  ///
  /// In ar, this message translates to:
  /// **'فيديو'**
  String get adMediaVideo;

  /// No description provided for @adSourceReady.
  ///
  /// In ar, this message translates to:
  /// **'عندي محتوى جاهز'**
  String get adSourceReady;

  /// No description provided for @adSourceInfluencer.
  ///
  /// In ar, this message translates to:
  /// **'المؤثر يصنع المحتوى'**
  String get adSourceInfluencer;

  /// No description provided for @adEventSubmitted.
  ///
  /// In ar, this message translates to:
  /// **'أُرسل الطلب للمنصة'**
  String get adEventSubmitted;

  /// No description provided for @adEventForwarded.
  ///
  /// In ar, this message translates to:
  /// **'حوّلت المنصة الطلب للمؤثر'**
  String get adEventForwarded;

  /// No description provided for @adEventModificationSent.
  ///
  /// In ar, this message translates to:
  /// **'اقترحت المنصة تعديلاً'**
  String get adEventModificationSent;

  /// No description provided for @adEventModificationAccepted.
  ///
  /// In ar, this message translates to:
  /// **'قُبل التعديل'**
  String get adEventModificationAccepted;

  /// No description provided for @adEventModificationRefused.
  ///
  /// In ar, this message translates to:
  /// **'رُفض التعديل'**
  String get adEventModificationRefused;

  /// No description provided for @adEventInfluencerChanged.
  ///
  /// In ar, this message translates to:
  /// **'تغيّر المؤثر'**
  String get adEventInfluencerChanged;

  /// No description provided for @adEventInfluencerAccepted.
  ///
  /// In ar, this message translates to:
  /// **'وافق المؤثر'**
  String get adEventInfluencerAccepted;

  /// No description provided for @adEventCounterOffer.
  ///
  /// In ar, this message translates to:
  /// **'اقترح المؤثر عرضاً آخر'**
  String get adEventCounterOffer;

  /// No description provided for @adEventUnclear.
  ///
  /// In ar, this message translates to:
  /// **'طلب المؤثر توضيحاً'**
  String get adEventUnclear;

  /// No description provided for @adEventDeclined.
  ///
  /// In ar, this message translates to:
  /// **'اعتذر المؤثر'**
  String get adEventDeclined;

  /// No description provided for @adEventRejected.
  ///
  /// In ar, this message translates to:
  /// **'رُفض الطلب'**
  String get adEventRejected;

  /// No description provided for @adEventUnknown.
  ///
  /// In ar, this message translates to:
  /// **'تحديث على الطلب'**
  String get adEventUnknown;

  /// No description provided for @adPartyClient.
  ///
  /// In ar, this message translates to:
  /// **'المعلن'**
  String get adPartyClient;

  /// No description provided for @adPartyPlatform.
  ///
  /// In ar, this message translates to:
  /// **'المنصة'**
  String get adPartyPlatform;

  /// No description provided for @adPartyInfluencer.
  ///
  /// In ar, this message translates to:
  /// **'المؤثر'**
  String get adPartyInfluencer;

  /// No description provided for @adInfluencer.
  ///
  /// In ar, this message translates to:
  /// **'المؤثر'**
  String get adInfluencer;

  /// No description provided for @adChooseInfluencer.
  ///
  /// In ar, this message translates to:
  /// **'اختر مؤثراً من صفحة الاكتشاف'**
  String get adChooseInfluencer;

  /// No description provided for @adRequiresTravel.
  ///
  /// In ar, this message translates to:
  /// **'يتطلب حضور المؤثر'**
  String get adRequiresTravel;

  /// No description provided for @adRequiresTravelHint.
  ///
  /// In ar, this message translates to:
  /// **'التنقل يُنسَّق بين المنصة والمؤثر خارج التطبيق'**
  String get adRequiresTravelHint;

  /// No description provided for @adTravelAddress.
  ///
  /// In ar, this message translates to:
  /// **'عنوان الحضور'**
  String get adTravelAddress;

  /// No description provided for @adPresenceRequirements.
  ///
  /// In ar, this message translates to:
  /// **'متطلبات الحضور'**
  String get adPresenceRequirements;

  /// No description provided for @adPresenceHint.
  ///
  /// In ar, this message translates to:
  /// **'المدة، اللباس، واش لازم يدير...'**
  String get adPresenceHint;

  /// No description provided for @adEntryMode.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الطلب'**
  String get adEntryMode;

  /// No description provided for @adMediaType.
  ///
  /// In ar, this message translates to:
  /// **'نوع المحتوى'**
  String get adMediaType;

  /// No description provided for @adContentSource.
  ///
  /// In ar, this message translates to:
  /// **'مصدر المحتوى'**
  String get adContentSource;

  /// No description provided for @adSampleRequired.
  ///
  /// In ar, this message translates to:
  /// **'تحب تشوف نموذجاً قبل النشر؟'**
  String get adSampleRequired;

  /// No description provided for @adDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الطلب'**
  String get adDetails;

  /// No description provided for @adDetailsHint.
  ///
  /// In ar, this message translates to:
  /// **'اشرح فكرة الإعلان، الرسالة، والجمهور اللي تستهدفه...'**
  String get adDetailsHint;

  /// No description provided for @adFormats.
  ///
  /// In ar, this message translates to:
  /// **'صيغ الإعلان'**
  String get adFormats;

  /// No description provided for @adPlatforms.
  ///
  /// In ar, this message translates to:
  /// **'المنصات'**
  String get adPlatforms;

  /// No description provided for @adBudget.
  ///
  /// In ar, this message translates to:
  /// **'الميزانية'**
  String get adBudget;

  /// No description provided for @adDeadline.
  ///
  /// In ar, this message translates to:
  /// **'آخر أجل للنشر'**
  String get adDeadline;

  /// No description provided for @adNeedsPlatformServices.
  ///
  /// In ar, this message translates to:
  /// **'أحتاج خدمات المنصة (تصوير، مونتاج...)'**
  String get adNeedsPlatformServices;

  /// No description provided for @adBriefFiles.
  ///
  /// In ar, this message translates to:
  /// **'ملفات توضيحية'**
  String get adBriefFiles;

  /// No description provided for @adBriefFilesHint.
  ///
  /// In ar, this message translates to:
  /// **'صور أو PDF، حتى 10MB'**
  String get adBriefFilesHint;

  /// No description provided for @adReadyContent.
  ///
  /// In ar, this message translates to:
  /// **'المحتوى الجاهز'**
  String get adReadyContent;

  /// No description provided for @adReadyContentHint.
  ///
  /// In ar, this message translates to:
  /// **'صور حتى 10MB، فيديو MP4/MOV حتى 100MB'**
  String get adReadyContentHint;

  /// No description provided for @adAddFile.
  ///
  /// In ar, this message translates to:
  /// **'إضافة ملف'**
  String get adAddFile;

  /// No description provided for @adSend.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الطلب'**
  String get adSend;

  /// No description provided for @adSentTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال الطلب'**
  String get adSentTitle;

  /// No description provided for @adSentBody.
  ///
  /// In ar, this message translates to:
  /// **'طلبك عند المنصة، تراجعه قبل ما تحوّله للمؤثر.'**
  String get adSentBody;

  /// No description provided for @adDeadlineFuture.
  ///
  /// In ar, this message translates to:
  /// **'لازم يكون التاريخ بعد اليوم'**
  String get adDeadlineFuture;

  /// No description provided for @adReadyContentMissing.
  ///
  /// In ar, this message translates to:
  /// **'أضف المحتوى الجاهز'**
  String get adReadyContentMissing;

  /// No description provided for @adFileTooLarge.
  ///
  /// In ar, this message translates to:
  /// **'الملف كبير: الصور حتى 10MB والفيديو حتى 100MB'**
  String get adFileTooLarge;

  /// No description provided for @adInfluencerUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'هذا المؤثر لم يعد متاحاً'**
  String get adInfluencerUnavailable;

  /// No description provided for @adCheckFields.
  ///
  /// In ar, this message translates to:
  /// **'راجع الحقول المعلّمة'**
  String get adCheckFields;

  /// No description provided for @adRequestTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلب {code}'**
  String adRequestTitle(String code);

  /// No description provided for @adPendingModification.
  ///
  /// In ar, this message translates to:
  /// **'تعديل مقترح من المنصة'**
  String get adPendingModification;

  /// No description provided for @adProposedBudget.
  ///
  /// In ar, this message translates to:
  /// **'الميزانية المقترحة'**
  String get adProposedBudget;

  /// No description provided for @adAcceptModification.
  ///
  /// In ar, this message translates to:
  /// **'قبول التعديل'**
  String get adAcceptModification;

  /// No description provided for @adRefuseModification.
  ///
  /// In ar, this message translates to:
  /// **'رفض التعديل'**
  String get adRefuseModification;

  /// No description provided for @adRefuseHint.
  ///
  /// In ar, this message translates to:
  /// **'علاش ترفض التعديل؟'**
  String get adRefuseHint;

  /// No description provided for @adMessageOptional.
  ///
  /// In ar, this message translates to:
  /// **'رسالة (اختياري)'**
  String get adMessageOptional;

  /// No description provided for @adCancelRequest.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الطلب'**
  String get adCancelRequest;

  /// No description provided for @adCancelHint.
  ///
  /// In ar, this message translates to:
  /// **'سبب الإلغاء'**
  String get adCancelHint;

  /// No description provided for @adRejectedBy.
  ///
  /// In ar, this message translates to:
  /// **'رُفض من طرف {party}'**
  String adRejectedBy(String party);

  /// No description provided for @adTimeline.
  ///
  /// In ar, this message translates to:
  /// **'سجل الطلب'**
  String get adTimeline;

  /// No description provided for @adDeleteDraft.
  ///
  /// In ar, this message translates to:
  /// **'حذف المسودة'**
  String get adDeleteDraft;

  /// No description provided for @adDeleteDraftConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تحذف هذي المسودة نهائياً؟'**
  String get adDeleteDraftConfirm;

  /// No description provided for @adAttachments.
  ///
  /// In ar, this message translates to:
  /// **'المرفقات'**
  String get adAttachments;

  /// No description provided for @adWithPlatformServices.
  ///
  /// In ar, this message translates to:
  /// **'مع خدمات المنصة'**
  String get adWithPlatformServices;

  /// No description provided for @adTravel.
  ///
  /// In ar, this message translates to:
  /// **'حضور ميداني'**
  String get adTravel;

  /// No description provided for @adEmpty.
  ///
  /// In ar, this message translates to:
  /// **'ما كاين حتى طلب في هذي الحالة'**
  String get adEmpty;

  /// No description provided for @adUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث الطلب'**
  String get adUpdated;

  /// No description provided for @oppTabRequested.
  ///
  /// In ar, this message translates to:
  /// **'طلبات جديدة'**
  String get oppTabRequested;

  /// No description provided for @oppTabDiscussing.
  ///
  /// In ar, this message translates to:
  /// **'قيد النقاش'**
  String get oppTabDiscussing;

  /// No description provided for @oppEmpty.
  ///
  /// In ar, this message translates to:
  /// **'ما عندك حتى طلب هنا حالياً'**
  String get oppEmpty;

  /// No description provided for @oppClient.
  ///
  /// In ar, this message translates to:
  /// **'المعلن'**
  String get oppClient;

  /// No description provided for @oppClientVerified.
  ///
  /// In ar, this message translates to:
  /// **'معلن موثّق'**
  String get oppClientVerified;

  /// No description provided for @oppClientDeals.
  ///
  /// In ar, this message translates to:
  /// **'صفقات ناجحة: {count}'**
  String oppClientDeals(int count);

  /// No description provided for @oppAccept.
  ///
  /// In ar, this message translates to:
  /// **'قبول الطلب'**
  String get oppAccept;

  /// No description provided for @oppCounter.
  ///
  /// In ar, this message translates to:
  /// **'اقتراح عرض آخر'**
  String get oppCounter;

  /// No description provided for @oppUnclear.
  ///
  /// In ar, this message translates to:
  /// **'طلب توضيح'**
  String get oppUnclear;

  /// No description provided for @oppDecline.
  ///
  /// In ar, this message translates to:
  /// **'اعتذار'**
  String get oppDecline;

  /// No description provided for @oppCounterHint.
  ///
  /// In ar, this message translates to:
  /// **'اشرح اقتراحك'**
  String get oppCounterHint;

  /// No description provided for @oppDeclineHint.
  ///
  /// In ar, this message translates to:
  /// **'سبب الاعتذار'**
  String get oppDeclineHint;

  /// No description provided for @oppUnclearHint.
  ///
  /// In ar, this message translates to:
  /// **'واش اللي ماهوش واضح؟'**
  String get oppUnclearHint;

  /// No description provided for @oppProposedBudgetOptional.
  ///
  /// In ar, this message translates to:
  /// **'الميزانية المقترحة (اختياري)'**
  String get oppProposedBudgetOptional;

  /// No description provided for @oppReplied.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال ردك'**
  String get oppReplied;

  /// No description provided for @oppWaiting.
  ///
  /// In ar, this message translates to:
  /// **'ردّك وصل، المنصة راح تتواصل مع المعلن'**
  String get oppWaiting;

  /// No description provided for @oppAgreed.
  ///
  /// In ar, this message translates to:
  /// **'تم الاتفاق على هذا الإعلان'**
  String get oppAgreed;

  /// No description provided for @catActing.
  ///
  /// In ar, this message translates to:
  /// **'تمثيل و دراما'**
  String get catActing;

  /// No description provided for @catPublicFigures.
  ///
  /// In ar, this message translates to:
  /// **'شخصيات عامة'**
  String get catPublicFigures;

  /// No description provided for @catAgriculture.
  ///
  /// In ar, this message translates to:
  /// **'الفلاحة'**
  String get catAgriculture;

  /// No description provided for @catIndustry.
  ///
  /// In ar, this message translates to:
  /// **'الصناعة'**
  String get catIndustry;

  /// No description provided for @catComedy.
  ///
  /// In ar, this message translates to:
  /// **'كوميديا'**
  String get catComedy;

  /// No description provided for @catRealEstate.
  ///
  /// In ar, this message translates to:
  /// **'العقار و البناء'**
  String get catRealEstate;

  /// No description provided for @regStepPersonal.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الشخصية'**
  String get regStepPersonal;

  /// No description provided for @regStepProfile.
  ///
  /// In ar, this message translates to:
  /// **'معلومات البروفايل'**
  String get regStepProfile;

  /// No description provided for @regStepContact.
  ///
  /// In ar, this message translates to:
  /// **'معلومات الإتصال'**
  String get regStepContact;

  /// No description provided for @regStepSocial.
  ///
  /// In ar, this message translates to:
  /// **'حسابات التواصل الإجتماعي'**
  String get regStepSocial;

  /// No description provided for @regStepOptional.
  ///
  /// In ar, this message translates to:
  /// **'الجمهور والمهارات ومعرض الأعمال'**
  String get regStepOptional;

  /// No description provided for @regStepFinancial.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات المالية'**
  String get regStepFinancial;

  /// No description provided for @regStepSecurity.
  ///
  /// In ar, this message translates to:
  /// **'الموافقات ومعلومات الأمان'**
  String get regStepSecurity;

  /// No description provided for @regStepPhoto.
  ///
  /// In ar, this message translates to:
  /// **'صورة البروفيل'**
  String get regStepPhoto;

  /// No description provided for @regStepDocuments.
  ///
  /// In ar, this message translates to:
  /// **'الوثائق المطلوبة'**
  String get regStepDocuments;

  /// No description provided for @regFullName.
  ///
  /// In ar, this message translates to:
  /// **'الإسم واللقب'**
  String get regFullName;

  /// No description provided for @regEntityQuestion.
  ///
  /// In ar, this message translates to:
  /// **'هل تعتبر نفسك:'**
  String get regEntityQuestion;

  /// No description provided for @regEntityNatural.
  ///
  /// In ar, this message translates to:
  /// **'شخص طبيعي (محتوى شخصي)'**
  String get regEntityNatural;

  /// No description provided for @regEntityLegal.
  ///
  /// In ar, this message translates to:
  /// **'شخص معنوي (صفحة إلكترونية)'**
  String get regEntityLegal;

  /// No description provided for @regDisplayName.
  ///
  /// In ar, this message translates to:
  /// **'إسم الشهرة ( إسم البروفايل )'**
  String get regDisplayName;

  /// No description provided for @regPrimaryCategories.
  ///
  /// In ar, this message translates to:
  /// **'مجالات تأثيرك الرئيسية :'**
  String get regPrimaryCategories;

  /// No description provided for @regSecondaryCategories.
  ///
  /// In ar, this message translates to:
  /// **'مجالات تأثيرك الثانوية'**
  String get regSecondaryCategories;

  /// No description provided for @regBio.
  ///
  /// In ar, this message translates to:
  /// **'نبذة عن المؤثر'**
  String get regBio;

  /// No description provided for @regContentLanguages.
  ///
  /// In ar, this message translates to:
  /// **'اللغات التي يمكنك تقديم محتوى إعلاني بها'**
  String get regContentLanguages;

  /// No description provided for @regOtherLanguageName.
  ///
  /// In ar, this message translates to:
  /// **'أخرى ( تحديد )'**
  String get regOtherLanguageName;

  /// No description provided for @regAddressLanguages.
  ///
  /// In ar, this message translates to:
  /// **'ترتيبات اللغة المفضلة التي تفضل أن يخاطبك بها المعلنون'**
  String get regAddressLanguages;

  /// No description provided for @regAddressLanguagesHint.
  ///
  /// In ar, this message translates to:
  /// **'حتى {count}. لغة الخطاب تستعمل كتنبيه للمعلن عند إدخال إعلانه للتواصل معك'**
  String regAddressLanguagesHint(int count);

  /// No description provided for @langArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get langArabic;

  /// No description provided for @langDarija.
  ///
  /// In ar, this message translates to:
  /// **'الدارجة الجزائرية'**
  String get langDarija;

  /// No description provided for @langAmazigh.
  ///
  /// In ar, this message translates to:
  /// **'الأمازيغية'**
  String get langAmazigh;

  /// No description provided for @langEnglish.
  ///
  /// In ar, this message translates to:
  /// **'الإنجليزية'**
  String get langEnglish;

  /// No description provided for @langFrench.
  ///
  /// In ar, this message translates to:
  /// **'الفرنسية'**
  String get langFrench;

  /// No description provided for @langOther.
  ///
  /// In ar, this message translates to:
  /// **'أخرى'**
  String get langOther;

  /// No description provided for @moveUp.
  ///
  /// In ar, this message translates to:
  /// **'للأعلى'**
  String get moveUp;

  /// No description provided for @moveDown.
  ///
  /// In ar, this message translates to:
  /// **'للأسفل'**
  String get moveDown;

  /// No description provided for @regContactTitle.
  ///
  /// In ar, this message translates to:
  /// **'معلومات الإتصال'**
  String get regContactTitle;

  /// No description provided for @regSocialTitle.
  ///
  /// In ar, this message translates to:
  /// **'معلومات حسابات التواصل الإجتماعي'**
  String get regSocialTitle;

  /// No description provided for @regSocialUrlLabel.
  ///
  /// In ar, this message translates to:
  /// **'أدخل العنوان الالكتروني للمنصة'**
  String get regSocialUrlLabel;

  /// No description provided for @regSocialSubmit.
  ///
  /// In ar, this message translates to:
  /// **'تقديم'**
  String get regSocialSubmit;

  /// No description provided for @regSocialAutoHint.
  ///
  /// In ar, this message translates to:
  /// **'المنصة والصورة والاسم وعدد المتابعين تتعمر تلقائياً وتتجدد بتغيرها'**
  String get regSocialAutoHint;

  /// No description provided for @regSocialAuto.
  ///
  /// In ar, this message translates to:
  /// **'يتحدّث تلقائياً'**
  String get regSocialAuto;

  /// No description provided for @regSocialManual.
  ///
  /// In ar, this message translates to:
  /// **'مدخل يدوياً'**
  String get regSocialManual;

  /// No description provided for @regSocialCompleteManually.
  ///
  /// In ar, this message translates to:
  /// **'أكمل الاسم وعدد المتابعين'**
  String get regSocialCompleteManually;

  /// No description provided for @regSocialNeedsDetails.
  ///
  /// In ar, this message translates to:
  /// **'لم نستطع جلب معلومات هذه المنصة تلقائياً، أدخل الاسم وعدد المتابعين'**
  String get regSocialNeedsDetails;

  /// No description provided for @regSocialDuplicate.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحساب مضاف من قبل'**
  String get regSocialDuplicate;

  /// No description provided for @regRefresh.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get regRefresh;

  /// No description provided for @regOptionalHint.
  ///
  /// In ar, this message translates to:
  /// **'هذه المرحلة غير إلزامية: يمكنك إكمالها الآن أو حتى بعد توثيق حسابك'**
  String get regOptionalHint;

  /// No description provided for @regCompleteOptional.
  ///
  /// In ar, this message translates to:
  /// **'الجمهور والمهارات ومعرض الأعمال'**
  String get regCompleteOptional;

  /// No description provided for @regAudienceTitle.
  ///
  /// In ar, this message translates to:
  /// **'مرحلة حصر الجمهور'**
  String get regAudienceTitle;

  /// No description provided for @regContentTypesTitle.
  ///
  /// In ar, this message translates to:
  /// **'أنواع المحتوى الإعلاني التي يمكنك تقديمها مرتبة حسب الأولوية'**
  String get regContentTypesTitle;

  /// No description provided for @regPortfolioTitle.
  ///
  /// In ar, this message translates to:
  /// **'رفع أمثلة لمعرض أعمالك '**
  String get regPortfolioTitle;

  /// No description provided for @regPortfolioFile.
  ///
  /// In ar, this message translates to:
  /// **'رفع ملف (صورة، فيديو، PDF)'**
  String get regPortfolioFile;

  /// No description provided for @regPortfolioLinkOrFile.
  ///
  /// In ar, this message translates to:
  /// **'أضف رابطاً أو ارفع ملفاً'**
  String get regPortfolioLinkOrFile;

  /// No description provided for @regSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم الحفظ'**
  String get regSaved;

  /// No description provided for @audCountries.
  ///
  /// In ar, this message translates to:
  /// **'الموقع الجغرافي للجمهور: الدول الأكثر متابعة'**
  String get audCountries;

  /// No description provided for @audCountryName.
  ///
  /// In ar, this message translates to:
  /// **'الدولة'**
  String get audCountryName;

  /// No description provided for @audAddCountry.
  ///
  /// In ar, this message translates to:
  /// **'إضافة دولة'**
  String get audAddCountry;

  /// No description provided for @audRegionsHint.
  ///
  /// In ar, this message translates to:
  /// **'لا تحدد كل المناطق، اكتفِ بما يساعد فقط'**
  String get audRegionsHint;

  /// No description provided for @regionNorth.
  ///
  /// In ar, this message translates to:
  /// **'شمال'**
  String get regionNorth;

  /// No description provided for @regionNorthEast.
  ///
  /// In ar, this message translates to:
  /// **'شمال شرقي'**
  String get regionNorthEast;

  /// No description provided for @regionNorthWest.
  ///
  /// In ar, this message translates to:
  /// **'شمال غربي'**
  String get regionNorthWest;

  /// No description provided for @regionCenter.
  ///
  /// In ar, this message translates to:
  /// **'وسط'**
  String get regionCenter;

  /// No description provided for @regionCenterEast.
  ///
  /// In ar, this message translates to:
  /// **'وسط شرقي'**
  String get regionCenterEast;

  /// No description provided for @regionCenterWest.
  ///
  /// In ar, this message translates to:
  /// **'وسط غربي'**
  String get regionCenterWest;

  /// No description provided for @regionSouth.
  ///
  /// In ar, this message translates to:
  /// **'جنوب'**
  String get regionSouth;

  /// No description provided for @regionSouthEast.
  ///
  /// In ar, this message translates to:
  /// **'جنوب شرقي'**
  String get regionSouthEast;

  /// No description provided for @regionSouthWest.
  ///
  /// In ar, this message translates to:
  /// **'جنوب غربي'**
  String get regionSouthWest;

  /// No description provided for @audGender.
  ///
  /// In ar, this message translates to:
  /// **'الجنس'**
  String get audGender;

  /// No description provided for @audMale.
  ///
  /// In ar, this message translates to:
  /// **'ذكور'**
  String get audMale;

  /// No description provided for @audFemale.
  ///
  /// In ar, this message translates to:
  /// **'إناث'**
  String get audFemale;

  /// No description provided for @audUnspecified.
  ///
  /// In ar, this message translates to:
  /// **'غير محدد'**
  String get audUnspecified;

  /// No description provided for @audAges.
  ///
  /// In ar, this message translates to:
  /// **'الفئة العمرية'**
  String get audAges;

  /// No description provided for @audAgeUnder18.
  ///
  /// In ar, this message translates to:
  /// **'أقل من 18'**
  String get audAgeUnder18;

  /// No description provided for @audLanguages.
  ///
  /// In ar, this message translates to:
  /// **'اللغة / اللهجة'**
  String get audLanguages;

  /// No description provided for @audLangArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية (دارجة / فصحى)'**
  String get audLangArabic;

  /// No description provided for @audLangAmazigh.
  ///
  /// In ar, this message translates to:
  /// **'الأمازيغية'**
  String get audLangAmazigh;

  /// No description provided for @audLangEnglish.
  ///
  /// In ar, this message translates to:
  /// **'الإنجليزية'**
  String get audLangEnglish;

  /// No description provided for @audLangFrench.
  ///
  /// In ar, this message translates to:
  /// **'الفرنسية'**
  String get audLangFrench;

  /// No description provided for @audLangMixed.
  ///
  /// In ar, this message translates to:
  /// **'مزيج لغوي'**
  String get audLangMixed;

  /// No description provided for @audTopPlatforms.
  ///
  /// In ar, this message translates to:
  /// **'المنصة الأساسية'**
  String get audTopPlatforms;

  /// No description provided for @audTopPlatformsHint.
  ///
  /// In ar, this message translates to:
  /// **'رتب 3 منصات: يستعمل هذا لإبرازها في الأول عند العرض للعميل'**
  String get audTopPlatformsHint;

  /// No description provided for @audActivity.
  ///
  /// In ar, this message translates to:
  /// **'توقيت النشاط ( غير إلزامي )'**
  String get audActivity;

  /// No description provided for @audPeakDays.
  ///
  /// In ar, this message translates to:
  /// **'أيام الذروة'**
  String get audPeakDays;

  /// No description provided for @audPeakHours.
  ///
  /// In ar, this message translates to:
  /// **'ساعات الذروة'**
  String get audPeakHours;

  /// No description provided for @audFrom.
  ///
  /// In ar, this message translates to:
  /// **'من'**
  String get audFrom;

  /// No description provided for @audTo.
  ///
  /// In ar, this message translates to:
  /// **'إلى'**
  String get audTo;

  /// No description provided for @daySat.
  ///
  /// In ar, this message translates to:
  /// **'السبت'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In ar, this message translates to:
  /// **'الأحد'**
  String get daySun;

  /// No description provided for @dayMon.
  ///
  /// In ar, this message translates to:
  /// **'الإثنين'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In ar, this message translates to:
  /// **'الثلاثاء'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In ar, this message translates to:
  /// **'الأربعاء'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In ar, this message translates to:
  /// **'الخميس'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In ar, this message translates to:
  /// **'الجمعة'**
  String get dayFri;

  /// No description provided for @audContent.
  ///
  /// In ar, this message translates to:
  /// **'نوع المحتوى الأكثر تفاعلاً'**
  String get audContent;

  /// No description provided for @audVideo.
  ///
  /// In ar, this message translates to:
  /// **'فيديو'**
  String get audVideo;

  /// No description provided for @audPhoto.
  ///
  /// In ar, this message translates to:
  /// **'صور'**
  String get audPhoto;

  /// No description provided for @adctReview.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة منتج (Review)'**
  String get adctReview;

  /// No description provided for @adctTestTry.
  ///
  /// In ar, this message translates to:
  /// **'تجربة منتج (Test & Try)'**
  String get adctTestTry;

  /// No description provided for @adctUnboxing.
  ///
  /// In ar, this message translates to:
  /// **'فتح صندوق (Unboxing)'**
  String get adctUnboxing;

  /// No description provided for @adctTutorial.
  ///
  /// In ar, this message translates to:
  /// **'شرح / Tutorial'**
  String get adctTutorial;

  /// No description provided for @adctRecommendation.
  ///
  /// In ar, this message translates to:
  /// **'توصية شخصية'**
  String get adctRecommendation;

  /// No description provided for @adctDirectCta.
  ///
  /// In ar, this message translates to:
  /// **'إعلان مباشر (Call to Action)'**
  String get adctDirectCta;

  /// No description provided for @adctStorytelling.
  ///
  /// In ar, this message translates to:
  /// **'Storytelling'**
  String get adctStorytelling;

  /// No description provided for @adctProductPlacement.
  ///
  /// In ar, this message translates to:
  /// **'محتوى مدمج (Product Placement)'**
  String get adctProductPlacement;

  /// No description provided for @regFinancialTitle.
  ///
  /// In ar, this message translates to:
  /// **'المؤسسات المالية التي تتعامل معها + أرقام حساباتك المالية في كل واحد منها'**
  String get regFinancialTitle;

  /// No description provided for @regAddInstitution.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مؤسسة مالية'**
  String get regAddInstitution;

  /// No description provided for @finCcp.
  ///
  /// In ar, this message translates to:
  /// **'بريد الجزائر (CCP)'**
  String get finCcp;

  /// No description provided for @finBank.
  ///
  /// In ar, this message translates to:
  /// **'بنك'**
  String get finBank;

  /// No description provided for @finInstitution.
  ///
  /// In ar, this message translates to:
  /// **'اسم البنك'**
  String get finInstitution;

  /// No description provided for @finCcpNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الحساب'**
  String get finCcpNumber;

  /// No description provided for @finCcpNumberInvalid.
  ///
  /// In ar, this message translates to:
  /// **'أرقام فقط (حتى 12)'**
  String get finCcpNumberInvalid;

  /// No description provided for @finRib.
  ///
  /// In ar, this message translates to:
  /// **'رقم RIB (20 رقم)'**
  String get finRib;

  /// No description provided for @finEmpty.
  ///
  /// In ar, this message translates to:
  /// **'أضف مؤسسة مالية واحدة على الأقل'**
  String get finEmpty;

  /// No description provided for @finMissingDoc.
  ///
  /// In ar, this message translates to:
  /// **'ارفع الصك أو الشيك لكل حساب'**
  String get finMissingDoc;

  /// No description provided for @regConsentPrivacy.
  ///
  /// In ar, this message translates to:
  /// **'الإمتثال للتشريعات الخاصة بحماية البيانات الشخصية'**
  String get regConsentPrivacy;

  /// No description provided for @regConsentTerms.
  ///
  /// In ar, this message translates to:
  /// **'الموافقة على الشروط و الأحكام ( إجباري )'**
  String get regConsentTerms;

  /// No description provided for @regSecurityTitle.
  ///
  /// In ar, this message translates to:
  /// **'معلومات الأمان'**
  String get regSecurityTitle;

  /// No description provided for @regLoginWith.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get regLoginWith;

  /// No description provided for @regLoginInfo.
  ///
  /// In ar, this message translates to:
  /// **'{email} + كلمة السر التي اخترتها عند إنشاء الحساب'**
  String regLoginInfo(String email);

  /// No description provided for @regRecoveryTitle.
  ///
  /// In ar, this message translates to:
  /// **'طريقة إسترداد الحساب'**
  String get regRecoveryTitle;

  /// No description provided for @regRecoveryHint.
  ///
  /// In ar, this message translates to:
  /// **'تحديد وسيلة إسترجاع كلمة السر'**
  String get regRecoveryHint;

  /// No description provided for @recPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف: {phone}'**
  String recPhone(String phone);

  /// No description provided for @recWhatsapp.
  ///
  /// In ar, this message translates to:
  /// **'واتساب: {phone}'**
  String recWhatsapp(String phone);

  /// No description provided for @recEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني: {email}'**
  String recEmail(String email);

  /// No description provided for @recOther.
  ///
  /// In ar, this message translates to:
  /// **'رقم آخر مسؤول عن إسترجاع كلمة السر'**
  String get recOther;

  /// No description provided for @recOtherPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الإسترجاع'**
  String get recOtherPhone;

  /// No description provided for @regPhotoTitle.
  ///
  /// In ar, this message translates to:
  /// **'صورة البروفيل'**
  String get regPhotoTitle;

  /// No description provided for @regPhotoSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تظهر في بروفايلك للمعلنين'**
  String get regPhotoSubtitle;

  /// No description provided for @regDocumentsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الوثائق المطلوبة للرفع: بطاقة التعريف أو جواز السفر'**
  String get regDocumentsTitle;

  /// No description provided for @regIdCard.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة التعريف'**
  String get regIdCard;

  /// No description provided for @docPassport.
  ///
  /// In ar, this message translates to:
  /// **'جواز السفر'**
  String get docPassport;

  /// No description provided for @regFromFiles.
  ///
  /// In ar, this message translates to:
  /// **'ملف (PDF أو صورة)'**
  String get regFromFiles;

  /// No description provided for @regChequesHint.
  ///
  /// In ar, this message translates to:
  /// **'الصكوك والشيكات ترفع مع كل حساب في المعلومات المالية'**
  String get regChequesHint;

  /// No description provided for @regNeedsReview.
  ///
  /// In ar, this message translates to:
  /// **'ستتم مراجعتها في الاجتماع'**
  String get regNeedsReview;

  /// No description provided for @regSubmittedMessage.
  ///
  /// In ar, this message translates to:
  /// **'لقد تم تسجيل طلبك سيتم مراجعة ملفك لإستكماله في حالة النقصان أو عدم وضوح بعض الوثائق\nو سيتم برمجة اجتماع لك مع إدارة المنصة عن طريق مكالمة فيديوا للتأكد من صحة المعلومات المقدمة\nيجب تحضير الوثائق التالية أثناء تاريخ الاجتماع بطاقة التعريف الأصلية أو جواز السفر + وثيقة تحمل أرقام معلوماتك المالية المدخلة ( صك بريدي / شيك بنكي ) + إثباتات الوصول للمنصات المدخلة ( الوصول للمنصات أثناء مكالمة الفيديوا )'**
  String get regSubmittedMessage;

  /// No description provided for @docUnrecognized.
  ///
  /// In ar, this message translates to:
  /// **'لم نتعرف على الوثيقة. صوّرها كاملة بإضاءة جيدة وأعد المحاولة'**
  String get docUnrecognized;

  /// No description provided for @screenshotUnrecognized.
  ///
  /// In ar, this message translates to:
  /// **'لم نجد الأرقام في اللقطة. خذ لقطة للصفحة كاملة'**
  String get screenshotUnrecognized;

  /// No description provided for @ocrUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'القراءة الآلية غير متاحة حالياً، أدخل المعلومات يدوياً'**
  String get ocrUnavailable;

  /// No description provided for @docAcceptUnreadableTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعذّرت قراءة الوثيقة'**
  String get docAcceptUnreadableTitle;

  /// No description provided for @docAcceptUnreadableBody.
  ///
  /// In ar, this message translates to:
  /// **'بعد 3 محاولات، يمكننا إرسال الوثيقة كما هي لتُراجع يدوياً في اجتماع التوثيق.'**
  String get docAcceptUnreadableBody;

  /// No description provided for @docSendForReview.
  ///
  /// In ar, this message translates to:
  /// **'أرسلها للمراجعة'**
  String get docSendForReview;

  /// No description provided for @regDocChecked.
  ///
  /// In ar, this message translates to:
  /// **'تم التحقق منها آلياً'**
  String get regDocChecked;

  /// No description provided for @docFinancialProof.
  ///
  /// In ar, this message translates to:
  /// **'إثبات الحساب (صك، شيك أو RIB)'**
  String get docFinancialProof;

  /// No description provided for @finOther.
  ///
  /// In ar, this message translates to:
  /// **'مؤسسة مالية'**
  String get finOther;

  /// No description provided for @finScanHint.
  ///
  /// In ar, this message translates to:
  /// **'صوّر الصك أو الشيك ونملأ اسم المؤسسة ورقم الحساب تلقائياً. كل المؤسسات المالية مقبولة'**
  String get finScanHint;

  /// No description provided for @finScanCheque.
  ///
  /// In ar, this message translates to:
  /// **'صوّر الصك أو الشيك'**
  String get finScanCheque;

  /// No description provided for @finManualEntry.
  ///
  /// In ar, this message translates to:
  /// **'أدخل يدوياً'**
  String get finManualEntry;

  /// No description provided for @finCompleteScanned.
  ///
  /// In ar, this message translates to:
  /// **'قرأنا جزءاً من المعلومات، أكمل الباقي'**
  String get finCompleteScanned;

  /// No description provided for @finScanManualAfterTries.
  ///
  /// In ar, this message translates to:
  /// **'أدخل معلومات الحساب يدوياً، وستُراجع الصورة في الاجتماع'**
  String get finScanManualAfterTries;

  /// No description provided for @finKeyMismatch.
  ///
  /// In ar, this message translates to:
  /// **'المفتاح لا يطابق الرقم، سيتم التحقق منه في الاجتماع'**
  String get finKeyMismatch;

  /// No description provided for @finInstitutionName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المؤسسة المالية'**
  String get finInstitutionName;

  /// No description provided for @finInstitutionHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: بريد الجزائر، BNA، CPA، Payoneer'**
  String get finInstitutionHint;

  /// No description provided for @finAccountNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الحساب'**
  String get finAccountNumber;

  /// No description provided for @finAccountNumberHint.
  ///
  /// In ar, this message translates to:
  /// **'CCP أو RIB أو IBAN أو أي رقم آخر'**
  String get finAccountNumberHint;

  /// No description provided for @finAccountKey.
  ///
  /// In ar, this message translates to:
  /// **'المفتاح (اختياري)'**
  String get finAccountKey;

  /// No description provided for @finNumberInvalid.
  ///
  /// In ar, this message translates to:
  /// **'أرقام وحروف لاتينية فقط (من 4 إلى 40)'**
  String get finNumberInvalid;

  /// No description provided for @finKeyInvalid.
  ///
  /// In ar, this message translates to:
  /// **'المفتاح رقمان'**
  String get finKeyInvalid;

  /// No description provided for @scanFilled.
  ///
  /// In ar, this message translates to:
  /// **'ملأنا المعلومات من الوثيقة، راجعها قبل المتابعة'**
  String get scanFilled;

  /// No description provided for @scanFromIdTitle.
  ///
  /// In ar, this message translates to:
  /// **'املأ معلوماتك من الوثيقة'**
  String get scanFromIdTitle;

  /// No description provided for @scanFromIdHint.
  ///
  /// In ar, this message translates to:
  /// **'صوّر بطاقة التعريف أو جواز السفر ونملأ الاسم واللقب وتاريخ ومكان الميلاد تلقائياً'**
  String get scanFromIdHint;

  /// No description provided for @screenshotManualAfterTries.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الاسم وعدد المتابعين يدوياً، وسيتم التحقق منهما في الاجتماع'**
  String get screenshotManualAfterTries;

  /// No description provided for @screenshotApplied.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث عدد المتابعين من اللقطة'**
  String get screenshotApplied;

  /// No description provided for @socialScreenshotHint.
  ///
  /// In ar, this message translates to:
  /// **'هذه المنصة لا تعطي الأرقام مباشرة. خذ لقطة شاشة لصفحة بروفايلك يظهر فيها عدد المتابعين'**
  String get socialScreenshotHint;

  /// No description provided for @socialScreenshotButton.
  ///
  /// In ar, this message translates to:
  /// **'ارفع لقطة شاشة لبروفايلك'**
  String get socialScreenshotButton;

  /// No description provided for @regSocialFromScreenshot.
  ///
  /// In ar, this message translates to:
  /// **'من لقطة شاشة'**
  String get regSocialFromScreenshot;

  /// No description provided for @audScanPlatform.
  ///
  /// In ar, this message translates to:
  /// **'من أي منصة هذه اللقطات؟'**
  String get audScanPlatform;

  /// No description provided for @audScanHint.
  ///
  /// In ar, this message translates to:
  /// **'ارفع لقطات الإحصائيات (Insights): الجنس، الأعمار، المدن، الدول... ونملأ النسب تلقائياً، ثم راجعها واحفظ'**
  String get audScanHint;

  /// No description provided for @audScanTitle.
  ///
  /// In ar, this message translates to:
  /// **'املأ من لقطات Insights'**
  String get audScanTitle;

  /// No description provided for @docUnrecognizedRetry.
  ///
  /// In ar, this message translates to:
  /// **'لم نتعرف على الوثيقة. صوّرها كاملة بإضاءة جيدة (المحاولة {attempt} من {max})'**
  String docUnrecognizedRetry(int attempt, int max);

  /// No description provided for @screenshotUnrecognizedRetry.
  ///
  /// In ar, this message translates to:
  /// **'لم نجد عدد المتابعين في اللقطة. خذ لقطة لصفحة البروفايل كاملة (المحاولة {attempt} من {max})'**
  String screenshotUnrecognizedRetry(int attempt, int max);

  /// No description provided for @finAdded.
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة الحساب: {name}'**
  String finAdded(String name);

  /// No description provided for @audScanDone.
  ///
  /// In ar, this message translates to:
  /// **'ملأنا {count} أقسام من اللقطات، راجع النسب ثم احفظ'**
  String audScanDone(int count);

  /// No description provided for @screenshotWrongPlatform.
  ///
  /// In ar, this message translates to:
  /// **'اللقطة ليست من نفس منصة الحساب'**
  String get screenshotWrongPlatform;

  /// No description provided for @screenshotWrongAccount.
  ///
  /// In ar, this message translates to:
  /// **'اللقطة لحساب آخر: اسم المستخدم لا يطابق الرابط'**
  String get screenshotWrongAccount;

  /// No description provided for @bizSectorFoodBeverage.
  ///
  /// In ar, this message translates to:
  /// **'الأغذية والمشروبات'**
  String get bizSectorFoodBeverage;

  /// No description provided for @bizSectorTrade.
  ///
  /// In ar, this message translates to:
  /// **'التجارة والبيع'**
  String get bizSectorTrade;

  /// No description provided for @bizSectorIndustry.
  ///
  /// In ar, this message translates to:
  /// **'الصناعة والإنتاج'**
  String get bizSectorIndustry;

  /// No description provided for @bizSectorAgriculture.
  ///
  /// In ar, this message translates to:
  /// **'الفلاحة والمنتجات الزراعية'**
  String get bizSectorAgriculture;

  /// No description provided for @bizSectorRealEstate.
  ///
  /// In ar, this message translates to:
  /// **'العقار والإنشاءات'**
  String get bizSectorRealEstate;

  /// No description provided for @bizSectorTransport.
  ///
  /// In ar, this message translates to:
  /// **'النقل واللوجستيك'**
  String get bizSectorTransport;

  /// No description provided for @bizSectorHealth.
  ///
  /// In ar, this message translates to:
  /// **'الصحة والخدمات الطبية'**
  String get bizSectorHealth;

  /// No description provided for @bizSectorEducation.
  ///
  /// In ar, this message translates to:
  /// **'التعليم والتكوين'**
  String get bizSectorEducation;

  /// No description provided for @bizSectorTelecomTech.
  ///
  /// In ar, this message translates to:
  /// **'الاتصالات والتكنولوجيا'**
  String get bizSectorTelecomTech;

  /// No description provided for @bizSectorTourism.
  ///
  /// In ar, this message translates to:
  /// **'السياحة والترفيه'**
  String get bizSectorTourism;

  /// No description provided for @bizSectorBeauty.
  ///
  /// In ar, this message translates to:
  /// **'الجمال والعناية الشخصية'**
  String get bizSectorBeauty;

  /// No description provided for @bizSectorFashion.
  ///
  /// In ar, this message translates to:
  /// **'الأزياء والموضة'**
  String get bizSectorFashion;

  /// No description provided for @bizSectorAutomotive.
  ///
  /// In ar, this message translates to:
  /// **'السيارات والنقل الخاص'**
  String get bizSectorAutomotive;

  /// No description provided for @bizSectorProfessionalServices.
  ///
  /// In ar, this message translates to:
  /// **'الخدمات المهنية'**
  String get bizSectorProfessionalServices;

  /// No description provided for @bizSectorMedia.
  ///
  /// In ar, this message translates to:
  /// **'الإعلام والاتصال'**
  String get bizSectorMedia;

  /// No description provided for @bizSectorHomeServices.
  ///
  /// In ar, this message translates to:
  /// **'الخدمات المنزلية'**
  String get bizSectorHomeServices;

  /// No description provided for @bizSectorConglomerates.
  ///
  /// In ar, this message translates to:
  /// **'مجمّعات وشركات متعددة الأنشطة'**
  String get bizSectorConglomerates;

  /// No description provided for @bizSectorGovernment.
  ///
  /// In ar, this message translates to:
  /// **'الجهات الحكومية والشبه حكومية'**
  String get bizSectorGovernment;

  /// No description provided for @bizSectorIndividuals.
  ///
  /// In ar, this message translates to:
  /// **'أفراد / أنشطة مستقلة'**
  String get bizSectorIndividuals;

  /// No description provided for @bizSectorOther.
  ///
  /// In ar, this message translates to:
  /// **'أخرى'**
  String get bizSectorOther;

  /// No description provided for @bizActivityRestaurants.
  ///
  /// In ar, this message translates to:
  /// **'مطاعم'**
  String get bizActivityRestaurants;

  /// No description provided for @bizActivityCafes.
  ///
  /// In ar, this message translates to:
  /// **'مقاهي'**
  String get bizActivityCafes;

  /// No description provided for @bizActivityFoodFactories.
  ///
  /// In ar, this message translates to:
  /// **'مصانع غذائية'**
  String get bizActivityFoodFactories;

  /// No description provided for @bizActivityFoodDistribution.
  ///
  /// In ar, this message translates to:
  /// **'توزيع مواد غذائية'**
  String get bizActivityFoodDistribution;

  /// No description provided for @bizActivityRetail.
  ///
  /// In ar, this message translates to:
  /// **'متاجر تجزئة'**
  String get bizActivityRetail;

  /// No description provided for @bizActivityWholesale.
  ///
  /// In ar, this message translates to:
  /// **'تجارة جملة'**
  String get bizActivityWholesale;

  /// No description provided for @bizActivityOnlineSales.
  ///
  /// In ar, this message translates to:
  /// **'بيع عبر الإنترنت'**
  String get bizActivityOnlineSales;

  /// No description provided for @bizActivityLocalMarkets.
  ///
  /// In ar, this message translates to:
  /// **'أسواق محلية'**
  String get bizActivityLocalMarkets;

  /// No description provided for @bizActivityManufacturing.
  ///
  /// In ar, this message translates to:
  /// **'صناعة تحويلية'**
  String get bizActivityManufacturing;

  /// No description provided for @bizActivityFactories.
  ///
  /// In ar, this message translates to:
  /// **'مصانع'**
  String get bizActivityFactories;

  /// No description provided for @bizActivityMaterialsProduction.
  ///
  /// In ar, this message translates to:
  /// **'إنتاج مواد'**
  String get bizActivityMaterialsProduction;

  /// No description provided for @bizActivityFarming.
  ///
  /// In ar, this message translates to:
  /// **'إنتاج فلاحي'**
  String get bizActivityFarming;

  /// No description provided for @bizActivityLivestock.
  ///
  /// In ar, this message translates to:
  /// **'تربية'**
  String get bizActivityLivestock;

  /// No description provided for @bizActivityAgriProcessing.
  ///
  /// In ar, this message translates to:
  /// **'تحويل زراعي'**
  String get bizActivityAgriProcessing;

  /// No description provided for @bizActivityRealEstateDevelopment.
  ///
  /// In ar, this message translates to:
  /// **'تطوير عقاري'**
  String get bizActivityRealEstateDevelopment;

  /// No description provided for @bizActivityContracting.
  ///
  /// In ar, this message translates to:
  /// **'مقاولات'**
  String get bizActivityContracting;

  /// No description provided for @bizActivityPublicWorks.
  ///
  /// In ar, this message translates to:
  /// **'أشغال عامة'**
  String get bizActivityPublicWorks;

  /// No description provided for @bizActivityFreightTransport.
  ///
  /// In ar, this message translates to:
  /// **'نقل بري / بحري / جوي'**
  String get bizActivityFreightTransport;

  /// No description provided for @bizActivityWarehousing.
  ///
  /// In ar, this message translates to:
  /// **'تخزين'**
  String get bizActivityWarehousing;

  /// No description provided for @bizActivityLogisticsDistribution.
  ///
  /// In ar, this message translates to:
  /// **'توزيع'**
  String get bizActivityLogisticsDistribution;

  /// No description provided for @bizActivityDelivery.
  ///
  /// In ar, this message translates to:
  /// **'توصيل'**
  String get bizActivityDelivery;

  /// No description provided for @bizActivityClinics.
  ///
  /// In ar, this message translates to:
  /// **'عيادات'**
  String get bizActivityClinics;

  /// No description provided for @bizActivityLaboratories.
  ///
  /// In ar, this message translates to:
  /// **'مخابر'**
  String get bizActivityLaboratories;

  /// No description provided for @bizActivityPharmacies.
  ///
  /// In ar, this message translates to:
  /// **'صيدليات'**
  String get bizActivityPharmacies;

  /// No description provided for @bizActivityMedicalManufacturing.
  ///
  /// In ar, this message translates to:
  /// **'تصنيع طبي'**
  String get bizActivityMedicalManufacturing;

  /// No description provided for @bizActivitySchools.
  ///
  /// In ar, this message translates to:
  /// **'مدارس'**
  String get bizActivitySchools;

  /// No description provided for @bizActivityUniversities.
  ///
  /// In ar, this message translates to:
  /// **'جامعات'**
  String get bizActivityUniversities;

  /// No description provided for @bizActivityTrainingCenters.
  ///
  /// In ar, this message translates to:
  /// **'مراكز تدريب'**
  String get bizActivityTrainingCenters;

  /// No description provided for @bizActivityPrivateEducation.
  ///
  /// In ar, this message translates to:
  /// **'تعليم خاص'**
  String get bizActivityPrivateEducation;

  /// No description provided for @bizActivityTelecom.
  ///
  /// In ar, this message translates to:
  /// **'اتصالات'**
  String get bizActivityTelecom;

  /// No description provided for @bizActivityTechCompanies.
  ///
  /// In ar, this message translates to:
  /// **'شركات تقنية'**
  String get bizActivityTechCompanies;

  /// No description provided for @bizActivityDigitalServices.
  ///
  /// In ar, this message translates to:
  /// **'خدمات رقمية'**
  String get bizActivityDigitalServices;

  /// No description provided for @bizActivityHotels.
  ///
  /// In ar, this message translates to:
  /// **'فنادق'**
  String get bizActivityHotels;

  /// No description provided for @bizActivityTravelAgencies.
  ///
  /// In ar, this message translates to:
  /// **'وكالات سفر'**
  String get bizActivityTravelAgencies;

  /// No description provided for @bizActivityResorts.
  ///
  /// In ar, this message translates to:
  /// **'منتجعات'**
  String get bizActivityResorts;

  /// No description provided for @bizActivityLeisure.
  ///
  /// In ar, this message translates to:
  /// **'نشاطات ترفيهية'**
  String get bizActivityLeisure;

  /// No description provided for @bizActivitySalons.
  ///
  /// In ar, this message translates to:
  /// **'صالونات'**
  String get bizActivitySalons;

  /// No description provided for @bizActivityCosmeticClinics.
  ///
  /// In ar, this message translates to:
  /// **'عيادات تجميل'**
  String get bizActivityCosmeticClinics;

  /// No description provided for @bizActivityCareProducts.
  ///
  /// In ar, this message translates to:
  /// **'منتجات عناية'**
  String get bizActivityCareProducts;

  /// No description provided for @bizActivityClothingStores.
  ///
  /// In ar, this message translates to:
  /// **'محلات ملابس'**
  String get bizActivityClothingStores;

  /// No description provided for @bizActivityFashionDesign.
  ///
  /// In ar, this message translates to:
  /// **'تصميم أزياء'**
  String get bizActivityFashionDesign;

  /// No description provided for @bizActivityFashionDistribution.
  ///
  /// In ar, this message translates to:
  /// **'توزيع'**
  String get bizActivityFashionDistribution;

  /// No description provided for @bizActivityCarSales.
  ///
  /// In ar, this message translates to:
  /// **'بيع سيارات'**
  String get bizActivityCarSales;

  /// No description provided for @bizActivityCarMaintenance.
  ///
  /// In ar, this message translates to:
  /// **'صيانة'**
  String get bizActivityCarMaintenance;

  /// No description provided for @bizActivityCarRental.
  ///
  /// In ar, this message translates to:
  /// **'كراء'**
  String get bizActivityCarRental;

  /// No description provided for @bizActivityLaw.
  ///
  /// In ar, this message translates to:
  /// **'محاماة'**
  String get bizActivityLaw;

  /// No description provided for @bizActivityAccounting.
  ///
  /// In ar, this message translates to:
  /// **'محاسبة'**
  String get bizActivityAccounting;

  /// No description provided for @bizActivityConsulting.
  ///
  /// In ar, this message translates to:
  /// **'استشارات'**
  String get bizActivityConsulting;

  /// No description provided for @bizActivityAdministrativeServices.
  ///
  /// In ar, this message translates to:
  /// **'خدمات إدارية'**
  String get bizActivityAdministrativeServices;

  /// No description provided for @bizActivityMediaProduction.
  ///
  /// In ar, this message translates to:
  /// **'إنتاج إعلامي'**
  String get bizActivityMediaProduction;

  /// No description provided for @bizActivityAdAgencies.
  ///
  /// In ar, this message translates to:
  /// **'وكالات إشهار'**
  String get bizActivityAdAgencies;

  /// No description provided for @bizActivityEvents.
  ///
  /// In ar, this message translates to:
  /// **'تنظيم فعاليات'**
  String get bizActivityEvents;

  /// No description provided for @bizActivityHomeMaintenance.
  ///
  /// In ar, this message translates to:
  /// **'صيانة'**
  String get bizActivityHomeMaintenance;

  /// No description provided for @bizActivityCleaning.
  ///
  /// In ar, this message translates to:
  /// **'تنظيف'**
  String get bizActivityCleaning;

  /// No description provided for @bizActivitySmallWorks.
  ///
  /// In ar, this message translates to:
  /// **'أشغال صغيرة'**
  String get bizActivitySmallWorks;

  /// No description provided for @bizActivityHoldings.
  ///
  /// In ar, this message translates to:
  /// **'شركات قابضة'**
  String get bizActivityHoldings;

  /// No description provided for @bizActivityInvestmentGroups.
  ///
  /// In ar, this message translates to:
  /// **'مجموعات استثمارية'**
  String get bizActivityInvestmentGroups;

  /// No description provided for @bizActivityFinancialInstitutions.
  ///
  /// In ar, this message translates to:
  /// **'مؤسسات مالية'**
  String get bizActivityFinancialInstitutions;

  /// No description provided for @bizActivityMinistries.
  ///
  /// In ar, this message translates to:
  /// **'وزارات'**
  String get bizActivityMinistries;

  /// No description provided for @bizActivityNationalCompanies.
  ///
  /// In ar, this message translates to:
  /// **'شركة وطنية'**
  String get bizActivityNationalCompanies;

  /// No description provided for @bizActivityNonProfits.
  ///
  /// In ar, this message translates to:
  /// **'جمعيات ومنظمات غير ربحية'**
  String get bizActivityNonProfits;

  /// No description provided for @bizActivityFreelancer.
  ///
  /// In ar, this message translates to:
  /// **'فريلانسر'**
  String get bizActivityFreelancer;

  /// No description provided for @bizActivitySoloActivity.
  ///
  /// In ar, this message translates to:
  /// **'نشاط فردي'**
  String get bizActivitySoloActivity;

  /// No description provided for @bizActivitySmallProjects.
  ///
  /// In ar, this message translates to:
  /// **'مشاريع صغيرة'**
  String get bizActivitySmallProjects;

  /// No description provided for @bizActivityOther.
  ///
  /// In ar, this message translates to:
  /// **'أخرى (حدد)'**
  String get bizActivityOther;

  /// No description provided for @companyRoleOwner.
  ///
  /// In ar, this message translates to:
  /// **'المالك'**
  String get companyRoleOwner;

  /// No description provided for @companyRoleMarketingOfficer.
  ///
  /// In ar, this message translates to:
  /// **'المكلف بالتسويق'**
  String get companyRoleMarketingOfficer;

  /// No description provided for @companyRoleCompanyOwner.
  ///
  /// In ar, this message translates to:
  /// **'مالك المؤسسة'**
  String get companyRoleCompanyOwner;

  /// No description provided for @companyRoleMarketingDirector.
  ///
  /// In ar, this message translates to:
  /// **'مدير التسويق بالشركة'**
  String get companyRoleMarketingDirector;

  /// No description provided for @companyRoleRelationsOfficer.
  ///
  /// In ar, this message translates to:
  /// **'المكلف بالعلاقات'**
  String get companyRoleRelationsOfficer;

  /// No description provided for @companyRoleStoreOwner.
  ///
  /// In ar, this message translates to:
  /// **'مالك المتجر'**
  String get companyRoleStoreOwner;

  /// No description provided for @companyRoleProjectOwner.
  ///
  /// In ar, this message translates to:
  /// **'مالك المشروع'**
  String get companyRoleProjectOwner;

  /// No description provided for @companyRoleOther.
  ///
  /// In ar, this message translates to:
  /// **'أخرى (حدد)'**
  String get companyRoleOther;

  /// No description provided for @companyStepPersonal.
  ///
  /// In ar, this message translates to:
  /// **'المسؤول عن الحساب'**
  String get companyStepPersonal;

  /// No description provided for @companyStepBusiness.
  ///
  /// In ar, this message translates to:
  /// **'المؤسسة'**
  String get companyStepBusiness;

  /// No description provided for @companyStepPresence.
  ///
  /// In ar, this message translates to:
  /// **'النشاط والظهور'**
  String get companyStepPresence;

  /// No description provided for @companyStepFinish.
  ///
  /// In ar, this message translates to:
  /// **'المالية والوثائق'**
  String get companyStepFinish;

  /// No description provided for @companyRoleTitle.
  ///
  /// In ar, this message translates to:
  /// **'الصفة'**
  String get companyRoleTitle;

  /// No description provided for @companyRoleOtherHint.
  ///
  /// In ar, this message translates to:
  /// **'حدد صفتك'**
  String get companyRoleOtherHint;

  /// No description provided for @companyAccountName.
  ///
  /// In ar, this message translates to:
  /// **'اختر اسماً لحسابك'**
  String get companyAccountName;

  /// No description provided for @companyAccountNameRules.
  ///
  /// In ar, this message translates to:
  /// **'لا تنتحل اسم شخص أو علامة أخرى، ولا تستعمل ألفاظاً مسيئة، ومن {min} إلى {max} حرفاً.'**
  String companyAccountNameRules(int min, int max);

  /// No description provided for @companyAccountNameTaken.
  ///
  /// In ar, this message translates to:
  /// **'هذا الاسم مستعمل من حساب آخر'**
  String get companyAccountNameTaken;

  /// No description provided for @companyAccountNameReserved.
  ///
  /// In ar, this message translates to:
  /// **'هذا الاسم محجوز، اختر اسماً آخر'**
  String get companyAccountNameReserved;

  /// No description provided for @companyAccountNameInvalid.
  ///
  /// In ar, this message translates to:
  /// **'حروف وأرقام ومسافات فقط، من {min} إلى {max} حرفاً'**
  String companyAccountNameInvalid(int min, int max);

  /// No description provided for @companyInstitutionName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المؤسسة'**
  String get companyInstitutionName;

  /// No description provided for @companyBranch.
  ///
  /// In ar, this message translates to:
  /// **'الفرع (اختياري)'**
  String get companyBranch;

  /// No description provided for @companyAccountNameQuestion.
  ///
  /// In ar, this message translates to:
  /// **'أيهما تريده اسماً لحسابك؟'**
  String get companyAccountNameQuestion;

  /// No description provided for @companyNameOption.
  ///
  /// In ar, this message translates to:
  /// **'اسم المؤسسة'**
  String get companyNameOption;

  /// No description provided for @companyBranchOption.
  ///
  /// In ar, this message translates to:
  /// **'اسم الفرع'**
  String get companyBranchOption;

  /// No description provided for @companyHqWilaya.
  ///
  /// In ar, this message translates to:
  /// **'ولاية المقر'**
  String get companyHqWilaya;

  /// No description provided for @companyHqAddress.
  ///
  /// In ar, this message translates to:
  /// **'عنوان مقر المؤسسة'**
  String get companyHqAddress;

  /// No description provided for @companyCapital.
  ///
  /// In ar, this message translates to:
  /// **'رأس المال (تقديري، اختياري)'**
  String get companyCapital;

  /// No description provided for @companyCurrency.
  ///
  /// In ar, this message translates to:
  /// **'دج'**
  String get companyCurrency;

  /// No description provided for @companyPhotoSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'شعار مؤسستك أو صورتك، تظهر للمؤثرين'**
  String get companyPhotoSubtitle;

  /// No description provided for @companyBio.
  ///
  /// In ar, this message translates to:
  /// **'نبذة عن نشاطك'**
  String get companyBio;

  /// No description provided for @companyBioHint.
  ///
  /// In ar, this message translates to:
  /// **'ماذا تقدم ولمن؟'**
  String get companyBioHint;

  /// No description provided for @companyActivitiesTitle.
  ///
  /// In ar, this message translates to:
  /// **'مجالات النشاط'**
  String get companyActivitiesTitle;

  /// No description provided for @companyActivitiesMax.
  ///
  /// In ar, this message translates to:
  /// **'اختر {max} على الأكثر'**
  String companyActivitiesMax(int max);

  /// No description provided for @companyActivityOtherHint.
  ///
  /// In ar, this message translates to:
  /// **'حدد مجال نشاطك'**
  String get companyActivityOtherHint;

  /// No description provided for @companyPagesTitle.
  ///
  /// In ar, this message translates to:
  /// **'صفحات التسويق الرسمية (اختياري)'**
  String get companyPagesTitle;

  /// No description provided for @companyPagesHint.
  ///
  /// In ar, this message translates to:
  /// **'الصق رابط الصفحة ونتعرف على المنصة تلقائياً'**
  String get companyPagesHint;

  /// No description provided for @companyPagesLimit.
  ///
  /// In ar, this message translates to:
  /// **'{max} صفحات على الأكثر'**
  String companyPagesLimit(int max);

  /// No description provided for @companyPhoneHint.
  ///
  /// In ar, this message translates to:
  /// **'لا تستعمل رقمك الشخصي'**
  String get companyPhoneHint;

  /// No description provided for @companyWhatsappOptional.
  ///
  /// In ar, this message translates to:
  /// **'رقم مرتبط بواتساب (اختياري)'**
  String get companyWhatsappOptional;

  /// No description provided for @companyPhone2.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف ثاني (اختياري)'**
  String get companyPhone2;

  /// No description provided for @companyEmailHint.
  ///
  /// In ar, this message translates to:
  /// **'بريد حسابك، سنطلب تأكيده لاحقاً'**
  String get companyEmailHint;

  /// No description provided for @docTaxCertificate.
  ///
  /// In ar, this message translates to:
  /// **'وثيقة الرقم الجبائي'**
  String get docTaxCertificate;

  /// No description provided for @docLicense.
  ///
  /// In ar, this message translates to:
  /// **'ترخيص أو تصريح'**
  String get docLicense;

  /// No description provided for @companyLicensesTitle.
  ///
  /// In ar, this message translates to:
  /// **'التراخيص والتصاريح (اختيارية)'**
  String get companyLicensesTitle;

  /// No description provided for @companyLicensesHint.
  ///
  /// In ar, this message translates to:
  /// **'للنشاطات التي قد تروّج لها لاحقاً'**
  String get companyLicensesHint;

  /// No description provided for @companyAddLicense.
  ///
  /// In ar, this message translates to:
  /// **'إضافة ترخيص'**
  String get companyAddLicense;

  /// No description provided for @companyProofOptional.
  ///
  /// In ar, this message translates to:
  /// **'أضف صكاً أو شيكاً أو RIB (اختياري)'**
  String get companyProofOptional;

  /// No description provided for @docReviewPending.
  ///
  /// In ar, this message translates to:
  /// **'قيد المراجعة'**
  String get docReviewPending;

  /// No description provided for @docReviewAccepted.
  ///
  /// In ar, this message translates to:
  /// **'مقبولة'**
  String get docReviewAccepted;

  /// No description provided for @docReviewRejected.
  ///
  /// In ar, this message translates to:
  /// **'مرفوضة: {reason}'**
  String docReviewRejected(String reason);

  /// No description provided for @companyMeetingNote.
  ///
  /// In ar, this message translates to:
  /// **'بعد الإرسال نحدد معك لقاءً لمراجعة كل الإثباتات'**
  String get companyMeetingNote;

  /// No description provided for @companyScanDocsTitle.
  ///
  /// In ar, this message translates to:
  /// **'املأ من وثائق المؤسسة'**
  String get companyScanDocsTitle;

  /// No description provided for @companyScanDocsHint.
  ///
  /// In ar, this message translates to:
  /// **'صوّر السجل التجاري ووثيقة الرقم الجبائي، نملأ الاسم والأرقام والعنوان ورأس المال تلقائياً، وأكمل الباقي. الوثيقتان اختياريتان.'**
  String get companyScanDocsHint;

  /// No description provided for @regIdNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم بطاقة التعريف'**
  String get regIdNumber;

  /// No description provided for @regContentLanguagesHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر مستواك في كل لغة'**
  String get regContentLanguagesHint;

  /// No description provided for @regOptionalContactTitle.
  ///
  /// In ar, this message translates to:
  /// **'معلومات إضافية (اختيارية)'**
  String get regOptionalContactTitle;

  /// No description provided for @regBackupPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف احتياطي (اختياري)'**
  String get regBackupPhone;

  /// No description provided for @regDeliveryAddress.
  ///
  /// In ar, this message translates to:
  /// **'عنوان وصول طرودك (اختياري)'**
  String get regDeliveryAddress;

  /// No description provided for @regDeliveryAddressHint.
  ///
  /// In ar, this message translates to:
  /// **'حدد عنوان البيت بدقة لتستلم الطرد حتى بيتك أو البلدية القريبة لك لتستلم فيها الطرد من مكاتب التوصيل'**
  String get regDeliveryAddressHint;

  /// No description provided for @audWritten.
  ///
  /// In ar, this message translates to:
  /// **'محتوى كتابي'**
  String get audWritten;

  /// No description provided for @audAudio.
  ///
  /// In ar, this message translates to:
  /// **'محتوى صوتي'**
  String get audAudio;

  /// No description provided for @audInteractive.
  ///
  /// In ar, this message translates to:
  /// **'محتوى تفاعلي'**
  String get audInteractive;

  /// No description provided for @audContentRankHint.
  ///
  /// In ar, this message translates to:
  /// **'رتّبها من الأكثر تفاعلاً إلى الأقل'**
  String get audContentRankHint;

  /// No description provided for @regSkipOptional.
  ///
  /// In ar, this message translates to:
  /// **'تخطي، سأكملها لاحقاً'**
  String get regSkipOptional;

  /// No description provided for @finAddHint.
  ///
  /// In ar, this message translates to:
  /// **'أضف مؤسسة مالية واحدة على الأقل: اسمها، وثيقة إن وُجدت، ورقم الحساب'**
  String get finAddHint;

  /// No description provided for @finProofAdded.
  ///
  /// In ar, this message translates to:
  /// **'الوثيقة مرفقة'**
  String get finProofAdded;

  /// No description provided for @finReadDone.
  ///
  /// In ar, this message translates to:
  /// **'قرأنا رقم الحساب من الوثيقة، راجعه'**
  String get finReadDone;

  /// No description provided for @finAttachDocument.
  ///
  /// In ar, this message translates to:
  /// **'إرفاق وثيقة (صك، RIB...) اختياري'**
  String get finAttachDocument;

  /// No description provided for @finAttachDocumentHint.
  ///
  /// In ar, this message translates to:
  /// **'إذا أرفقت وثيقة نقرأ رقم الحساب تلقائياً، وإلا اكتبه بنفسك'**
  String get finAttachDocumentHint;

  /// No description provided for @regEntityRadio.
  ///
  /// In ar, this message translates to:
  /// **'إذاعة'**
  String get regEntityRadio;

  /// No description provided for @regEntityTv.
  ///
  /// In ar, this message translates to:
  /// **'تلفزيون'**
  String get regEntityTv;

  /// No description provided for @regEntityShort.
  ///
  /// In ar, this message translates to:
  /// **'الصفة'**
  String get regEntityShort;

  /// No description provided for @levelBasic.
  ///
  /// In ar, this message translates to:
  /// **'أساسي'**
  String get levelBasic;

  /// No description provided for @levelGood.
  ///
  /// In ar, this message translates to:
  /// **'جيد'**
  String get levelGood;

  /// No description provided for @levelAdvanced.
  ///
  /// In ar, this message translates to:
  /// **'متقدم'**
  String get levelAdvanced;

  /// No description provided for @regChooseLevel.
  ///
  /// In ar, this message translates to:
  /// **'اختر المستوى'**
  String get regChooseLevel;

  /// No description provided for @regNationalId.
  ///
  /// In ar, this message translates to:
  /// **'رقم التعريف الوطني'**
  String get regNationalId;

  /// No description provided for @regNationalIdHint.
  ///
  /// In ar, this message translates to:
  /// **'18 رقمًا'**
  String get regNationalIdHint;

  /// No description provided for @regNationalIdInvalid.
  ///
  /// In ar, this message translates to:
  /// **'رقم التعريف الوطني يتكون من 18 رقمًا'**
  String get regNationalIdInvalid;

  /// No description provided for @regIdentityDocument.
  ///
  /// In ar, this message translates to:
  /// **'وثيقة الهوية'**
  String get regIdentityDocument;

  /// No description provided for @requiredFieldsNote.
  ///
  /// In ar, this message translates to:
  /// **'* ملاحظة : (الحقول المحصورة بنجمة (*) إلزامية لإدخال البيانات)'**
  String get requiredFieldsNote;

  /// No description provided for @upgradePrefix.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك الترقية'**
  String get upgradePrefix;

  /// No description provided for @upgradeTapHere.
  ///
  /// In ar, this message translates to:
  /// **'بالضغط هنا'**
  String get upgradeTapHere;

  /// No description provided for @regBioOptional.
  ///
  /// In ar, this message translates to:
  /// **'نبذة عنك (غير إلزامية)'**
  String get regBioOptional;

  /// No description provided for @adctComparison.
  ///
  /// In ar, this message translates to:
  /// **'المقارنات'**
  String get adctComparison;

  /// No description provided for @adctTipsTricks.
  ///
  /// In ar, this message translates to:
  /// **'النصائح والحيل'**
  String get adctTipsTricks;

  /// No description provided for @adctPolls.
  ///
  /// In ar, this message translates to:
  /// **'الاستطلاعات (أسئلة وأجوبة)'**
  String get adctPolls;

  /// No description provided for @adctDailyVlog.
  ///
  /// In ar, this message translates to:
  /// **'اليوميات'**
  String get adctDailyVlog;

  /// No description provided for @adctChallenges.
  ///
  /// In ar, this message translates to:
  /// **'التحديات والمسابقات'**
  String get adctChallenges;

  /// No description provided for @adctAffiliateLinks.
  ///
  /// In ar, this message translates to:
  /// **'روابط الأفلييت'**
  String get adctAffiliateLinks;

  /// No description provided for @adctGiveaways.
  ///
  /// In ar, this message translates to:
  /// **'الهدايا والمسابقات'**
  String get adctGiveaways;

  /// No description provided for @adctInspiringStories.
  ///
  /// In ar, this message translates to:
  /// **'قصص ملهمة'**
  String get adctInspiringStories;

  /// No description provided for @adctPodcast.
  ///
  /// In ar, this message translates to:
  /// **'بودكاست'**
  String get adctPodcast;

  /// No description provided for @adctMotivationalPosts.
  ///
  /// In ar, this message translates to:
  /// **'منشورات تحفيزية'**
  String get adctMotivationalPosts;

  /// No description provided for @instAlgeriePoste.
  ///
  /// In ar, this message translates to:
  /// **'بريد الجزائر'**
  String get instAlgeriePoste;

  /// No description provided for @instBna.
  ///
  /// In ar, this message translates to:
  /// **'البنك الوطني الجزائري (BNA)'**
  String get instBna;

  /// No description provided for @instBea.
  ///
  /// In ar, this message translates to:
  /// **'بنك الجزائر الخارجي (BEA)'**
  String get instBea;

  /// No description provided for @instBdl.
  ///
  /// In ar, this message translates to:
  /// **'بنك التنمية المحلية (BDL)'**
  String get instBdl;

  /// No description provided for @instBadr.
  ///
  /// In ar, this message translates to:
  /// **'بنك الفلاحة والتنمية الريفية (BADR)'**
  String get instBadr;

  /// No description provided for @instCpa.
  ///
  /// In ar, this message translates to:
  /// **'القرض الشعبي الجزائري (CPA)'**
  String get instCpa;

  /// No description provided for @instCnep.
  ///
  /// In ar, this message translates to:
  /// **'الصندوق الوطني للتوفير والاحتياط (CNEP-Banque)'**
  String get instCnep;

  /// No description provided for @instBnh.
  ///
  /// In ar, this message translates to:
  /// **'البنك الوطني للإسكان (BNH)'**
  String get instBnh;

  /// No description provided for @instAgb.
  ///
  /// In ar, this message translates to:
  /// **'بنك الخليج الجزائر (AGB)'**
  String get instAgb;

  /// No description provided for @instSocieteGenerale.
  ///
  /// In ar, this message translates to:
  /// **'سوسيتيه جنرال الجزائر (Société Générale)'**
  String get instSocieteGenerale;

  /// No description provided for @instBnpParibas.
  ///
  /// In ar, this message translates to:
  /// **'بي إن بي باريبا الجزائر (BNP Paribas)'**
  String get instBnpParibas;

  /// No description provided for @instBankAbc.
  ///
  /// In ar, this message translates to:
  /// **'المؤسسة العربية المصرفية (Bank ABC)'**
  String get instBankAbc;

  /// No description provided for @instHousingBank.
  ///
  /// In ar, this message translates to:
  /// **'بنك الإسكان للتجارة والتمويل (Housing Bank)'**
  String get instHousingBank;

  /// No description provided for @instAlSalam.
  ///
  /// In ar, this message translates to:
  /// **'بنك السلام الجزائر (مصرف إسلامي)'**
  String get instAlSalam;

  /// No description provided for @instAlBaraka.
  ///
  /// In ar, this message translates to:
  /// **'بنك البركة الجزائري (مصرف إسلامي)'**
  String get instAlBaraka;

  /// No description provided for @instFransabank.
  ///
  /// In ar, this message translates to:
  /// **'بنك فرنسابنك الجزائر (Fransabank)'**
  String get instFransabank;

  /// No description provided for @instArabBank.
  ///
  /// In ar, this message translates to:
  /// **'بنك عمان العربي تونس والجزائر (العربي)'**
  String get instArabBank;

  /// No description provided for @regStepReview.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة وإرسال'**
  String get regStepReview;

  /// No description provided for @regReviewHint.
  ///
  /// In ar, this message translates to:
  /// **'تأكد من معلوماتك قبل الإرسال'**
  String get regReviewHint;

  /// No description provided for @regEditFile.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الملف'**
  String get regEditFile;

  /// No description provided for @regGoHome.
  ///
  /// In ar, this message translates to:
  /// **'الصفحة الرئيسية'**
  String get regGoHome;

  /// No description provided for @regViewStatus.
  ///
  /// In ar, this message translates to:
  /// **'اضغط لعرض حالة ملفك'**
  String get regViewStatus;

  /// No description provided for @audRegionsIn.
  ///
  /// In ar, this message translates to:
  /// **'المناطق داخل {country}'**
  String audRegionsIn(String country);
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
