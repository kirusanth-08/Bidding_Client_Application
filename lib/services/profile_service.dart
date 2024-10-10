import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';

class ProfileService {
  Future<Map<String, dynamic>> fetchProfileDetails(String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl/api/profile/v1/get-profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load profile details');
    }
  }

  Future<void> cacheProfileDetails(Map<String, dynamic> profile) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profile', json.encode(profile));
  }

  Future<Map<String, dynamic>?> getCachedProfileDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final profileString = prefs.getString('profile');
    if (profileString != null) {
      return json.decode(profileString);
    }
    return null;
  }
}
