import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'pay_os_payment_data.dart';

/// [PayOsUtils] is a utility class that provides various static methods to assist with PayOs payment operations.
class PayOsUtils {
  /// Converts a [Map] object into a query string.
  ///
  /// This method iterates over each key-value pair in the [object] map.
  /// If the value is a [List], it converts each item in the list to a [Map],
  /// sorts the map by key, encodes it as a JSON string, and adds it to the query string.
  /// If the value is a [String], it adds it to the query string as is.
  /// For all other types of values, it converts the value to a string and adds it to the query string.
  /// If the value is null, it adds an empty string to the query string.
  ///
  /// The resulting query string consists of each key-value pair joined by an equals sign (=),
  /// with each pair separated by an ampersand (&).
  ///
  /// @param [object] The [Map] object to convert into a query string.
  /// @return The query string representation of the [object] map.
  static String convertObjToQueryStr(Map<String, dynamic> object) {
    final List<String> parts = [];
    object.forEach((key, value) {
      if (value is List) {
        final List<String> valueAsStringList = value
            .map((item) => sortObjDataByKey(Map<String, dynamic>.from(item)))
            .map((sortedItem) => jsonEncode(sortedItem))
            .toList();
        parts.add('$key=$valueAsStringList');
      } else if (value is String) {
        parts.add('$key=$value');
      } else {
        parts.add('$key=${value ?? ""}');
      }
    });
    return parts.join('&');
  }

  /// Sorts a [Map] object by its keys.
  ///
  /// This method creates a new [Map] object that contains the same key-value pairs as the original [object] map,
  /// but with the pairs sorted by key in ascending order.
  ///
  /// If the value associated with a key is another [Map], this method will recursively sort that [Map] by its keys as well.
  ///
  /// @param [object] The [Map] object to sort.
  /// @return A new [Map] object that contains the same key-value pairs as the [object] map, sorted by key.
  static Map<String, dynamic> sortObjDataByKey(Map<String, dynamic> object) {
    final Map<String, dynamic> orderedObject = {};
    final List<MapEntry<String, dynamic>> sortedList = object.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    for (final entry in sortedList) {
      orderedObject[entry.key] =
          entry.value is Map ? sortObjDataByKey(entry.value) : entry.value;
    }
    return orderedObject;
  }

  /// Generates an HMAC SHA256 hash from a string [dataStr] using a secret [key].
  ///
  /// The [dataStr] and [key] are first encoded into bytes. Then, an HMAC SHA256 hash is generated from the data bytes using the key bytes.
  /// The resulting hash is then converted into a string and returned.
  static String generateHmacSHA256(String dataStr, String key) {
    final List<int> keyBytes = utf8.encode(key);
    final List<int> dataBytes = utf8.encode(dataStr);

    final Hmac hmacSha256 = Hmac(sha256, keyBytes);
    final Digest digest = hmacSha256.convert(dataBytes);
    return digest.toString();
  }

  /// Creates a signature from a [Map] object [data] using a secret [key].
  ///
  /// The [data] is first sorted by key. Then, it is converted into a query string.
  /// An HMAC SHA256 hash is then generated from the query string using the secret [key].
  /// The resulting hash is returned as the signature.
  static String createSignatureFromObj(Map<String, dynamic> data, String key) {
    final Map<String, dynamic> sortedDataByKey = sortObjDataByKey(data);
    final String dataQueryStr = convertObjToQueryStr(sortedDataByKey);
    return generateHmacSHA256(dataQueryStr, key);
  }

  /// Creates a signature for a [PayOsPaymentData] object [data] using a secret [key].
  ///
  /// The relevant fields from the [data] object are extracted and concatenated into a string.
  /// An HMAC SHA256 hash is then generated from this string using the secret [key].
  /// The resulting hash is returned as the signature.
  static String createSignatureOfPaymentRequest(
      PayOsPaymentData data, String key) {
    final int amount = data.amount;
    final String cancelUrl = data.cancelUrl;
    final String description = data.description;
    final int orderCode = data.orderCode;
    final String returnUrl = data.returnUrl;
    final String dataStr =
        'amount=$amount&cancelUrl=$cancelUrl&description=$description&orderCode=$orderCode&returnUrl=$returnUrl';
    return generateHmacSHA256(dataStr, key);
  }

  /// Converts a [DateTime] object into an Int32 representation.
  ///
  /// This method calculates the difference in seconds between the [dateTime] and a marked DateTime (1970, 1, 1).
  /// It then subtracts the timezone offset in seconds and an additional 3600 seconds (1 hour) from this difference.
  ///
  /// @param dateTime The [DateTime] object to convert into an Int32.
  /// @return The Int32 representation of the [DateTime] object.
  static int convertDateTime2Int32(DateTime dateTime) {
    final markDateTime = DateTime(1970, 1, 1);
    return dateTime.difference(markDateTime).inSeconds -
        dateTime.timeZoneOffset.inSeconds -
        3600;
  }

  /// Retrieves a list of banks from the VietQR API.
  ///
  /// This function makes an HTTP GET request to the VietQR API endpoint at
  /// 'https://api.vietqr.io/v2/banks'.
  ///
  /// The required headers include [Content-Type] set to 'application/json; charset=UTF-8'.
  ///
  /// If the API call is successful (HTTP status code 200), the response data is
  /// returned as a map of bank information. Otherwise, an exception is thrown
  /// indicating a failure to retrieve the bank list.
  ///
  /// Example usage:
  /// ```dart
  /// final bankList = await getBankList();
  /// print('Available banks: $bankList');
  /// ```
  static Future<Map<String, dynamic>> getBankList() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.vietqr.io/v2/banks'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to get Order');
      }
    } catch (e) {
      return {'error': 1};
    }
  }
}
