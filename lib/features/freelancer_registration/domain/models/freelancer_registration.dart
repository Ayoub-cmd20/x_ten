import 'freelancer_document.dart';
import 'freelancer_portfolio_item.dart';
import 'freelancer_skill.dart';
import 'freelancer_verification_status.dart';

enum FreelancerPaymentType { ccp, bank, both }
extension FreelancerPaymentTypeX on FreelancerPaymentType {
  String get arabicName => this == FreelancerPaymentType.ccp ? 'حساب CCP' : this == FreelancerPaymentType.bank ? 'حساب بنكي' : 'CCP + حساب بنكي';
}
enum FreelancerAvailability { available, partiallyBusy, unavailable }
extension FreelancerAvailabilityX on FreelancerAvailability {
  String get arabicName => this == FreelancerAvailability.available ? 'متاح' : this == FreelancerAvailability.partiallyBusy ? 'مشغول جزئياً' : 'غير متاح مؤقتاً';
}
class FreelancerRegistration {
  final String? id;
  final String firstName,lastName,displayName,birthPlace,bio,jobTitle,professionalLevel,city,email,phone,whatsapp,ccpAccount,ccpKey,bankName,bankAccount,rib;
  final DateTime? birthDate,registeredAt;
  final String? profileImagePath;
  final int yearsOfExperience,weeklyHours;
  final double minimumBudget;
  final List<String> languages,services,projectPreferences;
  final List<FreelancerSkill> skills;
  final List<FreelancerPortfolioItem> portfolio;
  final List<FreelancerDocument> documents;
  final FreelancerPaymentType paymentType;
  final FreelancerAvailability availability;
  final bool inAppNotification,emailNotification,smsNotification,whatsappNotification,phoneCallNotification,confirmInformation,acceptTerms,acceptPrivacy,acceptVerification,acceptContact;
  final FreelancerVerificationStatus verificationStatus;
  const FreelancerRegistration({this.id,this.firstName='',this.lastName='',this.displayName='',this.birthDate,this.birthPlace='',this.profileImagePath,this.bio='',this.jobTitle='',this.yearsOfExperience=0,this.professionalLevel='',this.city='',this.languages=const [],this.services=const [],this.skills=const [],this.portfolio=const [],this.email='',this.phone='',this.whatsapp='',this.paymentType=FreelancerPaymentType.ccp,this.ccpAccount='',this.ccpKey='',this.bankName='',this.bankAccount='',this.rib='',this.documents=const [],this.availability=FreelancerAvailability.available,this.weeklyHours=20,this.minimumBudget=0,this.projectPreferences=const [],this.inAppNotification=true,this.emailNotification=true,this.smsNotification=false,this.whatsappNotification=false,this.phoneCallNotification=false,this.confirmInformation=false,this.acceptTerms=false,this.acceptPrivacy=false,this.acceptVerification=false,this.acceptContact=false,this.registeredAt,this.verificationStatus=FreelancerVerificationStatus.draft});
  bool get canSubmit => firstName.trim().isNotEmpty && lastName.trim().isNotEmpty && displayName.trim().isNotEmpty && jobTitle.trim().isNotEmpty && services.isNotEmpty && skills.isNotEmpty && email.trim().isNotEmpty && phone.trim().isNotEmpty && confirmInformation && acceptTerms && acceptPrivacy && acceptVerification && acceptContact;
  FreelancerRegistration copyWith({String? id, DateTime? registeredAt, FreelancerVerificationStatus? verificationStatus}) => FreelancerRegistration(id:id??this.id,firstName:firstName,lastName:lastName,displayName:displayName,birthDate:birthDate,birthPlace:birthPlace,profileImagePath:profileImagePath,bio:bio,jobTitle:jobTitle,yearsOfExperience:yearsOfExperience,professionalLevel:professionalLevel,city:city,languages:languages,services:services,skills:skills,portfolio:portfolio,email:email,phone:phone,whatsapp:whatsapp,paymentType:paymentType,ccpAccount:ccpAccount,ccpKey:ccpKey,bankName:bankName,bankAccount:bankAccount,rib:rib,documents:documents,availability:availability,weeklyHours:weeklyHours,minimumBudget:minimumBudget,projectPreferences:projectPreferences,inAppNotification:inAppNotification,emailNotification:emailNotification,smsNotification:smsNotification,whatsappNotification:whatsappNotification,phoneCallNotification:phoneCallNotification,confirmInformation:confirmInformation,acceptTerms:acceptTerms,acceptPrivacy:acceptPrivacy,acceptVerification:acceptVerification,acceptContact:acceptContact,registeredAt:registeredAt??this.registeredAt,verificationStatus:verificationStatus??this.verificationStatus);
}
