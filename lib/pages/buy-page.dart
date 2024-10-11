import 'dart:convert'; // For jsonDecode
import 'package:bid_bazaar/pages/feedback.dart';
import 'package:bid_bazaar/pages/notification-page.dart';
import 'package:bid_bazaar/pages/payment-page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import '../config/config.dart';

class BuyPage extends StatefulWidget {
  final String itemId; // Add this line

  const BuyPage({super.key, required this.itemId}); // Modify constructor

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  late Map<String, dynamic> itemDetails; // To hold the item details
  bool isLoading = true; // To manage loading state

  @override
  void initState() {
    super.initState();
    _fetchItemDetails(); // Call the function to fetch item details
  }

  Future<void> _fetchItemDetails() async {
    final response = await http.get(Uri.parse('http://192.168.8.100:3000/api/items/v1/${widget.itemId}'));

    if (response.statusCode == 200) {
      setState(() {
        itemDetails = jsonDecode(response.body); // Decode the response
        isLoading = false; // Set loading to false
      });
    } else {
      // Handle error response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load item details.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator()); // Show loading indicator
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgAppBar,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        title: const Text(
          "Buy Now",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationPage()));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('$apiUrl/' + itemDetails['images'][0]), // Use the fetched image URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        itemDetails['name'], // Display item name
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 23,
                        ),
                      ),
                      Text(
                        "by ${itemDetails['userId']['email']}", // Display vendor name
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(itemDetails['description']), // Display item description
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Align(
                      alignment: Alignment.centerLeft, // Aligns the text to the left
                      child: Text(
                        'Price: Rs.${itemDetails['price'].toString()}', // Convert int to String
                        style: TextStyle(
                          fontSize: 23, // Increase the font size
                          fontWeight: FontWeight.bold, // Make the text bold
                          color: Colors.black, // Optional: Set text color
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Space before the new fields
                  
                  // Display location
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Location: ${itemDetails['location']['name']}', // Display location name
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Space between location and type
                  
                  // Display type
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Type: ${itemDetails['type']}', // Display item type
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Space between type and condition
                  
                  // Display condition
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Condition: ${itemDetails['condition']}', // Display item condition
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Add space before the payment buttons
                  
                  Center(
                    child: InkWell(
                      onTap: () {
                        // Handle payment action here
                      },
                      child: Container(
                        height: 55,
                        width: 200,
                        decoration: BoxDecoration(
                          color: bgAppBar,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "Pay & Pick",
                            style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Space between "Pay & Pick" and PayPal button
                  
                  Center(
                    child: InkWell(
                      onTap: () {
                        // Handle PayPal action here
                      },
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: bgWhite,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: bgButton),
                        ),
                        child: Image.asset(
                          "assets/images/paypal2.png",
                          height: 50,
                          width: 200,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
