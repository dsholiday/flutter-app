import 'package:flutter/material.dart';
import 'package:travel_suite/screens/sightseeing/search_sightseeing.dart';
import 'package:travel_suite/services/api_exceptions.dart';
import 'package:travel_suite/services/secure_token_service.dart';
import 'package:travel_suite/utils/loader_overlay.dart';
import 'package:travel_suite/widgets/custom_text_field.dart';
import '../../services/api_service.dart';
// import '../../home_page.dart';

class OtpPage extends StatefulWidget {
  final String identifier; // could be email, userId, etc.
  const OtpPage({super.key, required this.identifier});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();
  final SecureStorageService _storage = SecureStorageService();
  final TextEditingController _otpController = TextEditingController();
  final NetworkManager _apiService = NetworkManager();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _submitOTP() async {
    if (_formKey.currentState!.validate()) {      
        WidgetsBinding.instance.addPostFrameCallback((_) {
          LoaderOverlay.show(context);
        });
      try {
        final response = await _apiService.post(
          '/employee/login/validate_otp/',
          data: {
            'identifier': widget.identifier.trim(),            
            'otp': _otpController.text.trim(),
          },
       );   
      
      String accessToken = response.data["access"];
      String refreshToken = response.data["refresh"];

      await _storage.saveTokens(accessToken, refreshToken);
       
        LoaderOverlay.hide();
        if (!mounted) return;
        navigateToHomePage(context);
        // Navigate to home page or save token
    } on ApiException catch (e) {                               
            LoaderOverlay.hide();
            showMessage(e.message);
    } catch (_) {
      LoaderOverlay.hide();
      showMessage("Unexpected error occurred");
    }
  }
    // if (_formKey.currentState!.validate()) {            
    //   try {
    //     final result = await _apiService.validateOTP(
    //       // _identfierController.text,
    //       "dolly",
    //       _otpController.text.trim(),
    //     );
    //     print('OTP validation successful: $result');
    //     if (!context.mounted) return;
    //     Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => const HomePage()),
    //       );
    //     // Navigate to home page or save token
    //   } catch (e) {
    //     print('OTP validation failed: $e');
    //     if (!context.mounted) return;
    //     // ignore: use_build_context_synchronously
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text(e.toString())),
    //     );
    //   } finally {
    //     // setState(() => isLoading = false);
    //   }
    // }else {
    //   if (!context.mounted) return;
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text("Invalid OTP")),
    //     );
    // }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

   void navigateToHomePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SearchSightSeeing()),
      (route) => false,
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP')),
      body: Center(
        child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey, // Assign key
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(107, 114, 128, 1),
                  ),
                ),
              const SizedBox(height: 16),
              CustomTextField(
                  controller: _otpController,
                  labelText: "OTP",
                  hintText: "6-digit OTP",
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter OTP';
                    } else if (value.length != 6) {
                      return 'OTP must be of 6 digits';
                    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'OTP must contain only numbers';
                    }
                      return null;
                    },
                ),              
              SizedBox(height: 16),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitOTP,
                    child: const Text(
                      'Verify OTP',                      
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}