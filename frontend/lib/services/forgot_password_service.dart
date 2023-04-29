import 'package:medical_chain_manangement/config.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordService {
  Future<bool> forgotPassword(String email) async {
    final response = await http.post(
        Uri.http(BASE_URL, '/api/v1/password/forgot', {
          'email': email,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });

    if (response.statusCode == 200) {
      print(response);
      Fluttertoast.showToast(
          msg: "Sent reset password token to this email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.toString());
    }
  }

  Future<bool> resetPassword(
      String email, String forgotPasswordToken, String password) async {
    final response = await http.post(
        Uri.http(BASE_URL, '/api/v1/password/reset', {
          'email': email,
          'token': forgotPasswordToken,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });

    if (response.statusCode == 200) {
      print(response);
      Fluttertoast.showToast(
          msg: "Password reset successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.toString());
    }
  }
}