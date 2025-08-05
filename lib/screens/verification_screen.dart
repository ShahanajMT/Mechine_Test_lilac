

// import 'dart:math';

// import 'package:fliq/providers/auth_provider.dart';
// import 'package:fliq/screens/message_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
// import 'package:provider/provider.dart';

// class VerificationScreen extends StatefulWidget {
//   const VerificationScreen({super.key});

//   @override
//   State<VerificationScreen> createState() => _VerificationScreenState();
// }

// class _VerificationScreenState extends State<VerificationScreen> {
//   final TextEditingController _otpController = TextEditingController();
//   late String _generatedOtp;

//   @override
//   void initState() {
//     super.initState();
//     // Generate initial OTP
//     _generateOtp();
//     // Send OTP immediately when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _sendOtpToPhone();
//     });
//   }

//   @override
//   void dispose() {
//     _otpController.dispose();
//     super.dispose();
//   }

//   void _generateOtp() {
//     final random = Random();
//     _generatedOtp = (100000 + random.nextInt(900000)).toString();
//     debugPrint('Generated OTP: $_generatedOtp');
//   }

//   Future<void> _sendOtpToPhone() async {
//     final authProvider = context.read<AuthProvider>();
//     await authProvider.requestOtp(authProvider.phoneNumber, otp: _generatedOtp);
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('OTP has been sent to your phone'),
//           action: SnackBarAction(
//             label: 'Show OTP',
//             textColor: Colors.white,
//             onPressed: () {
//               // For development/testing purposes only
//               _otpController.text = _generatedOtp;
//               setState(() {});
//             },
//           ),
//           duration: const Duration(seconds: 5),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final defaultPinTheme = PinTheme(
//       width: 56,
//       height: 56,
//       textStyle: const TextStyle(
//         fontSize: 22,
//         color: Colors.black,
//         fontWeight: FontWeight.bold,
//       ),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(8),
//       ),
//     );

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Enter verification code',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Sent to ${authProvider.phoneNumber}',
//               style: const TextStyle(color: Colors.grey),
//             ),
//             const SizedBox(height: 30),
            
//             // PinPut for OTP input
//             Center(
//               child: Pinput(
//                 length: 6,
//                 controller: _otpController,
//                 defaultPinTheme: defaultPinTheme,
//                 focusedPinTheme: defaultPinTheme.copyDecorationWith(
//                   border: Border.all(color: Colors.pink),
//                 ),
//                 submittedPinTheme: defaultPinTheme.copyDecorationWith(
//                   color: Colors.pink.withOpacity(0.1),
//                 ),
//                 showCursor: true,
//                 keyboardType: TextInputType.number,
//                 onCompleted: (value) {
//                   // Auto-submit when all digits are entered
//                   _verifyOtp(authProvider, value);
//                 },
//               ),
//             ),
            
//             const SizedBox(height: 30),
//             const Text('Didn\'t get anything? No worries, let\'s try again.'),
//             TextButton(
//               onPressed: authProvider.isLoading
//                   ? null
//                   : () async {
//                       _generateOtp();
//                       await _sendOtpToPhone();
//                     },
//               child: const Text(
//                 'Resend',
//                 style: TextStyle(color: Colors.pink),
//               ),
//             ),
//             if (authProvider.errorMessage.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: Text(
//                   authProvider.errorMessage,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),
//             const Spacer(),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: authProvider.isLoading
//                     ? null
//                     : () => _verifyOtp(authProvider, _otpController.text),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.pink,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: authProvider.isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text('Verify'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _verifyOtp(AuthProvider authProvider, String otp) async {
//     await authProvider.verifyOtp(authProvider.phoneNumber, otp);
//     if (!mounted) return;
//     if (authProvider.isVerified) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const MessagesScreen()),
//       );
//     }
//   }
// }

import 'dart:async';

import 'package:fliq/providers/auth_provider.dart';
import 'package:fliq/screens/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  late String _generatedOtp;
  bool _isResendEnabled = true;
  int _resendCountdown = 30;
  late Timer _resendTimer;

  @override
  void initState() {
    super.initState();
    _generateOtp();
    _sendOtpToPhone();
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _resendTimer.cancel();
    super.dispose();
  }

  void _generateOtp() {
    final random = Random();
    _generatedOtp = (100000 + random.nextInt(900000)).toString();
    debugPrint('Generated OTP: $_generatedOtp');
  }

  Future<void> _sendOtpToPhone() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.requestOtp(authProvider.phoneNumber, otp: _generatedOtp);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('OTP has been sent to your phone'),
          action: SnackBarAction(
            label: 'Show OTP',
            textColor: Colors.white,
            onPressed: () {
              // For development/testing purposes only
              _otpController.text = _generatedOtp;
              setState(() {});
            },
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _startResendTimer() {
    _isResendEnabled = false;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
        setState(() => _isResendEnabled = true);
      }
    });
  }

  void _resendOtp() {
    _generateOtp();
    _sendOtpToPhone();
    setState(() {
      _resendCountdown = 30;
      _isResendEnabled = false;
    });
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter verification code',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Sent to ${authProvider.phoneNumber}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            
            // PinPut for OTP input
            Center(
              child: Pinput(
                length: 6,
                controller: _otpController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyDecorationWith(
                  border: Border.all(color: Colors.pink),
                ),
                submittedPinTheme: defaultPinTheme.copyDecorationWith(
                  color: Colors.pink.withOpacity(0.1),
                ),
                showCursor: true,
                keyboardType: TextInputType.number,
                onCompleted: (value) {
                  // Auto-submit when all digits are entered
                  _verifyOtp(authProvider, value);
                },
              ),
            ),
            
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Resend OTP in $_resendCountdown seconds',
                  style: TextStyle(
                    color: _isResendEnabled ? Colors.black : Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: _isResendEnabled && !authProvider.isLoading
                      ? _resendOtp
                      : null,
                  child: const Text(
                    'Resend',
                    style: TextStyle(color: Colors.pink),
                  ),
                ),
              ],
            ),
            if (authProvider.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  authProvider.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authProvider.isLoading
                    ? null
                    : () => _verifyOtp(authProvider, _otpController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: authProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyOtp(AuthProvider authProvider, String otp) async {
    await authProvider.verifyOtp(authProvider.phoneNumber, otp);
    if (!mounted) return;
    if (authProvider.isVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MessagesScreen()),
      );
    }
  }
}