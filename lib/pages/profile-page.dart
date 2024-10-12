import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';
import 'feedback.dart';
import 'wishlist-page.dart';
import 'post-add.dart';
import '../utils/token_manager.dart'; // Import TokenManager
import '../auth/login_page.dart'; // Import LoginPage for navigation after logout

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? userName; // Use nullable String
  String? userEmail;
  String? userProfile;

  @override
  void initState() {
    super.initState();
    locationController.text = "Pittugala, Malabe, Colombo";
    phoneController.text = "0766235675";

    // Initialize user details (or fetch from API)
    userName = "username";
    userEmail = "";
    userProfile =
        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"; // Example profile URL

    // Load username from SharedPreferences and assign to userName
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? userName;
      userEmail = prefs.getString('userEmail') ?? userEmail;
    });
  }

  Future<void> _logout(BuildContext context) async {
    await TokenManager.removeToken(); // Clear the token
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully!'),
      ),
    );
    // Navigate to the login page or any other appropriate page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPage(), // Replace with your login page
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout(context); // Proceed with logout
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: bgAppBar,
        automaticallyImplyLeading: false,
        title: Text('Profile', style: GoogleFonts.inter(color: bgWhite)),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: bgWhite),
            onPressed: () => _showLogoutConfirmationDialog(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image and User Info
            CircleAvatar(
              radius: 50,
              backgroundImage: userProfile != null && userProfile!.isNotEmpty
                  ? NetworkImage(userProfile!)
                  : const AssetImage("assets/images/profile.png")
                      as ImageProvider,
            ),
            const SizedBox(height: 16),
            Text(userName ?? 'Loading...',
                style: GoogleFonts.inter(
                    fontSize: 24, color: const Color.fromARGB(255, 0, 0, 0))),
            const SizedBox(height: 8),
            Text(userEmail ?? 'Loading...',
                style: GoogleFonts.inter(fontSize: 14, color: bgWhite)),

            // Location and Phone (Inline Editing)
            const SizedBox(height: 32),
            _buildEditableField(
              icon: Icons.location_on,
              label: 'Location',
              controller: locationController,
            ),
            const SizedBox(height: 16),
            _buildEditableField(
              icon: Icons.phone,
              label: 'Phone',
              controller: phoneController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 32),
            // Navigation menu
            _buildMenuItem(context, "My items", Icons.list, const WishList()),
            const SizedBox(height: 16),
            _buildMenuItem(context, "Post Ad", Icons.post_add, const PostAdd()),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Row(
      children: [
        Icon(icon, color: bgAppBar),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData icon, Widget destination) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => destination));
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: bgAppBar,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: bgWhite),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                title,
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontSize: 25,
                    color: bgWhite,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Icon(
                icon,
                color: bgWhite,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
