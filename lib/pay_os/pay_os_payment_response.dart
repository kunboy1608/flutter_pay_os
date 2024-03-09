import 'pay_os_payment_status.dart';
import 'pay_os_utils.dart';
import 'pay_os_payment_data.dart';

/// [PayOsPaymentResponse] is a class that encapsulates the response from a PayOs payment operation.
///
/// Each instance of [PayOsPaymentResponse] represents a single payment operation,
/// with various details about the operation.
class PayOsPaymentResponse {
  /// The ID of the bank involved in the transaction.
  /// This can be obtained using the [PayOsUtils.getBankList] method for local banks in Vietnam.
  String? bin;

  /// The virtual account number for the transaction.
  /// This is not the real account number of the user.
  /// If the user transfers money via their real account number,
  /// the transaction will not be triggered.
  String? accountNumber;

  /// The real account number of the user.
  /// This should match the account number linked with the payment gateway.
  String? accountName;

  /// The amount of the order in the transaction.
  num? amount;

  /// A description of the order.
  String? description;

  /// The order code for the transaction.
  /// It is the same [PayOsPaymentData.orderCode]
  num? orderCode;

  /// The currency used in the transaction.
  String? currency;

  /// The ID of the payment link for the transaction.
  String? paymentLinkId;

  /// The status of the order.
  PayOsPaymentStatus? status;

  /// The URL link for the payment on the PayOs web platform.
  /// The structure is typically "https://pay.payos.vn/web/[paymentLinkId]"
  String? checkoutUrl;

  /// A String representation of a QR code for the transaction.
  /// This can be converted into an image using the `qr_flutter` package, which the user can then scan.it.
  String? qrCode;

  PayOsPaymentResponse({
    this.bin,
    this.accountNumber,
    this.accountName,
    this.amount,
    this.description,
    this.orderCode,
    this.currency,
    this.paymentLinkId,
    this.status,
    this.checkoutUrl,
    this.qrCode,
  });

  factory PayOsPaymentResponse.fromMap(Map<String, dynamic> map) {
    return PayOsPaymentResponse(
      bin: map["bin"],
      accountNumber: map["accountNumber"],
      accountName: map["accountName"],
      amount: map["amount"],
      description: map["description"],
      orderCode: map["orderCode"],
      currency: map["currency"],
      paymentLinkId: map["paymentLinkId"],
      status: PayOsPaymentStatus.fromValue(map["status"]),
      checkoutUrl: map["checkoutUrl"],
      qrCode: map["qrCode"],
    );
  }
}
