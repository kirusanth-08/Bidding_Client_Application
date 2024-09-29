import 'package:bid_bazaar/config/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

import 'login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passToggle = true;
  bool confirmToggle = true;
  bool checkbox = false;

  // Future<void> _register() async {
  //   if (_formKey.currentState!.validate()) {
  //     // const String apiUrl =
  //     //     'http://192.168.43.3:8000/api/register'; // Replace with your API endpoint
  //     const String apiUrl =
  //         'http://192.168.1.7:8000/api/register'; // Replace with your API endpoint
  //
  //     final response = await http.post(Uri.parse(apiUrl), body: {
  //       'name': nameController.text,
  //       'email': emailController.text,
  //       'password': passwordController.text,
  //     });
  //
  //     if (response.statusCode == 200) {
  //       // Registration successful
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Registration successful. You can now login.'),
  //         ),
  //       );
  //
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //           builder: (context) => LoginPage(),
  //         ),
  //       );
  //     } else if (response.statusCode == 409) {
  //       // Email already in use, show an error message
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content:
  //           Text('Email is already in use. Please use a different email.'),
  //         ),
  //       );
  //     } else {
  //       // Handle other registration errors
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Registration failed. Please try again.'),
  //         ),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgWhite,
        // appBar: AppBar(
        //   backgroundColor: const Color(0xFF0b0f23),
        //   title: Center(
        //       child: Text(
        //     'Sign Up',
        //     style: GoogleFonts.inter(
        //         textStyle: TextStyle(color: Colors.white, fontSize: 20)),
        //   )),
        // ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create Account",
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(color: bgAppBar, fontSize: 35)),
                    ),
                    SizedBox(
                      height: 70,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: bgAppBar), // Default border color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: bgAppBar), // Border color when focused
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color:
                                      bgRed), // Border color when error occurs
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
                    // const SizedBox(height: 25),
                    // Container(
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //     color: Color(0xFFFFFFFF),
                    //     borderRadius: BorderRadius.circular(7),
                    //     boxShadow: [
                    //       BoxShadow(
                    //           color: Color(0x1A000000),
                    //           blurRadius: 4,
                    //           spreadRadius: 0,
                    //           offset: Offset(0, 4))
                    //     ],
                    //   ),
                    //   child: TextFormField(
                    //     controller: nameController,
                    //     keyboardType: TextInputType.emailAddress,
                    //     decoration: InputDecoration(
                    //         labelText: 'User Name',
                    //         labelStyle: GoogleFonts.inter(
                    //             textStyle: TextStyle(
                    //                 fontSize: 15,
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Color(0xFF90A4AE))),
                    //         border: OutlineInputBorder(
                    //           borderSide: BorderSide.none,
                    //         ),
                    //         prefixIcon: Icon(
                    //           Icons.perm_identity_rounded,
                    //           color: bgAppBar,
                    //           size: 20,
                    //         )),
                    //     validator: (value) {
                    //       if (value == null || value.isEmpty) {
                    //         return 'Please enter your nameess.';
                    //       }
                    //       return null; // Return null for no error
                    //     },
                    //   ),
                    // ),
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
                    const SizedBox(height: 20),
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
                        style: TextStyle(backgroundColor: bgAppBar),
                        controller: confirmPasswordController,
                        obscureText: confirmToggle,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
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
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: bgAppBar,
                          ),
                          suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  confirmToggle = !confirmToggle;
                                });
                              },
                              child: Icon(
                                confirmToggle
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: passToggle ? bgButton : bgButton,
                              )),
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
                    const SizedBox(height: 25),
                    // Row(
                    //   // mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Checkbox(
                    //       activeColor: bgAppBar,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(0),
                    //         side: BorderSide(
                    //           color: Color(0xff90A4AE),
                    //           width: 1,
                    //         ), // Optional: Add an outline
                    //       ),
                    //       value: checkbox,
                    //       onChanged: (bool) {
                    //         setState(() {
                    //           checkbox = !checkbox;
                    //         });
                    //       },
                    //     ),
                    //     Text(
                    //       "I agree",
                    //       style: GoogleFonts.inter(
                    //           textStyle: TextStyle(
                    //         color: Color(0xFF1E1E1E),
                    //       )),
                    //     ),
                    //     SizedBox(
                    //       width: 5,
                    //     ),
                    //     Text(
                    //       "terms",
                    //       style: GoogleFonts.inter(
                    //           textStyle: TextStyle(color: Color(0xFFec6400))),
                    //     ),
                    //     SizedBox(
                    //       width: 5,
                    //     ),
                    //     Text(
                    //       "&",
                    //       style: GoogleFonts.inter(
                    //           textStyle: TextStyle(
                    //         color: Color(0xFF1E1E1E),
                    //       )),
                    //     ),
                    //     SizedBox(
                    //       width: 5,
                    //     ),
                    //     Text(
                    //       "Conditions",
                    //       style: GoogleFonts.inter(
                    //           textStyle: TextStyle(color: Color(0xFFec6400))),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        // onPressed: _isLoading ? null : _login,
                        // child: _isLoading
                        //     ? const CircularProgressIndicator()
                        //     : const Text('Login'),
                        // onPressed: _register,
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: bgAppBar,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 20),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Container(
                    //       height: 1,
                    //       width: 120,
                    //       color: const Color(0xFF1E1E1E),
                    //     ),
                    //     // const SizedBox(
                    //     //   width: 20,
                    //     // ),
                    //     GestureDetector(
                    //       child: Text(
                    //         "or Login with",
                    //         style: GoogleFonts.inter(
                    //             textStyle: TextStyle(
                    //           color: Color(0xFF1E1E1E),
                    //         )),
                    //       ),
                    //       onTap: () => {
                    //         // Navigator.of(context).pushReplacement(
                    //         //   MaterialPageRoute(
                    //         //     builder: (context) => AuthPage(),
                    //         //   ),
                    //         // ),
                    //       },
                    //     ),
                    //     // const SizedBox(
                    //     //   width: 20,
                    //     // ),
                    //     Container(
                    //       height: 1,
                    //       width: 120,
                    //       color: const Color(0xFF1E1E1E),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 20),
                    // InkWell(
                    //   onTap: () {
                    //     // onPressed: _isLoading ? null : _login,
                    //     // child: _isLoading
                    //     //     ? const CircularProgressIndicator()
                    //     //     : const Text('Login'),
                    //     // Navigator.of(context).pushReplacement(
                    //     //       //   MaterialPageRoute(
                    //     //       //     builder: (context) => DashboardPage(
                    //     //       //       authToken: data[
                    //     //       //       'token'], // Pass the access token obtained from the login response
                    //     //       //     ),
                    //     //       //   ),
                    //     //       // );
                    //   },
                    //   child: Container(
                    //     height: 45,
                    //     decoration: BoxDecoration(
                    //         color: Color(0xFFFFFFFF),
                    //         borderRadius: BorderRadius.circular(5),
                    //         border: Border.all(width: 2, color: Color(0xFFec6400))),
                    //     child: Center(
                    //       child: Text(
                    //         "Continue With Google",
                    //         style: GoogleFonts.inter(
                    //           textStyle: TextStyle(color: Color(0xFFec6400)),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            "Already have an account?",
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                              color: Color(0xFF1E1E1E),
                            )),
                          ),
                          onTap: () => {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            ),
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          child: Text(
                            "Login In Now",
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(color: bgAppBar),
                            ),
                          ),
                          onTap: () => {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
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
