import 'audience_profile.dart';
import 'content_type.dart';
import 'financial_information.dart';
import 'influencer_category_selection.dart';
import 'influencer_document.dart';
import 'influencer_registration.dart';
import 'notification_preferences.dart';
import 'social_account.dart';
import 'verification_status.dart';

class InfluencerRegistrationDraft {
  String firstName = '';
  String lastName = '';
  String displayName = '';

  DateTime? birthDate;
  String birthPlace = '';

  String bio = '';
  String skills = '';

  String? profileImagePath;

  String email = '';
  String phone = '';
  String whatsapp = '';

  List<String> primaryCategories = [];
  List<String> secondaryCategories = [];

  PaymentAccountType paymentType =
      PaymentAccountType.ccp;

  String ccpAccount = '';
  String ccpKey = '';

  String bankName = '';
  String bankAccount = '';
  String rib = '';

  List<InfluencerDocument> documents = [];

  List<SocialAccount> socialAccounts = [];

  Map<String, double> ageDistribution = {
    '13-17': 0,
    '18-24': 0,
    '25-34': 0,
    '35-44': 0,
    '45+': 0,
  };

  double malePercentage = 50;
  double femalePercentage = 50;

  Map<String, double> audienceLocations = {};

  List<String> audienceInterests = [];

  List<ContentType> contentTypes = [];

  bool inAppNotification = true;
  bool smsNotification = false;
  bool phoneCallNotification = false;
  bool emailNotification = true;
  bool whatsappNotification = false;

  bool confirmInformation = false;
  bool acceptTerms = false;
  bool acceptPrivacy = false;
  bool acceptVerification = false;
  bool acceptContact = false;

  InfluencerRegistration toRegistration() {
    return InfluencerRegistration(
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      displayName: displayName.trim(),

      birthDate: birthDate,
      birthPlace: birthPlace.trim(),

      bio: bio.trim(),
      skills: skills.trim(),

      profileImagePath:
      profileImagePath,

      email: email.trim(),
      phone: phone.trim(),
      whatsapp: whatsapp.trim(),

      categories:
      InfluencerCategorySelection(
        primary:
        List<String>.from(
          primaryCategories,
        ),
        secondary:
        List<String>.from(
          secondaryCategories,
        ),
      ),

      financialInformation:
      FinancialInformation(
        accountType: paymentType,

        ccpAccount:
        ccpAccount.trim().isEmpty
            ? null
            : ccpAccount.trim(),

        ccpKey:
        ccpKey.trim().isEmpty
            ? null
            : ccpKey.trim(),

        bankName:
        bankName.trim().isEmpty
            ? null
            : bankName.trim(),

        bankAccount:
        bankAccount.trim().isEmpty
            ? null
            : bankAccount.trim(),

        rib: rib.trim().isEmpty
            ? null
            : rib.trim(),
      ),

      documents:
      List<InfluencerDocument>.from(
        documents,
      ),

      socialAccounts:
      List<SocialAccount>.from(
        socialAccounts,
      ),

      audience: AudienceProfile(
        ageDistribution:
        Map<String, double>.from(
          ageDistribution,
        ),
        malePercentage:
        malePercentage,
        femalePercentage:
        femalePercentage,
        locations:
        Map<String, double>.from(
          audienceLocations,
        ),
        interests:
        List<String>.from(
          audienceInterests,
        ),
      ),

      contentTypes:
      List<ContentType>.from(
        contentTypes,
      ),

      notificationPreferences:
      NotificationPreferences(
        inApp:
        inAppNotification,
        sms:
        smsNotification,
        phoneCall:
        phoneCallNotification,
        email:
        emailNotification,
        whatsapp:
        whatsappNotification,
      ),

      confirmInformation:
      confirmInformation,
      acceptedTerms:
      acceptTerms,
      acceptedPrivacy:
      acceptPrivacy,
      acceptedVerification:
      acceptVerification,
      acceptedContact:
      acceptContact,

      registeredAt: DateTime.now(),

      verificationStatus:
      InfluencerVerificationStatus
          .draft,
    );
  }
}