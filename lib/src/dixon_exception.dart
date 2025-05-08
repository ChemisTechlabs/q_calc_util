/// A representation of a Q Test error
class DixonException implements Exception {
  /// Message describing the Dixon error
  final String message;

  /// Creates a new [DixonException] with a message
  DixonException(this.message);

  @override
  String toString() => 'DixonException: $message';
}
