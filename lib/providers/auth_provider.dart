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

  Future<void> requestOtp(String phone) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _phoneNumber = phone;
      final result = await _apiService.requestOtp(phone);
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
        _user = verifiedUser;
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