// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../pages/provider/localization_provider.dart'; // Import your localization provider

// class LanguageSelectionPage extends StatelessWidget {
//   const LanguageSelectionPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final List<LanguageModel> languageModel = [
//       LanguageModel('English', 'en', 'EN'),
//       LanguageModel('Spanish', 'es', 'ES'),
//       LanguageModel('French', 'fr', 'FR'),
//       // Add more languages as needed
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select Language'),
//         centerTitle: true,
//       ),
//       body: ListView.builder(
//         itemCount: languageModel.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(
//                 '${languageModel[index].language} (${languageModel[index].subLanguage})'),
//             onTap: () {
//               // Change locale on tap
//               Provider.of<LocalizationProvider>(context, listen: false)
//                   .setLocale(Locale(languageModel[index].languageCode));
//               Navigator.pop(context); // Go back after selection
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// // Language model class
// class LanguageModel {
//   final String language;
//   final String languageCode;
//   final String subLanguage;

//   LanguageModel(this.language, this.languageCode, this.subLanguage);
// }
