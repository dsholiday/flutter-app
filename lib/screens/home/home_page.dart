import 'package:flutter/material.dart';
import 'package:travel_suite/screens/home/qr_scanner_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          child: Text("Scan QR Code"),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRScannerPage()),
            );

            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Scanned: $result')),
              );
            }
          },
        ),
      ),
    );
  }
}