import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfish/dialogs/delete_dialog.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/models/library.dart';
import 'package:shelfish/providers/books_provider.dart';
import 'package:shelfish/providers/libraries_provider.dart';
import 'package:shelfish/screens/edit_book_screen.dart';
import 'package:shelfish/utils/strings/strings.dart';
import 'package:shelfish/widgets/author_preview_widget.dart';
import 'package:shelfish/widgets/genre_preview_widget.dart';

class BookInfoScreen extends StatefulWidget {
  static const String routeName = "/book-info";

  const BookInfoScreen({Key? key}) : super(key: key);

  @override
  State<BookInfoScreen> createState() => _BookInfoScreenState();
}

class _BookInfoScreenState extends State<BookInfoScreen> {
  @override
  Widget build(BuildContext context) {
    // Fetch providers.
    final BooksProvider booksProvider = Provider.of(context, listen: true);
    final LibrariesProvider librariesProvider = Provider.of(context, listen: true);

    // Fetch book.
    Book book = ModalRoute.of(context)!.settings.arguments as Book;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.bookInfo,
          style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 0,
                child: Text(strings.bookEdit),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(strings.bookMoveTo),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(strings.bookDelete),
              ),
            ],
            onSelected: (int value) {
              switch (value) {
                case 0:
                  // Navigate to edit_book_screen.
                  Navigator.of(context).pushNamed(EditBookScreen.routeName, arguments: book);
                  break;
                case 2:
                  // Show dialog asking the user to confirm their choice.
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteDialog(
                        title: Text("${strings.deleteBookTitle} ${book.title}"),
                        content: Text(strings.deleteBookContent),
                        onConfirm: () {
                          booksProvider.deleteBook(book);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                  break;
                default:
                  break;
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title.
              _buildTextInfo(strings.bookInfoTitle, book.title),

              // Library.
              if (librariesProvider.currentLibrary == null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(strings.bookInfoLibrary),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child:
                          Text(librariesProvider.libraries.firstWhere((Library library) => library.books.contains(book)).toString(), style: Theme.of(context).textTheme.headline6),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                  ],
                ),

              // Authors.
              Text(strings.bookInfoAuthors),
              if (book.authors.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: book.authors.map((Author author) => AuthorPreviewWidget(author: author)).toList(),
                  ),
                ),
              const SizedBox(
                height: 24.0,
              ),

              // Publish date.
              _buildTextInfo(strings.bookInfoPublishDate, book.publishDate.toString()),

              // Genres.
              Text(strings.bookInfoGenres),
              if (book.genres.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: book.genres.map((Genre genre) => GenrePreviewWidget(genre: genre)).toList(),
                  ),
                ),
              const SizedBox(
                height: 24.0,
              ),

              // Publisher.
              if (book.publisher != null) _buildTextInfo(strings.bookInfoPublisher, book.publisher!.toString()),

              // Location.
              if (book.location != null) _buildTextInfo(strings.bookInfoLocation, book.location!.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInfo(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(content, style: Theme.of(context).textTheme.headline6),
        ),
        const SizedBox(
          height: 24.0,
        ),
      ],
    );
  }
}
