import 'freelancer_document.dart';
import 'freelancer_portfolio_item.dart';
import 'freelancer_registration.dart';
import 'freelancer_skill.dart';
import 'freelancer_verification_status.dart';
class FreelancerRegistrationDraft {
  String firstName='',
      lastName='',
      displayName='',
      birthPlace='',
      bio='',
      jobTitle='',
      professionalLevel='',
      city='',
      email='',
      phone='',
      whatsapp='',
      ccpAccount='',
      ccpKey='',
      bankName='',
      bankAccount='',
      rib='';
  DateTime? birthDate;
  String? profileImagePath;
  int yearsOfExperience=0,weeklyHours=20;
  double minimumBudget=0;
  List<String> languages=[],
      services=[],
      projectPreferences=[];
  List<FreelancerSkill> skills=[];
  List<FreelancerPortfolioItem> portfolio=[];
  List<FreelancerDocument> documents=[];
  FreelancerPaymentType paymentType=FreelancerPaymentType.ccp;
  FreelancerAvailability availability=FreelancerAvailability.available;
  bool inAppNotification=true,
      emailNotification=true,
      smsNotification=false,
      whatsappNotification=false,
      phoneCallNotification=false,
      confirmInformation=false,
      acceptTerms=false,
      acceptPrivacy=false,
      acceptVerification=false,
      acceptContact=false;
  FreelancerRegistration toRegistration()=>FreelancerRegistration(
      firstName:firstName.trim(),
      lastName:lastName.trim(),
      displayName:displayName.trim(),
      birthDate:birthDate,
      birthPlace:birthPlace.trim(),
      profileImagePath:profileImagePath,
      bio:bio.trim(),
      jobTitle:jobTitle.trim(),
      yearsOfExperience:yearsOfExperience,
      professionalLevel:professionalLevel.trim(),
      city:city.trim(),
      languages:List.of(languages),
      services:List.of(services),
      skills:List.of(skills),
      portfolio:List.of(portfolio),
      email:email.trim(),
      phone:phone.trim(),
      whatsapp:whatsapp.trim(),
      paymentType:paymentType,
      ccpAccount:ccpAccount.trim(),
      ccpKey:ccpKey.trim(),
      bankName:bankName.trim(),
      bankAccount:bankAccount.trim(),
      rib:rib.trim(),
      documents:List.of(documents),
      availability:availability,
      weeklyHours:weeklyHours,
      minimumBudget:minimumBudget,
      projectPreferences:List.of(projectPreferences),
      inAppNotification:inAppNotification,
      emailNotification:emailNotification,
      smsNotification:smsNotification,
      whatsappNotification:whatsappNotification,
      phoneCallNotification:phoneCallNotification,
      confirmInformation:confirmInformation,
      acceptTerms:acceptTerms,
      acceptPrivacy:acceptPrivacy,
      acceptVerification:acceptVerification,
      acceptContact:acceptContact,
      registeredAt:DateTime.now(),
      verificationStatus:FreelancerVerificationStatus.draft
  );
}
