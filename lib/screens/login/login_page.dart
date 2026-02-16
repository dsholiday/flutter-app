import 'package:flutter/material.dart';
import 'package:travel_suite/services/api_exceptions.dart';
import 'package:travel_suite/utils/loader_overlay.dart';
import 'package:travel_suite/widgets/custom_text_field.dart';
import '../../services/api_service.dart';
import 'otp_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identfierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final NetworkManager _apiService = NetworkManager();

  bool isLoading = false;
  
  void _login() async {
    if (_formKey.currentState!.validate()) {   
       WidgetsBinding.instance.addPostFrameCallback((_) {
          LoaderOverlay.show(context);
        });           
      try {
            final response = await _apiService.post(
              '/employee/login/request-otp/',
              data: {
                'identifier': _identfierController.text.trim(),
                'password': _passwordController.text.trim(),
              },
          );    
          // print(response.data);   
            LoaderOverlay.hide();
            if (!mounted) return;
            navigateToOtpPage(context, _identfierController.text.trim());
        // Navigate to home page or save token
        } on ApiException catch (e) {       
            LoaderOverlay.hide();
            showMessage(e.message);
        } catch (_) {
          LoaderOverlay.hide();
          showMessage("Unexpected error occurred");
        }
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void navigateToOtpPage(BuildContext context, String identifier) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpPage(identifier: identifier),
      ),
    );
  }

  @override
  void dispose() {
    _identfierController.dispose();
    _passwordController.dispose();       
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Travel Suite',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.0,
                    color: const Color.fromRGBO(29, 78, 216, 1),
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  'Login to continue to your dashboard',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(107, 114, 128, 1),
                  ),
                ),
                const SizedBox(height: 30),

                // Email Field
                CustomTextField(
                  controller: _identfierController,
                  labelText: "Username/Email/Phone",
                  hintText: "Enter your username or email",
                  prefixIcon: Icons.person,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please fill in this field";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  labelText: "Password",
                  hintText: "Enter your password",
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }                
                    return null;//valid
                  },
                ),

                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _login,
                    child: const Text(
                      'Login',                      
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '\u00A9 2026 Travel Suite. All rights reserved.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
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
