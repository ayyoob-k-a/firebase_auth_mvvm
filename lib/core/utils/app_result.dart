/// Sealed result type used across domain and data layers.
/// Avoids adding `dartz`/`fpdart` as a dependency.
sealed class AppResult<T> {
  const AppResult();
}

final class AppSuccess<T> extends AppResult<T> {
  final T data;
  const AppSuccess(this.data);
}

final class AppFailure<T> extends AppResult<T> {
  final String message;
  const AppFailure(this.message);
}
