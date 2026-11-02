typedef Json = Map<String, dynamic>;

String jsonString(Object? value) => value as String? ?? '';

int jsonInt(Object? value) => switch (value) {
      final int number => number,
      final String text => int.tryParse(text) ?? 0,
      _ => 0,
    };

double? jsonDouble(Object? value) => switch (value) {
      final num number => number.toDouble(),
      final String text => double.tryParse(text),
      _ => null,
    };

DateTime? jsonDate(Object? value) => value is String ? DateTime.tryParse(value) : null;
