import 'package:bid_bazaar/bottombar/bottombar.dart';
import 'package:bid_bazaar/config/config.dart';
import 'package:bid_bazaar/pages/bidding-page.dart';
import 'package:bid_bazaar/pages/explore-page.dart';
import 'package:bid_bazaar/pages/home-page.dart';
import 'package:bid_bazaar/pages/profile-page.dart';
import 'package:flutter/material.dart';

import 'splash-screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: bgAppBar),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Bottom_Appbar(),
        '/explore': (context) => const ExplorePage(),
        '/profile': (context) => const ProfilePage(),
        '/bidding': (context) => const BiddingPage(),
      },
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
