import 'package:flutter_test/flutter_test.dart';
import 'package:x_ten/core/enums/verification_status.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/company_profile/data/company_models.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/domain/company_usecases.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_usecases.dart';

void main() {
  test('audience shares must total 100 when filled', () {
    expect(totals100(const {}), isTrue);
    expect(totals100(const {'male': 60, 'female': 40}), isTrue);
    expect(totals100(const {'male': 60, 'female': 30}), isFalse);
  });

  test('client lists', () {
    expect(RegistrationCatalog.categories.length, 17);
    expect(RegistrationCatalog.adContentTypes.length, 8);
    expect(RegistrationCatalog.audienceContent, containsAll(['written', 'audio', 'interactive']));
  });

  test('insights scan replaces only the groups it read', () {
    const current = Audience(
      gender: {'male': 50, 'female': 50},
      ages: {'18-24': 100},
      contentEngagement: ['video', 'written'],
    );
    final merged = current.overlay(const Audience(gender: {'male': 62.3, 'female': 37.7}));
    expect(merged.gender, {'male': 62.3, 'female': 37.7});
    expect(merged.ages, {'18-24': 100});
    expect(merged.contentEngagement, ['video', 'written']);
    expect(merged.filledGroups, 3);
  });

  test('any account number format is cleaned the same way', () {
    expect(cleanAccountNumber('pay 1234-5678'), 'PAY12345678');
    expect(cleanAccountNumber('00799999 0012345678 45'), '00799999001234567845');
  });

  test('company activity catalog matches the client list', () {
    expect(CompanyCatalog.sectors.length, 20);
    expect(CompanyCatalog.sectors.values.expand((a) => a).toSet().length, 65);
    expect(CompanyCatalog.maxActivities(BusinessType.individualActivity), 3);
    expect(CompanyCatalog.maxActivities(BusinessType.registeredBusiness), 5);
  });

  test('company sections are cleaned per business type', () {
    const individual = BusinessType.individualActivity;
    const registered = BusinessType.registeredBusiness;

    expect(cleanCompanySection(individual, const CompanyPersonal(role: 'marketingDirector')), isA<Err<CompanySection>>());
    expect(
      cleanCompanySection(individual, const CompanyPresence(activityAreas: ['cafes', 'retail', 'law', 'events'])),
      isA<Err<CompanySection>>(),
    );
    expect(cleanCompanySection(registered, const CompanyPresence(activityAreas: ['other'])), isA<Err<CompanySection>>());

    final business = cleanCompanySection(
      individual,
      const CompanyBusiness(accountName: '  Sara   Sweets ', companyName: 'X', nif: '123', wilaya: '31'),
    );
    expect(
      business,
      isA<Ok<CompanySection>>().having(
        (ok) => ok.value,
        'value',
        const CompanyBusiness(accountName: 'Sara Sweets', wilaya: '31'),
      ),
    );

    final legal = cleanCompanySection(
      registered,
      const CompanyBusiness(companyName: 'Co', registrationNumber: '16/00 123-b', accountNameSource: AccountNameSource.branch),
    );
    expect(
      legal,
      isA<Ok<CompanySection>>().having(
        (ok) => ok.value,
        'value',
        const CompanyBusiness(companyName: 'Co', registrationNumber: '16/00123B'),
      ),
    );
  });

  test('a saved company section is not sent again', () {
    const profile = CompanyProfile(
      id: 1,
      status: VerificationStatus.draft,
      contact: CompanyContact(phone: '0555123456', email: 'a@b.dz'),
      presence: CompanyPresence(activityAreas: ['cafes'], marketingPages: [MarketingPage(url: 'https://fb.com/a')]),
    );
    expect(profile.hasSaved(const CompanyContact(phone: '0555123456', email: 'a@b.dz')), isTrue);
    expect(
      profile.hasSaved(const CompanyPresence(
        activityAreas: ['cafes'],
        marketingPages: [MarketingPage(url: 'https://fb.com/a', platform: SocialPlatform.facebook)],
      )),
      isTrue,
    );
    expect(profile.hasSaved(const CompanyContact(phone: '0555000000', email: 'a@b.dz')), isFalse);
  });

  test('commercial register reading fills the business fields', () {
    final scanned = ScannedBusinessModel.fromJson(const {
      'registrationNumber': '31/001234567B20',
      'companyName': 'Sweets SARL',
      'wilaya': '31',
      'capital': 1000000,
      'nif': '000231001234567',
    });
    expect(scanned.hasFields, isTrue);
    expect(scanned.capital, 1000000);
    expect(scanned.ns, '');
    expect(const ScannedBusiness().hasFields, isFalse);
  });
}
