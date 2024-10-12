import 'dart:math';
import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bid_bazaar/config/config.dart';
import 'package:flutter/material.dart';
import '../slider/slider-page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import './model/location_model.dart';
import './buy-page.dart';
import './bidding-page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<dynamic> items = [];
  List<dynamic> filteredItems = [];
  List<Location> _locations = [];
  List<String> _categories = []; // To hold unique categories
  bool _isLoading = true;
  String? selectedLocation;
  String? selectedLocationName;
  String? selectedCategory; // To hold the selected category
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
      List<dynamic> decodedLocations = jsonDecode(cachedLocations);
      setState(() {
        _locations = _parseLocations(decodedLocations);
        _isLoading = false;
      });
    } else {
      await _fetchLocations();
    }
  }

  Future<void> _fetchLocations() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/locations/v1'));
      if (response.statusCode == 200) {
        List<dynamic> decodedLocations = jsonDecode(response.body)['data'];
        setState(() {
          _locations = _parseLocations(decodedLocations);
          _isLoading = false;
        });

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
      final response = await http.get(Uri.parse('$apiUrl/api/items/v1'));
      if (response.statusCode == 200) {
        setState(() {
          items = jsonDecode(response.body);
          filteredItems = items;

          // Extract unique categories from items
          _categories =
              items.map((item) => item['type'] as String).toSet().toList();
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
        final matchesCategory = selectedCategory == null ||
            item['type'] == selectedCategory; // Category matching
        return matchesQuery && matchesLocation && matchesCategory;
      }).toList();
    });
  }

  void _showCategoryList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _categories.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_categories[index]),
              onTap: () {
                setState(() {
                  selectedCategory = _categories[index];
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

  void _resetFilters() {
    setState(() {
      selectedLocation = null;
      selectedLocationName = null;
      selectedCategory = null;
      filteredItems = items;
      _searchController.clear();
    });
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
                    color: Color(0xFF90A4AE),
                  ),
                ),
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
          ),
        ),
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
                        color: bgButton1, style: BorderStyle.solid),
                  ),
                  child: InkWell(
                    onTap: () =>
                        _showCategoryList(context), // Open category list
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.category_outlined),
                              Text(
                                selectedCategory ?? 'Category',
                                style: TextStyle(
                                  color: bgBlack,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.unfold_more),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _showLocationList(context),
                  highlightColor: Colors.grey.withOpacity(0.2),
                  splashColor: Colors.grey.withOpacity(0.3),
                  child: Card.outlined(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(
                          color: bgButton1, style: BorderStyle.solid),
                    ),
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
                                width: 100,
                                child: Text(
                                  selectedLocationName ?? 'Location',
                                  style: TextStyle(
                                    color: bgBlack,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.unfold_more),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items Found: ${filteredItems.length}',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _resetFilters,
                  child: Text('Reset Filters',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .red, // Changed from 'primary' to 'backgroundColor'
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BuyPage(
                                  itemId: filteredItems[index]
                                      ['_id'], // Use the _id field as itemId
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${apiUrl}/${filteredItems[index]['images'][0]}',
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  filteredItems[index]['name'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Price: \$${filteredItems[index]['price']}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      filteredItems[index]['condition'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
