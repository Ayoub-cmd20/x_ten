class NotificationPreferences {
  final bool inApp;
  final bool sms;
  final bool phoneCall;
  final bool email;
  final bool whatsapp;

  const NotificationPreferences({
    this.inApp = true,
    this.sms = false,
    this.phoneCall = false,
    this.email = true,
    this.whatsapp = false,
  });

  NotificationPreferences copyWith({
    bool? inApp,
    bool? sms,
    bool? phoneCall,
    bool? email,
    bool? whatsapp,
  }) {
    return NotificationPreferences(
      inApp: inApp ?? this.inApp,
      sms: sms ?? this.sms,
      phoneCall:
      phoneCall ?? this.phoneCall,
      email: email ?? this.email,
      whatsapp:
      whatsapp ?? this.whatsapp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inApp': inApp,
      'sms': sms,
      'phoneCall': phoneCall,
      'email': email,
      'whatsapp': whatsapp,
    };
  }

  factory NotificationPreferences.fromMap(
      Map<String, dynamic> map,
      ) {
    return NotificationPreferences(
      inApp: map['inApp'] ?? true,
      sms: map['sms'] ?? false,
      phoneCall:
      map['phoneCall'] ?? false,
      email: map['email'] ?? true,
      whatsapp:
      map['whatsapp'] ?? false,
    );
  }
}