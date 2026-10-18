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
