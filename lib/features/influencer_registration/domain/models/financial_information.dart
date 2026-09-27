enum PaymentAccountType {
  ccp,
  bank,
  both,
}

extension PaymentAccountTypeExtension
on PaymentAccountType {
  String get arabicName {
    switch (this) {
      case PaymentAccountType.ccp:
        return 'حساب CCP';

      case PaymentAccountType.bank:
        return 'حساب بنكي';

      case PaymentAccountType.both:
        return 'CCP + حساب بنكي';
    }
  }
}

class FinancialInformation {
  final PaymentAccountType accountType;

  final String? ccpAccount;
  final String? ccpKey;

  final String? bankName;
  final String? bankAccount;
  final String? rib;

  const FinancialInformation({
    this.accountType =
        PaymentAccountType.ccp,
    this.ccpAccount,
    this.ccpKey,
    this.bankName,
    this.bankAccount,
    this.rib,
  });

  FinancialInformation copyWith({
    PaymentAccountType? accountType,
    String? ccpAccount,
    String? ccpKey,
    String? bankName,
    String? bankAccount,
    String? rib,
  }) {
    return FinancialInformation(
      accountType:
      accountType ?? this.accountType,
      ccpAccount:
      ccpAccount ?? this.ccpAccount,
      ccpKey: ccpKey ?? this.ccpKey,
      bankName:
      bankName ?? this.bankName,
      bankAccount:
      bankAccount ?? this.bankAccount,
      rib: rib ?? this.rib,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountType': accountType.name,
      'ccpAccount': ccpAccount,
      'ccpKey': ccpKey,
      'bankName': bankName,
      'bankAccount': bankAccount,
      'rib': rib,
    };
  }

  factory FinancialInformation.fromMap(
      Map<String, dynamic> map,
      ) {
    return FinancialInformation(
      accountType:
      PaymentAccountType.values.firstWhere(
            (e) =>
        e.name ==
            map['accountType'],
        orElse: () =>
        PaymentAccountType.ccp,
      ),
      ccpAccount: map['ccpAccount'],
      ccpKey: map['ccpKey'],
      bankName: map['bankName'],
      bankAccount: map['bankAccount'],
      rib: map['rib'],
    );
  }
}