// import 'dart:io';
// import 'dart:ui' as ui;

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:travel_suite/model/ticket_success_response.dart';
import 'package:travel_suite/services/api_exceptions.dart';
import 'package:travel_suite/services/api_service.dart';
import 'package:travel_suite/utils/loader_overlay.dart';
import 'package:travel_suite/utils/pdf_genertor.dart';
import 'package:travel_suite/widgets/label_value.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class TicketSuccess extends StatefulWidget {
  final int bookingLeadId;
  const TicketSuccess({super.key, required this.bookingLeadId});

  @override
  State<TicketSuccess> createState() => _TicketSuccessState();
}

class _TicketSuccessState extends State<TicketSuccess> {
  final NetworkManager _apiService = NetworkManager();
  final GlobalKey qrKey = GlobalKey();
  TicketSuccessResponse?  apiResponse;
  // String qrData = "";

  @override
  void initState() {
    super.initState();    
    fetchTicketDetails();
  }

  void fetchTicketDetails() async {
   WidgetsBinding.instance.addPostFrameCallback((_) {
      LoaderOverlay.show(context);
    });
    try {
      final response = await _apiService.post(
        '/tickets/create/',
        data: {
          'booking_lead_id': widget.bookingLeadId,
        },
      );
      LoaderOverlay.hide();
      setState(() {
        apiResponse = TicketSuccessResponse.fromJson(response.data);      
     });
      //final responseTS = TicketSuccessResponse.fromJson(response.data);
      // print("data-------${responseTS.passengerDetails.leadName}");
      // print(responseTS.ticketNumber);
      // qrData = responseTS.ticketNumber;
    } on ApiException catch (e) {                               
            LoaderOverlay.hide();
            showMessage(e.message);
    } catch (_) {
      LoaderOverlay.hide();
      showMessage("Unexpected error occurred");
    }
  }
   void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }


  // Future<File> _saveQrCode() async {
  //   try {
  //     final boundary =
  //         qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //     final image = await boundary.toImage(pixelRatio: 3.0);
  //     final byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);
  //     final pngBytes = byteData!.buffer.asUint8List();

  //     final dir = await getApplicationDocumentsDirectory();
  //     final file = File(
  //       '${dir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png',
  //     );

  //     await file.writeAsBytes(pngBytes);
  //     return file;
  //   } catch (e) {
  //     throw Exception("Failed to save QR: $e");
  //   }
  // }

  // Future<void> _shareQrCode() async {
  //   final file = await _saveQrCode();
  //   await Share.shareXFiles(
  //     [XFile(file.path)],
  //     text: 'Here is my QR code',
  //   );
  // }


Future<Uint8List> generatePdfFromApi(TicketSuccessResponse apiData) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,

      
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'API Data Report',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            // ...apiData.map((item) {
            //   return pw.Column(
            //     crossAxisAlignment: pw.CrossAxisAlignment.start,
            //     children: [
            //       pw.Text('Name: ${apiData.passengerDetails.leadName}'),
            //       pw.Text('Email: ${apiData.passengerDetails.email}'),
            //       pw.Text('Phone: ${apiData.passengerDetails.phone}'),
            //       pw.SizedBox(height: 10),
            //     ],
            //   );
            // }),
          ],
        );
      },
    ),
  );

  return pdf.save();
}

  Future<void> sharePdfFromApi() async {    
    final pdfData = await generatePdfFromApi(apiResponse!);

    await Printing.sharePdf(
      bytes: pdfData,
      filename: 'api_report.pdf',
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Confirmation'),
      automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // children: [
          //   RepaintBoundary(
          //     key: qrKey,
          //     child: Container(
          //       color: Colors.white,
          //       padding: const EdgeInsets.all(12),
          //       child: QrImageView(
          //         data: qrData,
          //         size: 220,
          //       ),
          //     ),
          //   ),
          //   const SizedBox(height: 20),
          //   TextField(
          //     decoration: InputDecoration(
          //       labelText: qrData,
          //       border: const OutlineInputBorder(),
          //     ),
          //     onChanged: (value) {
          //       setState(() => qrData = value);
          //     },
          //   ),
          //   const SizedBox(height: 20),
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       ElevatedButton.icon(
          //         icon: const Icon(Icons.download),
          //         label: const Text("Download"),
          //         onPressed: () async {
          //           final file = await _saveQrCode();
          //           ScaffoldMessenger.of(context).showSnackBar(
          //             SnackBar(content: Text("Saved to ${file.path}")),
          //           );
          //         },
          //       ),
          //       ElevatedButton.icon(
          //         icon: const Icon(Icons.share),
          //         label: const Text("Share"),
          //         onPressed: _shareQrCode,
          //       ),
          //     ],
          //   ),
          // ],
        children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            border: Border.all(
              color: Colors.green.shade300
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
           children: [ 
            Text(
              'Booking Confirmed!',
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),   
          RichText(
              text: TextSpan(
                text: 'Ticket Number: ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                children: [
                  TextSpan(
                    text: apiResponse?.ticketNumber ?? "No Ticket",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),//Rich Text          
           ],
          )
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelValue(label: 'Passenger Details', value:""),
              SizedBox(height: 10),
              LabelValue(label: 'Name', value: apiResponse?.passengerDetails.leadName ?? ""),
              SizedBox(height: 5),
              LabelValue(label: 'Email', value: apiResponse?.passengerDetails.email ?? ""),
              SizedBox(height: 5),
              LabelValue(label: 'Phone', value: apiResponse?.passengerDetails.phone ?? ""),
              SizedBox(height: 5),
              LabelValue(label: 'Adults', value: apiResponse?.passengerDetails.adults.toString() ?? "1"),
              SizedBox(height: 5),
              LabelValue(label: 'Children', value: apiResponse?.passengerDetails.children.toString() ?? "0"),
              SizedBox(height: 5),
              LabelValue(label: 'Infants', value: apiResponse?.passengerDetails.infants.toString() ?? "0"),
              SizedBox(height: 15),
              LabelValue(label: 'Total Paid', value: apiResponse?.passengerDetails.totalAmount.toString() ?? "0"),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.qr_code, size: 18, color: Colors.blue),
                  // SizedBox(width: 6),
                  Text(
                    'Scan at Entry',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Icon(Icons.info, size: 18, color: Colors.blue),
              // SizedBox(width: 6),
              
              const SizedBox(height: 20),
              RepaintBoundary(
                key: qrKey,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(12),
                  child: QrImageView(
                    data: apiResponse?.ticketNumber ?? "No Ticket",
                    size: 220,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text("Share"),
                  onPressed: () async {
                      await PdfGenerator.generatePdf(context,apiResponse);
                  }                  
            ),
            // const SizedBox(height: 20),
            Text(
              'Show this QR code at the counter for verification',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,                
              ),
            )
          ],
          ),
        ),
        ],
      ),
      ),
    );    
  }
}