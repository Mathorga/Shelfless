// import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';

// import 'package:shelfless/models/author.dart';
// import 'package:shelfless/models/book.dart';
// import 'package:shelfless/providers/authors_provider.dart';
// import 'package:shelfless/providers/libraries_provider.dart';
// import 'package:shelfless/screens/author_info_screen.dart';
// import 'package:shelfless/screens/books_screen.dart';
// import 'package:shelfless/screens/edit_author_screen.dart';
// import 'package:shelfless/utils/constants.dart';
// import 'package:shelfless/utils/strings/strings.dart';
// import 'package:shelfless/widgets/author_preview_widget.dart';

// class AuthorsOverviewWidget extends StatelessWidget {
//   final String searchValue;

//   const AuthorsOverviewWidget({
//     Key? key,
//     this.searchValue = "",
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final AuthorsProvider authorsProvider = Provider.of(context, listen: true);
//     final LibrariesProvider librariesProvider = Provider.of(context, listen: true);

//     final List<Author> authors = authorsProvider.authors.where((Author author) => author.toString().toLowerCase().contains(searchValue.toLowerCase())).toList();

//     return Scaffold(
//         backgroundColor: Colors.transparent,
//         body: authors.isEmpty
//             ? Center(
//                 child: Text(strings.noAuthorsFound),
//               )
//             : GridView.count(
//                 physics: const BouncingScrollPhysics(),
//                 padding: const EdgeInsets.all(12.0),
//                 crossAxisCount: 2,
//                 children: [
//                   ...List.generate(
//                     authors.length,
//                     (int index) => Stack(
//                       children: [
//                         SizedBox(
//                           height: double.infinity,
//                           child: AuthorPreviewWidget(
//                             author: authors[index],
//                             onTap: () {
//                               if (librariesProvider.currentLibrary == null) {
//                                 return;
//                               }

//                               if (!librariesProvider.currentLibrary!.books.any((Book book) => book.authors.contains(authors[index]))) {
//                                 return;
//                               }

//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (BuildContext context) => BooksScreen(
//                                     authors: {authors[index]},
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.topRight,
//                           child: IconButton(
//                             onPressed: () {
//                               // Edit the selected author.
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (BuildContext context) => AuthorInfoScreen(author: authors[index]),
//                                 ),
//                               );
//                             },
//                             icon: const Icon(Icons.settings_rounded),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: fabAccessHeight),
//                 ],
//               ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (BuildContext context) => const EditAuthorScreen(),
//               ),
//             );
//           },
//           child: const Icon(Icons.add_rounded),
//         ));
//   }
// }
