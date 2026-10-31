import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../repositories/auth_repository.dart';

class AuthScreen extends StatefulWidget {
  final String langCode;
  const AuthScreen({super.key, required this.langCode});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignUpMode = false;
  bool _rememberMe = true;

  final _emailController = TextEditingController(text: 'farmer@terragen.ag');
  final _passwordController = TextEditingController(text: 'password123');

  // Sign up controllers
  final _fullNameController = TextEditingController(text: 'Ram Kaushik');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _farmNameController = TextEditingController(text: 'PSG Green Agro Farm');
  final _farmLocationController = TextEditingController(text: 'Coimbatore, Tamil Nadu');
  final _soilTypeController = TextEditingController(text: 'Red Loamy Soil');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _farmNameController.dispose();
    _farmLocationController.dispose();
    _soilTypeController.dispose();
    super.dispose();
  }

  void _showForgotPasswordDialog() {
    final resetController = TextEditingController(text: _emailController.text);
    bool isOtpSent = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(AppStrings.get(widget.langCode, 'resetPassword')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Enter your email or phone number to receive password reset OTP:'),
                const SizedBox(height: 12),
                TextField(
                  controller: resetController,
                  decoration: InputDecoration(
                    labelText: AppStrings.get(widget.langCode, 'email'),
                    border: const OutlinedInputBorder(),
                  ),
                ),
                if (isOtpSent) ...[
                  const SizedBox(height: 12),
                  Text(
                    'OTP sent successfully to ${resetController.text}!',
                    style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!isOtpSent) {
                    setDialogState(() {
                      isOtpSent = true;
                    });
                  } else {
                    Navigator.pop(ctx);
                  }
                },
                child: Text(isOtpSent ? 'Done' : 'Send OTP'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.langCode;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.agriculture, size: 72, color: Colors.green.shade700),
                const SizedBox(height: 12),
                Text(
                  AppStrings.get(lang, 'appName'),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                Text(
                  AppStrings.get(lang, 'appTagline'),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                if (_isSignUpMode) ...[
                  TextField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: AppStrings.get(lang, 'fullName'),
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlinedInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: AppStrings.get(lang, 'phoneNumber'),
                      prefixIcon: const Icon(Icons.phone),
                      border: const OutlinedInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _farmNameController,
                    decoration: InputDecoration(
                      labelText: AppStrings.get(lang, 'farmName'),
                      prefixIcon: const Icon(Icons.agriculture),
                      border: const OutlinedInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _farmLocationController,
                    decoration: InputDecoration(
                      labelText: AppStrings.get(lang, 'farmLocation'),
                      prefixIcon: const Icon(Icons.location_on),
                      border: const OutlinedInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _soilTypeController,
                    decoration: InputDecoration(
                      labelText: AppStrings.get(lang, 'soilType'),
                      prefixIcon: const Icon(Icons.science),
                      border: const OutlinedInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AppStrings.get(lang, 'email'),
                    prefixIcon: const Icon(Icons.email),
                    border: const OutlinedInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: AppStrings.get(lang, 'password'),
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlinedInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),

                if (!_isSignUpMode)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (val) => setState(() => _rememberMe = val ?? true),
                          ),
                          Text(AppStrings.get(lang, 'rememberMe'), style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      TextButton(
                        onPressed: _showForgotPasswordDialog,
                        child: Text(
                          AppStrings.get(lang, 'forgotPassword'),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_isSignUpMode) {
                        AuthRepository().register(
                          fullName: _fullNameController.text,
                          email: _emailController.text,
                          phoneNumber: _phoneController.text,
                          farmName: _farmNameController.text,
                          farmLocation: _farmLocationController.text,
                          soilType: _soilTypeController.text,
                        );
                      } else {
                        AuthRepository().login(_emailController.text, _passwordController.text);
                      }
                    },
                    child: Text(
                      _isSignUpMode ? AppStrings.get(lang, 'signUp') : AppStrings.get(lang, 'login'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () => setState(() => _isSignUpMode = !_isSignUpMode),
                  child: Text(
                    _isSignUpMode
                        ? AppStrings.get(lang, 'alreadyHaveAccount')
                        : AppStrings.get(lang, 'dontHaveAccount'),
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
