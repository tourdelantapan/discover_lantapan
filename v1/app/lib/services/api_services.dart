import 'dart:convert';
import 'dart:io';
import 'package:app/services/api_status.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/shared_preferences.dart';
import 'package:http/http.dart' as http;

class APIServices {
  static Future<Object> get(
      {required String endpoint, Map<String, dynamic>? query}) async {
    try {
      String token = await getToken();
      var url = Uri.parse("$BASE_URL$endpoint").replace(queryParameters: query);
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });
      if ([200, 201].contains(response.statusCode)) {
        return Success(
            code: response.statusCode, response: jsonDecode(response.body));
      } else {
        return Failure(
            code: response.statusCode, response: jsonDecode(response.body));
      }
    } on HttpException {
      return Failure(code: 101, response: {"message": 'No Internet'});
    } on FormatException {
      return Failure(code: 102, response: {"message": 'Invalid Format'});
    } catch (e) {
      return Failure(code: 103, response: {"message": 'Unknown Error'});
    }
  }

  static Future<Object> post(
      {required String endpoint, required Map<String, dynamic> payload}) async {
    try {
      String token = await getToken();
      var url = Uri.parse("$BASE_URL$endpoint");

      var response = await http
          .post(url, body: jsonEncode(payload), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return Success(code: 200, response: jsonDecode(response.body));
      } else {
        return Failure(
            code: response.statusCode, response: jsonDecode(response.body));
      }
    } on HttpException {
      return Failure(code: 101, response: {"message": 'No Internet'});
    } on FormatException {
      return Failure(code: 102, response: {"message": 'Invalid Format'});
    } catch (e) {
      print(e);
      return Failure(code: 103, response: {"message": 'Unknown Error'});
    }
  }
}
