abstract final class Env {
  static const baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://pubdz-api.onrender.com/api',
  );
}
