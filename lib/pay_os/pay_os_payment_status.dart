enum PayOsPaymentStatus {
  paid(value: "PAID"),
  pending(value: "PENDING"),
  processing(value: "PROCESSING"),
  cancelled(value: "CANCELLED"),
  expired(value: "EXPIRED");

  const PayOsPaymentStatus({required this.value});
  final String value;

  static PayOsPaymentStatus fromValue(String value) {
    switch (value) {
      case "PAID":
        return PayOsPaymentStatus.paid;
      case "PENDING":
        return PayOsPaymentStatus.pending;
      case "PROCESSING":
        return PayOsPaymentStatus.processing;
      case "CANCELLED":
        return PayOsPaymentStatus.cancelled;
      case "EXPIRED":
        return PayOsPaymentStatus.expired;
      default:
        throw ArgumentError('Invalid value for PayOsPaymentStatus: $value');
    }
  }
}
