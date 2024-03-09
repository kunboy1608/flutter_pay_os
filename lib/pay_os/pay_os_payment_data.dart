import 'pay_os_item_data.dart';
import 'pay_os_utils.dart';
import 'pay_os_payment_response.dart';
import 'pay_os_service.dart';

/// [PayOsPaymentData] is a class that encapsulates the data for a payment operation in the PayOs system.
///
/// Each instance of [PayOsPaymentData] represents a single payment operation, with various details about the operation.
class PayOsPaymentData {
  /// The unique order code for the payment getaway.
  /// This must be unique for each payment getaway.
  int orderCode;

  /// The amount of the order. The minimum value is 2000.
  int amount;

  /// A description of the order.
  String description;

  /// A list of items in the order. This can be empty.
  List<PayOsItemData> items;

  /// The URL to which PayOs will send a webhook when the order is canceled.
  /// Format: [cancelUrl]?code=00&id=[PayOsPaymentResponse.paymentLinkId]&cancel=true&status=CANCELLED&orderCode=[orderCode]
  String cancelUrl;

  /// The URL to which PayOs will send a webhook when the order is paid.
  /// Format: [returnUrl]?code=00&id=[PayOsPaymentResponse.paymentLinkId]&cancel=false&status=PAID&orderCode=[orderCode]
  String returnUrl;

  /// The signature checks that the information has not been changed during the transfer of data from your system to payOS.
  /// You need to use the checksum key from the Payment Channel and HMAC_SHA256 to create signature and data in alphabetical
  /// format: amount=$amount&cancelUrl=$cancelUrl&description=$description&orderCode=$orderCode&returnUrl=$returnUrl.
  /// It will create automatically inside [PayOsService.createPaymentLink]
  String? signature;

  /// The name of the purchaser. This is used when integrating and creating electronic invoices.
  String? buyerName;

  /// The email of the purchaser. This is used when integrating and creating electronic invoices.
  String? buyerEmail;

  /// The phone number of the purchaser. This is used when integrating and creating electronic invoices.
  String? buyerPhone;

  /// The address of the purchaser. This is used when integrating and creating electronic invoices.
  String? buyerAddress;

  /// Represents the Unix Timestamp as an Int32 value.
  /// Use [PayOsUtils.convertDateTime2Int32] to convert a [DateTime] to Int32.
  /// When expires, the payment link will be closed.
  /// However, users can still utilize QR codes and content payments for this transaction.
  int? expiredAt;

  PayOsPaymentData({
    required this.orderCode,
    required this.amount,
    required this.description,
    required this.items,
    required this.cancelUrl,
    required this.returnUrl,
    this.signature,
    this.buyerName,
    this.buyerEmail,
    this.buyerPhone,
    this.buyerAddress,
    this.expiredAt,
  });

  Map<String, dynamic> toMap() => {
        'orderCode': orderCode,
        'amount': amount,
        'description': description,
        'items': [...items.map((e) => e.toMap())],
        'cancelUrl': cancelUrl,
        'returnUrl': returnUrl,
        'signature': signature,
        'buyerName': buyerName,
        'buyerEmail': buyerEmail,
        'buyerPhone': buyerPhone,
        'buyerAddress': buyerAddress,
        'expiredAt': expiredAt
      };
}
