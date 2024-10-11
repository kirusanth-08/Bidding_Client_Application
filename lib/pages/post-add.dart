import 'dart:io';
import 'package:bid_bazaar/pages/payment-page.dart';
import 'package:bid_bazaar/pages/profile-page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart'; // Import the http_parser package
import '../config/config.dart';

class PostAdd extends StatefulWidget {
  const PostAdd({super.key});

  @override
  State<PostAdd> createState() => _PostAddState();
}

class _PostAddState extends State<PostAdd> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController minBidAmountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController locationSearchController =
      TextEditingController();

  // Dropdown values
  String? selectedType;
  List<String> types = ['House', 'Apartment', 'Land'];

  // Radio button values
  String? selectedCondition;
  String? selectedCondition1;

  // Date
  DateTime? selectedDate;

  // File & Image handling
  FilePickerResult? file;
  List<XFile>? selectedImages;

  // Location suggestions
  List<String> allLocations =
      []; // This should be populated with all possible locations
  List<String> filteredLocations = [];

  // Constants for spacing
  static const double fieldSpacing = 16.0;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedLocations = prefs.getString('locations');

    if (cachedLocations != null) {
      // Load locations from cache
      List<dynamic> decodedLocations = jsonDecode(cachedLocations);
      setState(() {
        allLocations = decodedLocations.cast<String>();
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
          allLocations = decodedLocations
              .map((location) => location['name'] as String)
              .toList();
        });

        // Save locations to cache
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('locations', jsonEncode(allLocations));
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  void _filterLocations(String query) {
    setState(() {
      filteredLocations = allLocations
          .where((location) =>
              location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Function to pick date
  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
        dateController.text =
            '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
      });
    }
  }

  // Function to pick a file
  Future<void> _pickFile() async {
    file = await FilePicker.platform.pickFiles();
    setState(() {});
  }

  // Function to pick images
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    setState(() {
      selectedImages = images;
    });
  }

  // Function to submit the form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? userId =
          prefs.getString('userId'); // Retrieve userId from SharedPreferences

      var uri = Uri.parse('$apiUrl/api/items/v1/new');
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['name'] = nameController.text;
      request.fields['description'] = descriptionController.text;
      request.fields['price'] = priceController.text;
      request.fields['location'] = locationSearchController.text;
      request.fields['type'] = selectedType ?? '';
      request.fields['condition'] = selectedCondition1 ?? '';
      request.fields['sellingType'] = selectedCondition ?? '';
      request.fields['startingBid'] = minBidAmountController.text;
      request.fields['bidEndTime'] = dateController.text;
      request.fields['userId'] =
          userId ?? ''; // Add userId to the request fields

      for (var image in selectedImages!) {
        var stream = http.ByteStream(
            DelegatingStream.typed(File(image.path).openRead()));
        var length = await File(image.path).length();
        var multipartFile = http.MultipartFile(
          'images',
          stream,
          length,
          filename: path.basename(image.path),
          contentType:
              MediaType('image', path.extension(image.path).substring(1)),
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Item posted successfully')));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfilePage()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to post item')));
      }
    }
  }

  // Widget for text form field
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }

  // Widget for dropdown form field
  Widget _buildDropdownFormField({
    required String? value,
    required List<String> items,
    required String hintText,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
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
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        title: const Text(
          "POST YOUR AD",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(
                controller: nameController,
                hintText: 'Enter your name',
                validator: (value) => value!.isEmpty ? 'Enter a name' : null,
              ),
              const SizedBox(height: fieldSpacing),
              _buildTextFormField(
                controller: descriptionController,
                hintText: 'Description',
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: fieldSpacing),
              _buildTextFormField(
                controller: priceController,
                hintText: 'Price',
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter a price' : null,
              ),
              const SizedBox(height: fieldSpacing),
              // Location Field with Suggestions
              TextFormField(
                controller: locationSearchController,
                decoration: InputDecoration(
                  hintText: 'Enter location',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  _filterLocations(value);
                },
              ),
              const SizedBox(height: 8.0),
              if (filteredLocations.isNotEmpty)
                Container(
                  height: 100.0,
                  child: ListView.builder(
                    itemCount: filteredLocations.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredLocations[index]),
                        onTap: () {
                          setState(() {
                            locationSearchController.text =
                                filteredLocations[index];
                            filteredLocations.clear();
                          });
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: fieldSpacing),
              _buildDropdownFormField(
                value: selectedType,
                items: types,
                hintText: 'Type',
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
              ),
              const SizedBox(height: fieldSpacing),
              // Radio Buttons for Condition
              Row(
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Buy Now',
                        groupValue: selectedCondition,
                        onChanged: (value) {
                          setState(() {
                            selectedCondition = value;
                          });
                        },
                      ),
                      const Text('Buy Now'),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Bid',
                        groupValue: selectedCondition,
                        onChanged: (value) {
                          setState(() {
                            selectedCondition = value;
                          });
                        },
                      ),
                      const Text('Bid'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: fieldSpacing),
              if (selectedCondition == 'Bid') ...[
                _buildTextFormField(
                  controller: minBidAmountController,
                  hintText: 'Minimum Bid Amount',
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a minimum bid amount' : null,
                ),
                const SizedBox(height: fieldSpacing),
                TextFormField(
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(
                    hintText: 'Set Bid End Date',
                    filled: true,
                    fillColor: Colors.grey[200],
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTap: _pickDate,
                ),
                const SizedBox(height: fieldSpacing),
                const Text('Attach Authenticity document (Optional)'),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.grey[200],
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: _pickFile,
                  child: Text(
                      file == null ? 'Attach File' : file!.files.first.name),
                ),
              ],
              const SizedBox(height: fieldSpacing),
              const Text('Condition:'),
              Row(
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: 'New',
                        groupValue: selectedCondition1,
                        onChanged: (value) {
                          setState(() {
                            selectedCondition1 = value;
                          });
                        },
                      ),
                      const Text('New'),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Used',
                        groupValue: selectedCondition1,
                        onChanged: (value) {
                          setState(() {
                            selectedCondition1 = value;
                          });
                        },
                      ),
                      const Text('Used'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: fieldSpacing),
              const Text('Add Images'),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.grey[200],
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onPressed: _pickImages,
                child: Text(
                  selectedImages == null || selectedImages!.isEmpty
                      ? 'Upload Images'
                      : '${selectedImages!.length} Image(s) Selected',
                ),
              ),
              const SizedBox(height: fieldSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _submitForm();
                      }
                    },
                    child: Container(
                      height: 45,
                      width: 180,
                      decoration: BoxDecoration(
                        color: bgButton,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Post Ad",
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
