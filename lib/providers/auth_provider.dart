import 'package:fliq/model/user_model.dart';
import 'package:fliq/services/api_services.dart';
import 'package:flutter/material.dart';


class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  String _phoneNumber = '';
  String _countryCode = '+91';
  bool _isLoading = false;
  bool _otpSent = false;
  bool _isVerified = false;
  String _errorMessage = '';
  User? _user;

  String get phoneNumber => _phoneNumber;
  String get countryCode => _countryCode;
  bool get isLoading => _isLoading;
  bool get otpSent => _otpSent;
  bool get isVerified => _isVerified;
  String get errorMessage => _errorMessage;
  User? get user => _user;

  void setCountryCode(String code) {
    _countryCode = code;
    notifyListeners();
  }

  Future<void> requestOtp(String phone, {required String otp}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _phoneNumber = phone;
      final result = await _apiService.requestOtp(phone, otp: '');
      if (result) {
        _otpSent = true;
      } else {
        _errorMessage = 'Failed to send OTP. Please try again.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final verifiedUser = await _apiService.verifyOtp(phone, otp);
      if (verifiedUser != null) {
        _isVerified = true;
        _user = verifiedUser as User?;
      } else {
        _errorMessage = 'Invalid OTP. Please try again.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

//@Random OTP Codes || 

// import 'package:fliq/model/user_model.dart';
// import 'package:fliq/services/api_services.dart';
// import 'package:flutter/material.dart';
// import 'dart:math'; // Add this import for Random

// class AuthProvider with ChangeNotifier {
//   final ApiService _apiService = ApiService();

//   String _phoneNumber = '';
//   String _countryCode = '+91';
//   bool _isLoading = false;
//   bool _otpSent = false;
//   bool _isVerified = false;
//   String _errorMessage = '';
//   User? _user;
//   String? _currentOtp; // Add this to store the generated OTP

//   String get phoneNumber => _phoneNumber;
//   String get countryCode => _countryCode;
//   bool get isLoading => _isLoading;
//   bool get otpSent => _otpSent;
//   bool get isVerified => _isVerified;
//   String get errorMessage => _errorMessage;
//   User? get user => _user;
//   String? get currentOtp => _currentOtp; // Expose for debugging

//   void setCountryCode(String code) {
//     _countryCode = code;
//     notifyListeners();
//   }

//   Future<void> requestOtp(String phone, {String? otp}) async { // Make otp optional
//     _isLoading = true;
//     _errorMessage = '';
//     notifyListeners();

//     try {
//       _phoneNumber = phone;
      
//       // Generate or use passed OTP
//       _currentOtp = otp ?? _generateRandomOtp();
      
//       // For testing, print the OTP to console
//       debugPrint('Generated OTP: $_currentOtp');
      
//       // Send the OTP - in real app, this would be an API call to SMS service
//       // For now, we'll simulate the API call
//       final result = await _apiService.requestOtp(phone, otp: _currentOtp!);
      
//       if (result) {
//         _otpSent = true;
//       } else {
//         _errorMessage = 'Failed to send OTP. Please try again.';
//       }
//     } catch (e) {
//       _errorMessage = 'An error occurred: $e';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   String _generateRandomOtp() {
//     final random = Random();
//     return (100000 + random.nextInt(900000)).toString();
//   }

//   Future<void> verifyOtp(String phone, String otp) async {
//     _isLoading = true;
//     _errorMessage = '';
//     notifyListeners();

//     try {
//       // First check if the entered OTP matches our generated OTP
//       if (_currentOtp != null && otp == _currentOtp) {
//         _isVerified = true;
        
//         // Now call the API to verify (in a real app, this would be the actual verification)
//         final verifiedUser = await _apiService.verifyOtp(phone, otp);
        
//         if (verifiedUser != null) {
//           _user = verifiedUser as User?;
//         }
//       } else {
//         _errorMessage = 'Invalid OTP. Please try again.';
//       }
//     } catch (e) {
//       _errorMessage = 'An error occurred: $e';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }