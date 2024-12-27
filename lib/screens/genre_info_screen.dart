// import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';

// import 'package:shelfless/dialogs/delete_dialog.dart';
// import 'package:shelfless/models/genre.dart';
// import 'package:shelfless/providers/genres_provider.dart';
// import 'package:shelfless/screens/edit_genre_screen.dart';
// import 'package:shelfless/utils/strings/strings.dart';

// class GenreInfoScreen extends StatelessWidget {
//   static const String routeName = "/genre-info";

//   final Genre genre;

//   const GenreInfoScreen({
//     Key? key,
//     required this.genre,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Fetch provider.
//     final GenresProvider genresProvider = Provider.of(context, listen: true);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           // strings.genreInfo,
//           style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               // Navigate to edit_book_screen.
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => EditGenreScreen(genre: genre),
//                 ),
//               );
//             },
//             icon: const Icon(Icons.edit_rounded),
//           ),
//           IconButton(
//             onPressed: () {
//               // Show dialog asking the user to confirm their choice.
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return DeleteDialog(
//                     title: Text(genre.name),
//                     onConfirm: () => genresProvider.deleteGenre(genre),
//                   );
//                 },
//               );
//             },
//             icon: const Icon(Icons.delete_rounded),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Name.
//               Text(strings.genreInfoName),
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Text(genre.name, style: Theme.of(context).textTheme.displaySmall),
//               ),
//               const SizedBox(
//                 height: 24.0,
//               ),

//               // Color.
//               Text(strings.genreInfoColor),
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15.0),
//                     color: Color(genre.color),
//                   ),
//                   height: 100,
//                   width: double.infinity,
//                 ),
//               ),
//               const SizedBox(
//                 height: 24.0,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
