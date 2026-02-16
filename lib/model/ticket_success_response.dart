// import 'package:pdf/src/widgets/flex.dart';

class TicketSuccessResponse {
  final String message;
  final String ticketNumber;
  final int totalVouchers;
  final PassengerDetails passengerDetails;

  TicketSuccessResponse({
    required this.message,
    required this.ticketNumber,
    required this.totalVouchers,
    required this.passengerDetails,
  });

  factory TicketSuccessResponse.fromJson(Map<String, dynamic> json) {
    return TicketSuccessResponse(
      message: json['message'],
      ticketNumber: json['ticket_number'],
      totalVouchers: json['total_vouchers'],
      passengerDetails:
          PassengerDetails.fromJson(json['passenger_details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'ticket_number': ticketNumber,
      'total_vouchers': totalVouchers,
      'passenger_details': passengerDetails.toJson(),
    };
  }
}

class PassengerDetails {
  final String leadName;
  final String email;
  final String phone;
  final int adults;
  final int children;
  final int infants;
  final double totalAmount;

  PassengerDetails({
    required this.leadName,
    required this.email,
    required this.phone,
    required this.adults,
    required this.children,
    required this.infants,
    required this.totalAmount,
  });

  factory PassengerDetails.fromJson(Map<String, dynamic> json) {
    return PassengerDetails(
      leadName: json['lead_name'],
      email: json['email'],
      phone: json['phone'],
      adults: json['adults'],
      children: json['children'],
      infants: json['infants'],
      totalAmount: (json['total_amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lead_name': leadName,
      'email': email,
      'phone': phone,
      'adults': adults,
      'children': children,
      'infants': infants,
      'total_amount': totalAmount,
    };
  }
}