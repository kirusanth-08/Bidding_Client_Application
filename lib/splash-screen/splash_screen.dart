import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/config.dart';
import '../bottombar/bottombar.dart'; // Import Bottom_Appbar
import '../auth/login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('$apiUrl/api/users/v1/validate-token'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['valid']) {
            // Navigate to Bottom_Appbar if token is valid
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Bottom_Appbar()),
            );
          } else {
            // Clear the token if it is invalid or expired
            await prefs.remove('token');
            // Navigate to LoginPage if token is invalid or expired
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        } else {
          // Clear the token if token validation fails
          await prefs.remove('token');
          // Navigate to LoginPage if token validation fails
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Failed to connect to the server. Please try again.';
        });

        // Retry after a delay
        Future.delayed(Duration(seconds: 5), () {
          setState(() {
            errorMessage = null;
          });
          _checkToken();
        });
      }
    } else {
      // Navigate to LoginPage if token does not exist
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: errorMessage == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _checkToken,
                    child: Text('Retry'),
                  ),
                ],
              ),
      ),
    );
  }
}
