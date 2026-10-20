import 'package:flutter_test/flutter_test.dart';
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
    expect(RegistrationCatalog.skillGroups.values.expand((s) => s).length, 27);
  });

  test('insights scan replaces only the groups it read', () {
    const current = Audience(
      gender: {'male': 50, 'female': 50},
      ages: {'18-24': 100},
      purchasingPower: 'medium',
    );
    final merged = current.overlay(const Audience(gender: {'male': 62.3, 'female': 37.7}));
    expect(merged.gender, {'male': 62.3, 'female': 37.7});
    expect(merged.ages, {'18-24': 100});
    expect(merged.purchasingPower, 'medium');
    expect(merged.filledGroups, 2);
  });

  test('any account number format is cleaned the same way', () {
    expect(cleanAccountNumber('pay 1234-5678'), 'PAY12345678');
    expect(cleanAccountNumber('00799999 0012345678 45'), '00799999001234567845');
  });
}
