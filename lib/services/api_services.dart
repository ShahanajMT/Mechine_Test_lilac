import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:japx/japx.dart';

class ApiService {
  static const String _baseUrl = 'https://test.myfliqapp.com/api/v1';

  Future<bool> requestOtp(String phone) async {
    final url = Uri.parse('$_baseUrl/auth/registration-otp-codes/actions/phone/send-otp');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'data': {
        'type': 'registration_otp_codes',
        'attributes': {
          'phone': phone,
        },
      },
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['status'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error requesting OTP: $e');
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    final url = Uri.parse('$_baseUrl/auth/registration-otp-codes/actions/phone/verify-otp');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'data': {
        'type': 'registration_otp_codes',
        'attributes': {
          'phone': phone,
          'otp': int.parse(otp),
          'device_meta': {
            'type': 'web',
            'device-name': 'Flutter Web',
          },
        },
      },
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['status'] == true) {
        final parsedJson = Japx.decode(jsonResponse);
        print('Verification successful: $parsedJson');
        return true;
      }
      return false;
    } catch (e) {
      print('Error verifying OTP: $e');
      return false;
    }
  }
}