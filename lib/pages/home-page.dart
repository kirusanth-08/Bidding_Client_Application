import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bid_bazaar/config/config.dart';
import 'package:bid_bazaar/pages/bidding-page.dart';
import 'package:bid_bazaar/pages/buy-page.dart';
import 'package:bid_bazaar/pages/notification-page.dart';
import 'package:bid_bazaar/pages/provider/localization_provider.dart';
import '../generated/l10n.dart';
import 'language_screen.dart';
import '../slider/slider-page.dart';
import 'model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
  final response = await http.get(Uri.parse('$apiUrl/api/items/v1'));

  if (response.statusCode == 200) {
    final allItems = jsonDecode(response.body);

    // Filter out sold items
    setState(() {
      items = allItems.where((item) => item['sold'] == false).toList();
    });
    print(items);
  } else {
    // Handle error response
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to load items.'),
      ),
    );
  }
}


  String _getGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return S.of(context).gm; // Good morning
    } else if (hour < 17) {
      return S.of(context).ga; // Good afternoon
    } else {
      return S.of(context).ge; // Good evening
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, child) {
        var selectedValue = localizationProvider.locale.languageCode;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: bgAppBar,
            automaticallyImplyLeading: false,
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationPage(),
                    ),
                  );
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
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.language,
                  color: Colors.white,
                  size: 30,
                ),
                onSelected: (String newValue) {
                  localizationProvider.setLocale(Locale(newValue));
                },
                itemBuilder: (BuildContext context) {
                  return languageModel.map((item) {
                    return PopupMenuItem<String>(
                      value: item.languageCode,
                      child: Text('${item.language} (${item.subLanguage})'),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 15),
                      child: Text(
                        _getGreetingMessage(),
                        textAlign: TextAlign.start,
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            color: bgBlack,
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Carousel(),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10, top: 10),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card.outlined(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                            color: bgButton1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: 80,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            '$apiUrl/' + item['images'][0]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['name'],
                                        style: const TextStyle(
                                          color: bgBlack,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Rs${item['price']}",
                                        style: const TextStyle(
                                          color: bgBlack,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            5), // Optional spacing between the text and the button
                                    Flexible(
                                      child: Container(
                                        width:
                                            80, // Set a desired fixed width for the button
                                        decoration: BoxDecoration(
                                          color: bgButton,
                                          borderRadius:
                                              BorderRadius.circular(9),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              item['sellingType'] == 'Buy Now'
                                                  ? 'View'
                                                  : 'Bid',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300,
                                              ),
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
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
