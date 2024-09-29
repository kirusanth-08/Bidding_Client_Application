import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bottombar/bottombar.dart';
import '../config/config.dart';
import '../model/login_data.dart';
import '../pages/home-page.dart';
import 'signup_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passToggle = true;
  bool passToggle1 = true;
  bool passToggle2 = true;
  late SharedPreferences prefs;

  bool checkbox = true;
  bool _isLoading = false;
  bool _isLoading1 = false;
  bool isFirstTimeEnabled = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String? authToken = prefs.getString('token');
    int? eventId = prefs.getInt('selected_event_id');

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(login),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      print('API Response: ${response.body}');
      print('API Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('token') && data['token'] != null) {
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', data['token']);
        }

        if (data.containsKey('message') && data['message'] != null) {
          String message = data['message'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
        }
        if (data['token'] != null && eventId != null) {
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => HomePage(
          //       authToken: data['token'],
          //     ),
          //   ),
          // );
        } else if (data['token'] != null && eventId == null) {
          Future.delayed(Duration(seconds: 2));
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => EventsList()),
          // );
        } else {
          // Show new password and confirm password fields
          setState(() {
            isFirstTimeEnabled = true;
          });
        }
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);
        String message = data['message'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please check your mail or password'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<void> _login1() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }
  //   String? authToken = prefs.getString('token');
  //   int? eventId = prefs.getInt('selected_event_id');
  //
  //   setState(() {
  //     _isLoading1 = true;
  //   });
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(login),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(
  //         LoginData(
  //           email: emailController.text,
  //           password: passwordController.text,
  //           isFirstTimeEnabled: true,
  //           newPassword: newPasswordController.text,
  //           confirmPassword: confirmPasswordController.text,
  //         ).toJson(),
  //       ),
  //     );
  //
  //     print('API Response: ${response.body}');
  //     print('API Response Status Code: ${response.statusCode}');
  //
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> data = jsonDecode(response.body);
  //
  //       if (data.containsKey('token') && data['token'] != null) {
  //         prefs.setString('token', data['token']);
  //       }
  //
  //       if (data['token'] != null && eventId != null) {
  //         Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(
  //             builder: (context) => HomePage(
  //               authToken: data['token'],
  //             ),
  //           ),
  //         );
  //       } else if (data['token'] != null && eventId == null) {
  //         Future.delayed(Duration(seconds: 2));
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => EventsList()),
  //         );
  //       }
  //     } else {
  //       Map<String, dynamic> data = jsonDecode(response.body);
  //       String message = data['message'] ?? 'An error occurred';
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(message),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error occurred: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please check your email or password.'),
  //       ),
  //     );
  //   } finally {
  //     setState(() {
  //       _isLoading1 = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgWhite,
        // appBar: AppBar(
        //   backgroundColor: const Color(0xFF0b0f23),
        //   title: Center(
        //     child: Text(
        //       'Log In',
        //       style: GoogleFonts.inter(
        //           textStyle: const TextStyle(color: Colors.white, fontSize: 20)),
        //     ),
        //   ),
        // ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Login Here",
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(color: bgAppBar, fontSize: 35,fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Welcome back you've been missed",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        
                          textStyle: TextStyle(color: bgBlack, fontSize: 28,fontWeight: FontWeight.w500,)),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: bgInput,
                        borderRadius: BorderRadius.circular(7),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: Offset(0, 4))
                        ],
                      ),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: bgButton1)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: bgAppBar), // Default border color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: bgAppBar), // Border color when focused
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: bgRed), // Border color when error occurs
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: bgAppBar,
                              size: 20,
                            )),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please enter your email.';
                        //   }
                        //   return null;
                        // },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address.';
                          }
                          final emailRegExp = RegExp(
                            r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
                            caseSensitive: false,
                            multiLine: false,
                          );
                          if (!emailRegExp.hasMatch(value)) {
                            return 'Please enter a valid email address.';
                          }
                          return null; // Return null for no error
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: bgInput,
                        borderRadius: BorderRadius.circular(7),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: Offset(0, 4))
                        ],
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: passToggle,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: bgButton1)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: bgAppBar), // Default border color
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: bgAppBar), // Border color when focused
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: bgRed), // Border color when error occurs
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            color: bgAppBar,
                            size: 20,
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                passToggle = !passToggle;
                              });
                            },
                            child: Icon(
                              passToggle
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: passToggle ? bgButton : bgButton,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password.';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long.';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                       
                        
                        Text(
                          "Forgot your password?",
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(color: bgAppBar)),
                        ),
                      ],
                    ),
                    // if (isFirstTimeEnabled) const SizedBox(height: 25),
                    // // New Password and Confirm Password Fields
                    // if (isFirstTimeEnabled)
                    //   Container(
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //       color: Color(0xFFFFFFFF),
                    //       borderRadius: BorderRadius.circular(7),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Color(0x1A000000),
                    //           blurRadius: 4,
                    //           spreadRadius: 0,
                    //           offset: Offset(0, 4),
                    //         )
                    //       ],
                    //     ),
                    //     child: TextFormField(
                    //       controller: newPasswordController,
                    //       obscureText: true,
                    //       decoration: InputDecoration(
                    //         labelText: 'New Password',
                    //         labelStyle: GoogleFonts.inter(
                    //           textStyle: TextStyle(
                    //             fontSize: 15,
                    //             fontWeight: FontWeight.bold,
                    //             color: Color(0xFF90A4AE),
                    //           ),
                    //         ),
                    //         border: OutlineInputBorder(
                    //           borderSide: BorderSide.none,
                    //         ),
                    //         prefixIcon: Icon(
                    //           Icons.lock_outline_rounded,
                    //           color: Color(0xFFec6400),
                    //           size: 20,
                    //         ),
                    //       ),
                    //       validator: (value) {
                    //         if (value == null || value.isEmpty) {
                    //           return 'Please enter a new password.';
                    //         }
                    //         if (value.length < 6) {
                    //           return 'Password must be at least 6 characters long.';
                    //         }
                    //         return null;
                    //       },
                    //     ),
                    //   ),
                    // if (isFirstTimeEnabled) const SizedBox(height: 25),
                    // if (isFirstTimeEnabled)
                    //   Container(
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //       color: Color(0xFFFFFFFF),
                    //       borderRadius: BorderRadius.circular(7),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Color(0x1A000000),
                    //           blurRadius: 4,
                    //           spreadRadius: 0,
                    //           offset: Offset(0, 4),
                    //         )
                    //       ],
                    //     ),
                    //     child: TextFormField(
                    //       controller: confirmPasswordController,
                    //       obscureText: true,
                    //       decoration: InputDecoration(
                    //         labelText: 'Confirm Password',
                    //         labelStyle: GoogleFonts.inter(
                    //           textStyle: TextStyle(
                    //             fontSize: 15,
                    //             fontWeight: FontWeight.bold,
                    //             color: Color(0xFF90A4AE),
                    //           ),
                    //         ),
                    //         border: OutlineInputBorder(
                    //           borderSide: BorderSide.none,
                    //         ),
                    //         prefixIcon: Icon(
                    //           Icons.lock_outline_rounded,
                    //           color: Color(0xFFec6400),
                    //           size: 20,
                    //         ),
                    //       ),
                    //       validator: (value) {
                    //         if (value == null || value.isEmpty) {
                    //           return 'Please confirm your password.';
                    //         }
                    //         if (value != newPasswordController.text) {
                    //           return 'Passwords do not match.';
                    //         }
                    //         return null;
                    //       },
                    //     ),
                    //   ),
                    const SizedBox(height: 30),
                    // isFirstTimeEnabled
                    //     ? InkWell(
                    //         onTap: _isLoading1 ? null : _login1,
                    //         child: Container(
                    //           height: 45,
                    //           width: double.infinity,
                    //           decoration: BoxDecoration(
                    //             color: Color(0xFFec6400),
                    //             borderRadius: BorderRadius.circular(5),
                    //           ),
                    //           child: _isLoading1
                    //               ? Center(
                    //                   child: Padding(
                    //                   padding: const EdgeInsets.all(10.0),
                    //                   child: CircularProgressIndicator(
                    //                     color: Color(0xFF0b0f23),
                    //                   ),
                    //                 ))
                    //               : Center(
                    //                   child: Text(
                    //                     "Log In",
                    //                     style: GoogleFonts.inter(
                    //                         textStyle: TextStyle(
                    //                             color: Color(0xFFFFFFFF))),
                    //                   ),
                    //                 ),
                    //         ),
                    //       )
                    //     :
                    InkWell(
                      // onTap: _isLoading ? null : _login,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Bottom_Appbar()));
                      },
                      child: Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: bgButton,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: _isLoading
                            ? Center(
                                child: Container(
                                height: 35,
                                width: 35,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF0b0f23),
                                ),
                              ))
                            : Center(
                                child: Text(
                                  "Log In",
                                  style: GoogleFonts.inter(
                                      textStyle:
                                          TextStyle(color: Color(0xFFFFFFFF))),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            "Create new account?",
                            style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                              color: Color(0xFF1E1E1E),
                            )),
                          ),
                          onTap: () => {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ),
                            ),
                          },
                        ),
                       ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
