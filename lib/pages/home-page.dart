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
      setState(() {
        items = jsonDecode(response.body);
      });
    } else {
      // Handle error response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load items.'),
        ),
      );
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
                        S.of(context).gm,
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
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(
                            color: bgButton1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BiddingPage(),
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
                                        image: NetworkImage(item['images'][0]),
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
                                        "\$${item['price']}",
                                        style: const TextStyle(
                                          color: bgBlack,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "ends in ${item['bidEndTime']}",
                                            style: const TextStyle(
                                              height: 0,
                                              color: bgAppBar,
                                              fontSize: 10,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: bgButton,
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                            ),
                                            child: const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(2.0),
                                                child: Text(
                                                  "Place Bid",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
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
                                  builder: (context) => const BuyPage(),
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
                                        image: NetworkImage(item['images'][0]),
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
                                        "\$${item['price']}",
                                        style: const TextStyle(
                                          color: bgBlack,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: bgButton,
                                          borderRadius:
                                              BorderRadius.circular(9),
                                        ),
                                        child: const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              "View",
                                              style: TextStyle(
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
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
