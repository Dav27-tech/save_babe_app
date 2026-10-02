/// Exceptions typées utilisées dans la couche Data.
/// Converties en Failure dans les repositories.
library;

class StorageException implements Exception {
  const StorageException(this.message, {this.cause});
  final String message;
  final Object? cause;
  @override
  String toString() => 'StorageException: $message';
}

class NetworkException implements Exception {
  const NetworkException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;
  @override
  String toString() => 'NetworkException: $message (HTTP $statusCode)';
}

class OcrException implements Exception {
  const OcrException(this.message, {this.cause});
  final String message;
  final Object? cause;
  @override
  String toString() => 'OcrException: $message';
}

class AudioException implements Exception {
  const AudioException(this.message, {this.cause});
  final String message;
  final Object? cause;
  @override
  String toString() => 'AudioException: $message';
}
