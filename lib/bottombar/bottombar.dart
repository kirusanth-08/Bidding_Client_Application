import 'package:bid_bazaar/config/config.dart';
import 'package:bid_bazaar/pages/home-page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../drawer/drawer.dart';
import '../pages/explore-page.dart';
import '../pages/profile-page.dart';

class Bottom_Appbar extends StatefulWidget {
  const Bottom_Appbar({super.key});

  @override
  State<Bottom_Appbar> createState() => _Bottom_AppbarState();
}

class _Bottom_AppbarState extends State<Bottom_Appbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // const HomePage(),
    const HomePage(),
    const ExplorePage(),
    const HomePage(),
    const ProfilePage(),
  ];

  final List<String> _pageTitles = [
    'sign language',
    'sign language',
    'sign language',
    'sign language',
    'sign language',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar? selectedAppBar;
    if (_selectedIndex == 0) {
      // AppBar for index 0
      selectedAppBar = AppBar(
        scrolledUnderElevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.grid_view_rounded,
                size: 35,
                color: Color(0xFF0E75C0),
              ), // replace with your custom icon
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text("Who we are?",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              // color: Colors.black,
              color: Color(0xFF051E54),
              fontFamily: GoogleFonts.poppins().fontFamily,
            )),
        centerTitle: true,
      );
    } else {
      // AppBar for other indices
      selectedAppBar = AppBar(
        scrolledUnderElevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.grid_view_rounded,
                size: 35,
                color: Color(0xFF0E75C0),
              ), // replace with your custom icon
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Container(
          height: 150,
          width: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/logo-vithu.png"))),
        ),
        centerTitle: true,
      );
    }

    return Scaffold(
      // appBar: selectedAppBar,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          // canvasColor: const Color(0xFF0D0D0E),
          canvasColor: bgBottomNavBar,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 25,
          selectedItemColor: bgBlack,
          unselectedItemColor: bgWhite,
          currentIndex: _selectedIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.shop_2),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
          onTap: _onItemTapped,
        ),
      ),
      drawer: Drawer_Page(),
    );
  }
}
