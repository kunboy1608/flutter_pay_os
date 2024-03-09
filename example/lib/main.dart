import 'package:flutter/material.dart';
import 'package:flutter_pay_os/flutter_pay_os.dart';

import 'pay_os_payment_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pay Os Payment demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Pay Os payment demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _apiKey = "d9577d16-4b5b-4fa3-8615-2e406a33dc29";
  final String _clientId = "6b6ca155-fd33-4749-b19e-8dfd9e24376d";
  final String _checksumKey =
      "2acd99b3d539dc620c19e8af365ba0d6f6ed4b9e211fd876d0c2013f6031414a";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: () async {
                final payOs = PayOsService(
                    clientId: _clientId,
                    apiKey: _apiKey,
                    checksumKey: _checksumKey);
                final products = PayOsPaymentData(
                    orderCode: 4,
                    amount: 2000,
                    description: "Flutter PayOs demo",
                    items: [
                      PayOsItemData(name: "name", price: 2000, quantity: 1)
                    ],
                    cancelUrl: "https://www.google.com",
                    returnUrl: "https://www.google.com",
                    buyerAddress: "Ho Chi Minh City, Vietnam",
                    buyerEmail: "kunboy1608@gmail.com",
                    buyerName: "HoangDP",
                    buyerPhone: "0987654321",
                    expiredAt: PayOsUtils.convertDateTime2Int32(
                        DateTime(2030, 10, 2, 10, 2)));
                final response = PayOsPaymentResponse.fromMap(
                    await payOs.createPaymentLink(products));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PayOsPaymentScreen(
                              payOsPaymentResponse: response,
                              apiKey: _apiKey,
                              clientId: _clientId,
                              checksumKey: _checksumKey,
                            )));
              },
              child: Text("Pay"))),
    );
  }
}
