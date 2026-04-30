/// API environment options for the Marg app.
enum ApiEnvironment { local, server }

/// Central place to configure which backend the app should talk to.
///
/// For simple setups you can just change [environment] before building.
/// For CI / multiple builds, prefer using `--dart-define` to override
/// [overrideBaseUrl] at compile time.
class ApiConfig {
  /// Change this to [ApiEnvironment.server] when you want to hard‑point
  /// the app at the deployed backend during development.
  static const ApiEnvironment environment = ApiEnvironment.server;

  /// Optional: allow overriding the base URL via `--dart-define`.
  /// Example:
  // flutter run --dart-define=MARG_API_BASE_URL=https://marg-api-548031081093.asia-south1.run.app

  static const String overrideBaseUrl = String.fromEnvironment(
    'MARG_API_BASE_URL',
    defaultValue: '',
  );

  static const String _localBaseUrl = 'http://localhost:3000';

  // Production/server URL you shared.
  static const String _serverBaseUrl =
      'https://marg-api-548031081093.asia-south1.run.app';

  /// Resolved base URL that the app should use.
  static String get baseUrl {
    // Highest priority: explicit override from dart-define.
    if (overrideBaseUrl.isNotEmpty) {
      return overrideBaseUrl;
    }

    // Otherwise pick based on the selected environment.
    switch (environment) {
      case ApiEnvironment.local:
        return _localBaseUrl;
      case ApiEnvironment.server:
        return _serverBaseUrl;
    }
  }

  /// Convenience flag for debugging.
  static bool get isLocal => identical(environment, ApiEnvironment.local);

  static bool get isServer => identical(environment, ApiEnvironment.server);
}
