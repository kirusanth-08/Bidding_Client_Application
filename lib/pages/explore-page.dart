import 'dart:math';
import 'dart:ui';
import 'dart:convert'; // Add this import for JSON decoding
import 'package:http/http.dart' as http; // Add this import for HTTP requests
import 'package:shared_preferences/shared_preferences.dart'; // Add this import for SharedPreferences

import 'package:bid_bazaar/config/config.dart';
import 'package:flutter/material.dart';

import '../slider/slider-page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import './model/location_model.dart'; // Ensure this import is correct
import './buy-page.dart'; // Import BuyPage
import './bidding-page.dart'; // Import BiddingPage

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<dynamic> items = [];
  List<dynamic> filteredItems = [];
  List<Location> _locations = [];
  bool _isLoading = true;
  String? selectedLocation;
  String? selectedLocationName;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocations();
    _fetchItems();
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedLocations = prefs.getString('locations');

    if (cachedLocations != null) {
      // Load locations from cache
      List<dynamic> decodedLocations = jsonDecode(cachedLocations);
      setState(() {
        _locations = _parseLocations(decodedLocations);
        _isLoading = false;
      });
    } else {
      // Fetch locations from server
      await _fetchLocations();
    }
  }

  Future<void> _fetchLocations() async {
    try {
      final response = await http.get(
          Uri.parse('$apiUrl/api/locations/v1')); // Replace with your API URL
      if (response.statusCode == 200) {
        List<dynamic> decodedLocations = jsonDecode(response.body)['data'];
        setState(() {
          _locations = _parseLocations(decodedLocations);
          _isLoading = false;
        });

        // Save locations to cache
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('locations', jsonEncode(decodedLocations));
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (e) {
      print('Error fetching locations: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Location> _parseLocations(List<dynamic> data) {
    List<Location> locations = [];
    for (var province in data) {
      for (var district in province['districts']) {
        for (var subLocation in district['subLocations']) {
          locations.add(Location.fromJson(subLocation));
        }
        locations.add(Location.fromJson(district));
      }
      locations.add(Location.fromJson(province));
    }
    return locations;
  }

  Future<void> _fetchItems() async {
    try {
      final response = await http
          .get(Uri.parse('$apiUrl/api/items/v1')); // Replace with your API URL
      if (response.statusCode == 200) {
        setState(() {
          items = jsonDecode(response.body);
          filteredItems = items;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      print('Error fetching items: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredItems = items.where((item) {
        final itemName = item['name'].toLowerCase();
        final itemLocation = item['location'];
        final matchesQuery = itemName.contains(query);
        final matchesLocation =
            selectedLocation == null || itemLocation == selectedLocation;
        return matchesQuery && matchesLocation;
      }).toList();
    });
  }

  void _showLocationList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _locations.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_locations[index].name),
              onTap: () {
                setState(() {
                  selectedLocation = _locations[index].id;
                  selectedLocationName = _locations[index].name;
                });
                _filterItems();
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Icons.menu_outlined,
              color: Colors.white,
            ),
          ),
        ),
        title: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: SizedBox(
              height: 40,
              width: 350,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: GoogleFonts.inter(
                      textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF90A4AE))),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF90A4AE),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: const Color(0xFFFFFFFF),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            )),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.edit,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card.outlined(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(
                          color: bgButton1, style: BorderStyle.solid)),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.category_outlined),
                            Text(
                              'Category',
                              style: TextStyle(
                                color: bgBlack,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.unfold_more),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _showLocationList(
                      context), // Function to show the location list
                  highlightColor: Colors.grey.withOpacity(0.2),
                  splashColor: Colors.grey.withOpacity(0.3),
                  child: Card.outlined(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(
                            color: bgButton1, style: BorderStyle.solid)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.location_on_outlined),
                              SizedBox(
                                width: 100, // Fixed width for the location name
                                child: Text(
                                  selectedLocationName ?? 'Location',
                                  style: TextStyle(
                                    color: bgBlack,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.unfold_more),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  crossAxisSpacing: 10.0, // Spacing between items horizontally
                  mainAxisSpacing: 10.0, // Spacing between items vertically
                  childAspectRatio: 0.75, // Aspect ratio of each item
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  final imageUrl = item['images'][0].replaceAll('\\', '/');
                  return Card.outlined(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(
                            color: bgButton1, style: BorderStyle.solid)),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                item['sellingType'] == 'Buy Now'
                                    ? BuyPage(itemId: item['_id'])
                                          : BiddingPage(itemId: item['_id']),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: '$apiUrl/$imageUrl',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                item['name'],
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Rs. ${item['price']}',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
