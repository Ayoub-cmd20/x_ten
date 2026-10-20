abstract final class Env {
  static const baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://x10-3ujl.onrender.com/api',
  );
}
