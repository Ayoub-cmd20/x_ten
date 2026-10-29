final _phoneSeparators = RegExp(r'[\s\-().]');

String normalizePhone(String phone) => phone.trim().replaceAll(_phoneSeparators, '');
