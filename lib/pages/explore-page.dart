import 'dart:math';
import 'dart:ui';

import 'package:bid_bazaar/config/config.dart';
import 'package:flutter/material.dart';

import '../slider/slider-page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<int> randomNumbers =
      List.generate(15, (index) => Random().nextInt(100));

  // late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    //  _searchController = TextEditingController();
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Icon(
              Icons.menu_outlined,
              color: Colors.white,
            ),
          ),
        ),
        // leadingWidth: 0,
        // automaticallyImplyLeading: false,
        title: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: Container(
              height: 40,
              width: 350,
              child: TextField(
                // controller: _searchController,
                onChanged: (value) {
                  setState(() {}); // Update UI on search query change
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF90A4AE))),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFF90A4AE),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Color(0xFFFFFFFF),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            )),
        // title: Text(
        //   "Home Page",
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontSize: 20,
        //   ),
        // ),
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
                  // elevation: 12,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(
                          color: bgButton1, style: BorderStyle.solid)),
                  // color: Colors.white,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.location_on_outlined),
                            Text(
                              'Melbourne',
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
                Card.outlined(
                  // elevation: 12,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(
                          color: bgButton1, style: BorderStyle.solid)),
                  // color: Colors.white,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.location_on_outlined),
                            Text(
                              'Melbourne',
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
                )
              ],
            ),
          ),

          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: GridView.builder(
                // shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  crossAxisSpacing: 10.0, // Spacing between items horizontally
                  mainAxisSpacing: 10.0, // Spacing between items vertically
                  childAspectRatio: 1.0, // Aspect ratio of each item
                ),
                itemCount: randomNumbers.length,
                itemBuilder: (context, index) {
                  return Card.outlined(
                    // elevation: 12,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(
                            color: bgButton1, style: BorderStyle.solid)),
                    // color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 80,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://picsum.photos/400/200'),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Melbourne Cricket',
                                style: TextStyle(
                                  color: bgBlack,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  "\$99", // Correct static string for displaying dollar amounts
                                  style: TextStyle(
                                    color: bgBlack,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: bgButton,
                                    borderRadius: BorderRadius.circular(9),
                                    // border:
                                    //     Border.all(color: Colors.black, width: 2),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
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
                  );
                },
              ),
            ),
          )
          // ListView.builder(
          //   itemCount: randomNumbers.length,
          //   shrinkWrap:
          //       true, // Ensures the ListView uses only as much height as it needs
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemBuilder: (context, index) {
          //     return Row(
          //       children: [
          //         Expanded(
          //           flex: 1,
          //           child: Container(
          //             height: 90,
          //             width: 100,
          //             margin: const EdgeInsets.all(8.0),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(8.0),
          //               // boxShadow: const [
          //               //   BoxShadow(
          //               //     color: Colors.black12,
          //               //     offset: Offset(0, 2),
          //               //     blurRadius: 4.0,
          //               //   ),
          //               // ],
          //             ),
          //             child: ClipRRect(
          //               borderRadius: BorderRadius.circular(8.0),
          //               child: CachedNetworkImage(
          //                 imageUrl: "",
          //                 fit: BoxFit.cover,
          //                 placeholder: (context, url) => Container(
          //                   child: Image.asset(
          //                     'assets/images/loadingImage.png',
          //                     fit: BoxFit.cover,
          //                   ),
          //                 ),
          //                 errorWidget: (context, url, error) => Container(
          //                   child: Image.asset(
          //                     'assets/images/loadingImage.png',
          //                     fit: BoxFit.cover,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Expanded(
          //           flex: 2,
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               // Html(
          //               //   data: '<div style="color: black;">${favoritePosts[index].title}</div>',
          //               //   style: {
          //               //     '#': Style(
          //               //       fontSize: FontSize(15),
          //               //       fontWeight: FontWeight.bold,
          //               //       maxLines: 3,
          //               //       textOverflow: TextOverflow.ellipsis,
          //               //       fontFamily:
          //               //       GoogleFonts.muktaMalar().fontFamily,
          //               //     ),
          //               //   },
          //               // ),
          //               // Html(
          //               //   data: '<div> hiiii </div>',
          //               //   style: {
          //               //     '#': Style(
          //               //       fontSize: FontSize(14),
          //               //       maxLines: 3,
          //               //       textOverflow: TextOverflow.ellipsis,
          //               //       fontFamily: GoogleFonts.poppins().fontFamily,
          //               //       // fontWeight: FontWeight.bold,
          //               //
          //               //       // padding: HtmlPaddings.symmetric(horizontal: 5,),
          //               //       color: Theme.of(context).colorScheme.primary,
          //               //     ),
          //               //   },
          //               // ),
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.only(left: 8),
          //                     child: Text(
          //                       'formatTimeDifference',
          //                       // formattedDate,
          //                       style: TextStyle(
          //                         color: Theme.of(context)
          //                             .colorScheme
          //                             .onBackground,
          //                       ),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.only(right: 8),
          //                     child: GestureDetector(
          //                       onTap: () {
          //                         // removeFavorite(
          //                         //     favoritePosts[index]);
          //                       },
          //                       child: Image.asset(
          //                         "assets/images/favorite.png",
          //                         width: 22,
          //                         height: 22,
          //                         // color: currentIndex == 3
          //                         //     ? Theme.of(context).colorScheme.onPrimary
          //                         //     : Theme.of(context).colorScheme.onSecondary,
          //                         color:
          //                             Theme.of(context).colorScheme.onPrimary,
          //                       ),
          //                       // child: Icon(
          //                       //     Icons.bookmark,
          //                       //     color: Theme.of(context).colorScheme.primary,
          //                       //   ),
          //                     ),
          //                   ),
          //                 ],
          //               )
          //             ],
          //           ),
          //         ),
          //       ],
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
