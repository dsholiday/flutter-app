import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'home_page.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _submitOTP() async {
    if (_formKey.currentState!.validate()) {      
      // OTP is valid
      // String otp = _otpController.text.trim();
      // print('OTP Submitted: $otp');

      setState(() => isLoading = true);

      try {
        final result = await _apiService.validateOTP(
          // _identfierController.text,
          "dolly",
          _otpController.text.trim(),
        );
        print('OTP validation successful: $result');
        if (!context.mounted) return;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        // Navigate to home page or save token
      } catch (e) {
        print('OTP validation failed: $e');
        if (!context.mounted) return;
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }else {
      if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid OTP")),
        );
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign key
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6, // if OTP is 6 digits
                decoration: InputDecoration(
                  labelText: 'OTP',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter OTP';
                  } else if (value.length != 6) {
                    return 'OTP must be 6 digits';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'OTP must contain only numbers';
                  }
                  return null; // valid
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitOTP,
                child: Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}