class ApiError {
  const ApiError({
    required this.code,
    required this.message,
    this.details = const {},
  });

  final String code;
  final String message;
  final Map<String, dynamic> details;

  factory ApiError.fromResponse(dynamic data) {
    if (data is Map<String, dynamic> && data['error'] is Map<String, dynamic>) {
      final e = data['error'] as Map<String, dynamic>;
      return ApiError(
        code: e['code'] as String? ?? 'unknown',
        message: e['message'] as String? ?? '',
        details: (e['details'] as Map?)?.cast<String, dynamic>() ?? const {},
      );
    }
    return const ApiError(code: 'unknown', message: 'Unexpected server response');
  }

  @override
  String toString() => 'ApiError($code: $message)';
}
