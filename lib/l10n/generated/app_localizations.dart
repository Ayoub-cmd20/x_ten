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

  /// No description provided for @stepReview.
  ///
  /// In ar, this message translates to:
  /// **'المراجعة والإرسال'**
  String get stepReview;

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

  /// No description provided for @skills.
  ///
  /// In ar, this message translates to:
  /// **'المهارات'**
  String get skills;

  /// No description provided for @skillsHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: تصوير، مونتاج، تقديم'**
  String get skillsHint;

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

  /// No description provided for @ribInvalid.
  ///
  /// In ar, this message translates to:
  /// **'20 رقمًا بالضبط'**
  String get ribInvalid;

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

  /// No description provided for @consentConfirm.
  ///
  /// In ar, this message translates to:
  /// **'أؤكد أن المعلومات المقدمة صحيحة'**
  String get consentConfirm;

  /// No description provided for @consentTerms.
  ///
  /// In ar, this message translates to:
  /// **'أوافق على الشروط والأحكام'**
  String get consentTerms;

  /// No description provided for @consentPrivacy.
  ///
  /// In ar, this message translates to:
  /// **'أوافق على سياسة الخصوصية'**
  String get consentPrivacy;

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
  /// **'أرسل محاولة جديدة بعد التعديل. ستحتاج إعادة إضافة الحسابات والمستندات.'**
  String get statusNeedsChangesBody;

  /// No description provided for @statusRejectedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض ملفك'**
  String get statusRejectedTitle;

  /// No description provided for @statusRejectedBody.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك تقديم محاولة جديدة بمعلومات محدّثة.'**
  String get statusRejectedBody;

  /// No description provided for @attemptNumber.
  ///
  /// In ar, this message translates to:
  /// **'المحاولة رقم {number}'**
  String attemptNumber(int number);

  /// No description provided for @startNewAttempt.
  ///
  /// In ar, this message translates to:
  /// **'محاولة جديدة'**
  String get startNewAttempt;

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
  /// **'التكنولوجيا'**
  String get catTechnology;

  /// No description provided for @catGaming.
  ///
  /// In ar, this message translates to:
  /// **'الألعاب'**
  String get catGaming;

  /// No description provided for @catSports.
  ///
  /// In ar, this message translates to:
  /// **'الرياضة'**
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
  /// **'الصحة'**
  String get catHealth;

  /// No description provided for @catBeauty.
  ///
  /// In ar, this message translates to:
  /// **'الجمال'**
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
  /// **'الطبخ'**
  String get catCooking;

  /// No description provided for @catTravel.
  ///
  /// In ar, this message translates to:
  /// **'السفر والسياحة'**
  String get catTravel;

  /// No description provided for @catCars.
  ///
  /// In ar, this message translates to:
  /// **'السيارات'**
  String get catCars;

  /// No description provided for @catEducation.
  ///
  /// In ar, this message translates to:
  /// **'التعليم'**
  String get catEducation;

  /// No description provided for @catBusiness.
  ///
  /// In ar, this message translates to:
  /// **'الأعمال'**
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
  /// **'التجارة الإلكترونية'**
  String get catEcommerce;

  /// No description provided for @catArt.
  ///
  /// In ar, this message translates to:
  /// **'الفن'**
  String get catArt;

  /// No description provided for @catMusic.
  ///
  /// In ar, this message translates to:
  /// **'الموسيقى'**
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
