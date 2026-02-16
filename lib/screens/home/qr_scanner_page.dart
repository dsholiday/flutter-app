import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:travel_suite/services/api_exceptions.dart';
import 'package:travel_suite/services/api_service.dart';
import 'package:travel_suite/utils/loader_overlay.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  final NetworkManager _apiService = NetworkManager();

  Future<void> _callTicketVerifyApi(String qrData) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoaderOverlay.show(context);
    });
    try {      
      final response = await _apiService.post(
              '/tickets/verify/',
              data: {
                'ticket_number': qrData,                
              },
          );          
            LoaderOverlay.hide();
            showMessage("QR code verified");
            // Navigator.pop(context, code);
            // if (!mounted) return;
            // navigateToOtpPage(context, _identfierController.text);
        // Navigate to home page or save token
        } on ApiException catch (e) {                 
            LoaderOverlay.hide();
            showMessage(e.message);            
        } catch (e) {          
          LoaderOverlay.hide();
          showMessage("Unexpected error occurred");          
    }
  }

   void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner"),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        onDetect: (barcodeCapture) {
          final List<Barcode> barcodes = barcodeCapture.barcodes;
          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {              
              //Navigator.pop(context, code);
              // break;
              _callTicketVerifyApi(code);
            }
          }
        },
      ),
    );
  }
  // MobileScanner(
  //       onDetect: (result) {
  //         print(result.barcodes.first.rawValue);
  //       },
}