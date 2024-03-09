import 'package:flutter/material.dart';
import 'package:flutter_pay_os/flutter_pay_os.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PayOsPaymentScreen extends StatefulWidget {
  const PayOsPaymentScreen({
    super.key,
    required this.payOsPaymentResponse,
    required this.apiKey,
    required this.clientId,
    required this.checksumKey,
  });

  final PayOsPaymentResponse payOsPaymentResponse;
  final String apiKey;
  final String clientId;
  final String checksumKey;

  @override
  State<PayOsPaymentScreen> createState() => _PayOsPaymentScreenState();
}

class _PayOsPaymentScreenState extends State<PayOsPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.payOsPaymentResponse.qrCode == null ||
        widget.payOsPaymentResponse.accountName == null ||
        widget.payOsPaymentResponse.accountNumber == null ||
        widget.payOsPaymentResponse.amount == null ||
        widget.payOsPaymentResponse.description == null) {
      return const Center(
        child: Text("Please try again"),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment by PayOs"),
      ),
      body: Wrap(
        alignment: WrapAlignment.center,
        children: [
          QrImageView(
            data: widget.payOsPaymentResponse.qrCode!,
            size: 200,
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: PayOsUtils.getBankList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!["data"] != null) {
                    List<Map<String, dynamic>> bankListAsMaps =
                        List<Map<String, dynamic>>.from(snapshot.data!["data"]);
                    Map<String, dynamic> matchedBank =
                        bankListAsMaps.firstWhere((bank) =>
                            bank["bin"] == widget.payOsPaymentResponse.bin);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(matchedBank["logo"]),
                        Text("Bank: ${matchedBank["name"]}")
                      ],
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(height: 16),
              Text("Account name: ${widget.payOsPaymentResponse.accountName}"),
              const SizedBox(height: 16),
              Text(
                  "Account number: ${widget.payOsPaymentResponse.accountNumber}"),
              const SizedBox(height: 16),
              Text(
                  "Amount: ${widget.payOsPaymentResponse.amount} ${widget.payOsPaymentResponse.currency ?? ""}"),
              const SizedBox(height: 16),
              Text("Content: ${widget.payOsPaymentResponse.description}"),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 10,
          left: 10,
          right: 10,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                  onPressed: () {
                    PayOsService(
                            clientId: widget.clientId,
                            apiKey: widget.apiKey,
                            checksumKey: widget.checksumKey)
                        .cancelPaymentLink(
                            widget.payOsPaymentResponse.orderCode!.toInt(),
                            "Cancellation reason")
                        .then((value) {
                      debugPrint(value["desc"].toString());
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text("Cancel")),
            ),
            const SizedBox(width: 10),
            Expanded(
                flex: 1,
                child: ElevatedButton(
                    onPressed: () {
                      PayOsService(
                              clientId: widget.clientId,
                              apiKey: widget.apiKey,
                              checksumKey: widget.checksumKey)
                          .getPaymentLinkInformation(
                              widget.payOsPaymentResponse.orderCode!.toInt())
                          .then((value) {
                        final result = PayOsPaymentResponse.fromMap(value);
                        switch (result.status) {
                          case PayOsPaymentStatus.paid:
                            Fluttertoast.showToast(msg: "Paid");
                            break;
                          case PayOsPaymentStatus.cancelled:
                            Fluttertoast.showToast(msg: "Cancelled");
                          case PayOsPaymentStatus.pending:
                            Fluttertoast.showToast(msg: "Pending");
                          case PayOsPaymentStatus.processing:
                            Fluttertoast.showToast(msg: "Processing");
                          case PayOsPaymentStatus.expired:
                            Fluttertoast.showToast(msg: "Expired");
                          default:
                            Fluttertoast.showToast(msg: "Please try again");
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text("Check"))),
          ],
        ),
      ),
    );
  }
}
