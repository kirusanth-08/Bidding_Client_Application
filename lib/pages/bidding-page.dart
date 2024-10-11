import 'dart:math';
import 'dart:convert';
import 'package:bid_bazaar/pages/buy-page.dart';
import 'package:bid_bazaar/pages/payment-page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import 'notification-view.dart';

class BiddingPage extends StatefulWidget {
  final String itemId;
  const BiddingPage({super.key, required this.itemId});

  @override
  State<BiddingPage> createState() => _BiddingPageState();
}

class _BiddingPageState extends State<BiddingPage> {
  // Controllers for each text field
  TextEditingController nameController = TextEditingController();

  late Map<String, dynamic> itemDetails;
  late Map<String, dynamic> timeDetails; // To hold the item details
  late List<dynamic> bidders; // To hold bidder details
  bool isLoading = true; // To manage loading state
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchItemDetails(); // Call the function to fetch item details
  }

  Future<void> _fetchItemDetails() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? userId;
    });

    final response = await http.get(Uri.parse('$apiUrl/api/items/v1/${widget.itemId}'));
    final res = await http.get(Uri.parse('$apiUrl/api/bid/v1/time/${widget.itemId}'));
    final bidderResponse = await http.get(Uri.parse('$apiUrl/api/bid/v1/bids/${widget.itemId}'));

    if (response.statusCode == 200 && res.statusCode == 200) {
      setState(() {
        itemDetails = jsonDecode(response.body);
        timeDetails = jsonDecode(res.body);
        print('User ID $userId'); // Decode the response
        isLoading = false;

        // Handle the bidder response
        if (bidderResponse.statusCode == 200) {
          bidders = jsonDecode(bidderResponse.body);
        } else if (bidderResponse.statusCode == 404) {
          bidders = []; // No bids found
        } else {
          // Handle other status codes as necessary
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load bidder details.'),
            ),
          );
          bidders = []; // Set bidders to empty on error
        }
      });
    } else {
      // Handle error response for item details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load item details.'),
        ),
      );
    }
  }

  Future<void> _loadUsername() async {
    
    
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
          "Bidding",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.notifications,
              color: Colors.white,
              size: 20,
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
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 0, bottom: 10),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 0, bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                itemDetails['name'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 23,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  decorationColor: bgBlack,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
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
                    const Padding(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Bidding ends in"),
                          Text("Price"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${timeDetails['days']} Days : ${timeDetails['hours']} Hours : ${timeDetails['minutes']} Minutes',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              decorationColor: bgBlack,
                            ),
                          ),
                          Text(
                            "Rs. ${itemDetails['price'].toString()}",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              decorationColor: bgBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            "Highest Bids",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              decorationColor: bgBlack,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),

                    // Mapping the bidder list or showing "No Bids found"
                    if (bidders.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "No Bids found",
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      )
                    else
                      Column(
                        children: bidders.map<Widget>((bidder) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.person_3_rounded,
                                      size: 30,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          'LKR ${bidder['bidPrice']}', // Display bid price
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.poppins().fontFamily,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          bidder['userId']['email'], // Display bidder's email
                                          style: const TextStyle(
                                            color: bgBlack,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: bgButton1,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.arrow_circle_up_sharp, // Icon for the highest bid
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        }).toList(),
                      ),

                    const SizedBox(
                      height: 20,
                    ),
                     InkWell(
                      onTap: () {
                        _showEditDialog(context);
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
                            "Place Bid",
                            style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                     ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

    void _showEditDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 350,
          padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Enter your bid',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: bgBlack,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    keyboardType: TextInputType.number, // Ensure the input is numeric
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Bid Price',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Retrieve the bid price from the text field
                      final bidPrice = nameController.text.trim();
                      
                      // Validate the bid price
                      if (bidPrice.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a bid price.')),
                        );
                        return; // Exit if the field is empty
                      }

                      print('User ID $userId'); // Log the userId
                      print('Bid Price $bidPrice'); // Log the bid price
                      print('Item ID ${widget.itemId}'); // Log the itemId

                      // Send the POST request
                      final response = await http.post(
                        Uri.parse('http://192.168.8.100:3000/api/bid/v1/${widget.itemId}'),
                        headers: {
                          'Content-Type': 'application/json',
                        },
                        body: jsonEncode({
                          'userId': userId, // Use the retrieved userId
                          'bidPrice': bidPrice,
                        }),
                      );

                      print('Response ${response.body}'); // Log the response

                      // Handle the response
                      if (response.statusCode == 201) {
                        // Bid submitted successfully
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Bid submitted successfully!')),
                        );
                        // Optionally, refresh the bidders list or close the dialog
                        Navigator.pop(context); // Close the dialog
                        _fetchItemDetails(); // Refresh the item details
                      } else {
                        // Handle errors
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to submit bid.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgAppBar,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: bgWhite,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    },
  );
}
}

