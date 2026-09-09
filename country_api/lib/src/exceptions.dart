class CountryException implements Exception {
  final String message;
  final Object? cause;

  CountryException(this.message, [this.cause]);

  @override
  String toString() {
    if (cause != null) {
      return 'CountryException: $message (Underlying: $cause)';
    }
    return 'CountryException: $message';
  }
}