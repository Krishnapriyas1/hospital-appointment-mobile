import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

class PatientLoginPage extends StatefulWidget {
  const PatientLoginPage({super.key});

  @override
  State<PatientLoginPage> createState() => _PatientLoginPageState();
}

class _PatientLoginPageState extends State<PatientLoginPage> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _requestOtp() async {
    FocusScope.of(context).unfocus();

    await authController.requestPatientOtp(
      _emailController.text,
    );

    if (!mounted) return;

    if (authController.errorMessage.value.isNotEmpty) {
      Get.snackbar(
        'Error',
        authController.errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _verifyOtp() async {
  FocusScope.of(context).unfocus();

  await authController.verifyPatientOtp(
    email: _emailController.text,
    otp: _otpController.text,
  );

  if (!mounted) return;

  if (authController.errorMessage.value.isNotEmpty) {
    Get.snackbar(
      'Error',
      authController.errorMessage.value,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 420,
              ),
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.local_hospital_rounded,
                              color: Colors.white,
                              size: 38,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Center(
                          child: Text(
                            'Welcome',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Center(
                          child: Text(
                            'Login to book your hospital appointment',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        const Text(
                          'Email address',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !authController.otpSent.value,
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        if (authController.otpSent.value) ...[
                          const SizedBox(height: 20),

                          const Text(
                            'OTP',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 8),

                          TextField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: InputDecoration(
                              hintText: 'Enter 6-digit OTP',
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                              ),
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: authController.isLoading.value
                                ? null
                                : authController.otpSent.value
                                    ? _verifyOtp
                                    : _requestOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                            child: authController.isLoading.value
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    authController.otpSent.value
                                        ? 'Verify OTP'
                                        : 'Send OTP',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),

                     
                        if (authController.otpSent.value) ...[
                          const SizedBox(height: 12),

                          Center(
                            child: TextButton(
                              onPressed:
                                  authController.isLoading.value
                                      ? null
                                      : () {
                                          _otpController.clear();
                                          authController.resetOtp();
                                        },
                              child: const Text(
                                'Change email',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}