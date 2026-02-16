import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:travel_suite/model/ticket_success_response.dart';

class PdfGenerator {
  static Future<void> generatePdf(BuildContext context, TicketSuccessResponse?  apiResponse) async {
    final pdf = pw.Document();

    String qrData = apiResponse?.ticketNumber ?? "";

    // Generate QR image
    final qrValidationResult = QrValidator.validate(
      data: qrData,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    final qrCode = qrValidationResult.qrCode;
    final qrImage = QrPainter.withQr(
      qr: qrCode!,
      color: const Color(0xFF000000),
      emptyColor: const Color(0xFFFFFFFF),
      gapless: true,
    );

    final picData = await qrImage.toImageData(300);
    final Uint8List qrBytes = picData!.buffer.asUint8List();

    final image = pw.MemoryImage(qrBytes);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Ticket Voucher",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Ticket No: ${apiResponse?.ticketNumber}"),
              pw.Text("Name: ${apiResponse?.passengerDetails.leadName}"),
              pw.Text("Email: ${apiResponse?.passengerDetails.email}"),
              pw.Text("Phone: ${apiResponse?.passengerDetails.phone}"),
              pw.SizedBox(height: 20),
              pw.Text(
                "Passengers",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text("Adults: ${apiResponse?.passengerDetails.adults}"),
              pw.Text("Children: ${apiResponse?.passengerDetails.children}"),
              pw.Text("Infants: ${apiResponse?.passengerDetails.infants}"),
              pw.SizedBox(height: 30),
              pw.Text(
                "Total Paid: ${apiResponse?.passengerDetails.totalAmount.toString()}",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),              
              pw.SizedBox(height: 30),
              pw.Center(
                child: pw.Image(image, width: 150, height: 150),
              ),
              pw.SizedBox(height: 30),
              pw.Text("Show this QR code at the entry point for varification"),
            ],
          );
        },
      ),
    );

    // Preview PDF
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}

// ElevatedButton(
//   onPressed: () {
//     PdfGenerator.generatePdf(context);
//   },
//   child: Text("Generate PDF"),
// )