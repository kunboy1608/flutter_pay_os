class PayOsException implements Exception {
  final String code;
  final String message;

  PayOsException({required this.code, required this.message});

  @override
  String toString() {
    return "PayOsException: code: $code - $message";
  }
}
