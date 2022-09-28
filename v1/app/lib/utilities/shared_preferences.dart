import 'package:shared_preferences/shared_preferences.dart';

setToken(String accessToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);
}

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('accessToken') ?? "";
  return token;
}

setLogInMode(String mode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('logInMode', mode);
}

Future<String> getLogInMode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('logInMode') ?? "";
  return token;
}
