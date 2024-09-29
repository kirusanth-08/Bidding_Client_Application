import 'package:bid_bazaar/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/login_page.dart';
import '../auth/signup_page.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../LoginRegister/login_page.dart';
// import '../Pages/events.dart';
// import '../Pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  // final String? authToken;
  // const SplashScreen({super.key, this.authToken});
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  void navigateToNextScreen() {
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => (MyHomePage(title: "hii"))),
    // );

    Future.delayed(const Duration(seconds: 8)).then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => SignupPage(),
      ));
    });
    // SharedPreferences.getInstance().then((prefs) {
    //   String? authToken = prefs.getString('token');
    //   int? eventId = prefs.getInt('selected_event_id');
    //
    //   if (authToken != null &&
    //       !JwtDecoder.isExpired(authToken) &&
    //       eventId != null) {
    //     Future.delayed(const Duration(seconds: 1)).then((value) {
    //       Navigator.of(context).pushReplacement(MaterialPageRoute(
    //         builder: (ctx) => HomePage(authToken: authToken!),
    //       ));
    //     });
    //   } else if (authToken != null && eventId == null) {
    //     Future.delayed(Duration(seconds: 1));
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => EventsList()),
    //     );
    //   } else {
    //     Navigator.of(context).pushReplacement(MaterialPageRoute(
    //       builder: (ctx) => LoginPage(),
    //     ));
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: bgAppBar,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   "assets/images/profile.png",
            //   width: 300,
            // ),
            Text(
              "BidBazaar",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: bgWhite,
                  fontFamily: GoogleFonts.poppins().fontFamily),
            ),
            SizedBox(
              height: 50,
            ),
            const SpinKitFadingCircle(
              color: bgWhite,
              size: 50.0,
            ),
          ],
        ));
  }
}
