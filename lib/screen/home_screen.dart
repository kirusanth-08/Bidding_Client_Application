// import 'package:flutter/material.dart';
//
// import '../generated/l10n.dart';
// import '../pages/language_screen.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           S.current.name,
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return const LanguageScreen();
//                 }));
//               },
//               icon: const Icon(Icons.language)),
//         ],
//       ),
//       body: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               S.current.hello_world,
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//             Text(
//               S.current.example_text,
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             Text(
//               S.current.world_text,
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             Text(
//               S.current.gm,
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../pages/language_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.name,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LanguageScreen();
                }));
              },
              icon: const Icon(Icons.language)),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.hello_world,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              S.current.example_text,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              S.current.world_text,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
