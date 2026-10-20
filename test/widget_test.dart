import 'package:flutter_test/flutter_test.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';

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
}
