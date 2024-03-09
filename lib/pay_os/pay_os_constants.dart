class PayOsConstants {
  static const String payOsBaseUrl = "https://api-merchant.payos.vn";

  static const Map<String, String> errorMessage = {
    "NO_SIGNATURE": "No signature.",
    "NO_DATA": "No data.",
    "INVALID_SIGNATURE": "Invalid signature",
    "DATA_NOT_INTEGRITY":
        "The data is unreliable because the signature of the response does not match the signature of the data",
    "WEBHOOK_URL_INVALID": "Webhook URL invalid.",
    "UNAUTHORIZED": "Unauthorized.",
    "INTERNAL_SERVER_ERROR": "Internal Server Error.",
    "INVALID_PARAMETER": "Invalid Parameter.",
  };

  static const Map<String, String> errorCode = {
    "INTERNAL_SERVER_ERROR": "20",
    "UNAUTHORIZED": "401"
  };
}
