/// Thrown by the data layer when Firebase Auth fails.
/// The [message] is a user-friendly string.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

/// Thrown when a network call fails for non-auth reasons.
class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection.']);
}
