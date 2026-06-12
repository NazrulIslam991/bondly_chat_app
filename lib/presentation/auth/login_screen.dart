import 'package:flutter/material.dart';

import '../../core/resources/themes/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = "+880";

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Phone',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Please confirm your country code and enter your phone number.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Country Picker Placeholder (WhatsApp / Telegram style)
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppTheme.primary, width: 1.5),
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Bangladesh',
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(
                    Icons.arrow_drop_down,
                    color: AppTheme.primary,
                  ),
                  onTap: () {
                    // কান্ট্রি পিকার শিট বা ডায়ালগ ওপেন করার জন্য
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Phone Number Input Row
              Row(
                children: [
                  // Country Code field
                  Container(
                    width: 70,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppTheme.primary, width: 1.5),
                      ),
                    ),
                    child: TextField(
                      readOnly: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: _selectedCountryCode,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Main Phone Number Field
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppTheme.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                          fontSize: 18,
                          letterSpacing: 1.5,
                        ),
                        decoration: const InputDecoration(
                          hintText: '00000-00000',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Floating Action Button Style Next Button (Like Telegram)
              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  onPressed: () {
                    if (_phoneController.text.isNotEmpty) {
                      String fullNumber =
                          "$_selectedCountryCode${_phoneController.text}";
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => OtpVerificationScreen(phoneNumber: fullNumber),
                      //   ),
                      // );
                    }
                  },
                  backgroundColor: AppTheme.primary,
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
