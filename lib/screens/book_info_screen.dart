// import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';

// import 'package:shelfless/dialogs/delete_dialog.dart';
// import 'package:shelfless/models/author.dart';
// import 'package:shelfless/models/book.dart';
// import 'package:shelfless/models/genre.dart';
// import 'package:shelfless/models/library.dart';
// import 'package:shelfless/providers/books_provider.dart';
// import 'package:shelfless/providers/libraries_provider.dart';
// import 'package:shelfless/screens/edit_book_screen.dart';
// import 'package:shelfless/utils/strings/strings.dart';
// import 'package:shelfless/widgets/author_preview_widget.dart';
// import 'package:shelfless/widgets/genre_preview_widget.dart';

// class BookInfoScreen extends StatelessWidget {
//   static const String routeName = "/book-info";

//   final Book book;

//   const BookInfoScreen({
//     Key? key,
//     required this.book,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Fetch providers.
//     final BooksProvider booksProvider = Provider.of(context, listen: true);
//     final LibrariesProvider librariesProvider = Provider.of(context, listen: true);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           strings.bookInfo,
//           style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white),
//         ),
//         centerTitle: true,
//         actions: [
//           PopupMenuButton(
//             itemBuilder: (BuildContext context) => [
//               PopupMenuItem(
//                 value: 0,
//                 child: Text(strings.bookEdit),
//               ),
//               PopupMenuItem(
//                 value: 1,
//                 child: Text(strings.bookMoveTo),
//               ),
//               PopupMenuItem(
//                 value: 2,
//                 child: Text(strings.bookDelete),
//               ),
//             ],
//             onSelected: (int value) {
//               switch (value) {
//                 case 0:
//                   // Navigate to edit_book_screen.
//                   Navigator.of(context).push(MaterialPageRoute(
//                     builder: (BuildContext context) => EditBookScreen(book: book),
//                   ));
//                   break;
//                 case 2:
//                   // Show dialog asking the user to confirm their choice.
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return DeleteDialog(
//                         title: Text("${strings.deleteBookTitle} ${book.title}"),
//                         content: Text(strings.deleteBookContent),
//                         onConfirm: () {
//                           booksProvider.deleteBook(book);
//                           Navigator.of(context).pop();
//                         },
//                       );
//                     },
//                   );
//                   break;
//                 default:
//                   break;
//               }
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Title.
//               _buildTextInfo(context, strings.bookInfoTitle, book.title),

//               // Library.
//               if (librariesProvider.currentLibrary == null)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(strings.bookInfoLibrary),
//                     Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child:
//                           Text(librariesProvider.libraries.firstWhere((Library library) => library.books.contains(book)).toString(), style: Theme.of(context).textTheme.displaySmall),
//                     ),
//                     const SizedBox(
//                       height: 24.0,
//                     ),
//                   ],
//                 ),

//               // Authors.
//               Text(strings.bookInfoAuthors),
//               if (book.authors.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: book.authors.map((Author author) => AuthorPreviewWidget(author: author)).toList(),
//                   ),
//                 ),
//               const SizedBox(
//                 height: 24.0,
//               ),

//               // Publish date.
//               _buildTextInfo(context, strings.bookInfoPublishDate, book.publishYear.toString()),

//               // Genres.
//               Text(strings.bookInfoGenres),
//               if (book.genres.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: book.genres.map((Genre genre) => GenrePreviewWidget(genre: genre)).toList(),
//                   ),
//                 ),
//               const SizedBox(
//                 height: 24.0,
//               ),

//               // Publisher.
//               if (book.publisher != null) _buildTextInfo(context, strings.bookInfoPublisher, book.publisher!.toString()),

//               // Location.
//               if (book.location != null) _buildTextInfo(context, strings.bookInfoLocation, book.location!.toString()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextInfo(BuildContext context, String title, String content) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title),
//         Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Text(content, style: Theme.of(context).textTheme.titleLarge),
//         ),
//         const SizedBox(
//           height: 24.0,
//         ),
//       ],
//     );
//   }
// }
