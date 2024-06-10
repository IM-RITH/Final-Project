import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> fetchAccessToken() async {
  final response =
      await http.get(Uri.parse('http://192.168.1.216:3000/getAccessToken'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['access_token'];
  } else {
    throw Exception('Failed to load access token');
  }
}
