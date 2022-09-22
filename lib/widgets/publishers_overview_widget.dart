import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/publisher.dart';
import 'package:shelfish/providers/libraries_provider.dart';
import 'package:shelfish/providers/publishers_provider.dart';
import 'package:shelfish/screens/author_info_screen.dart';
import 'package:shelfish/screens/books_screen.dart';
import 'package:shelfish/screens/edit_author_screen.dart';
import 'package:shelfish/utils/constants.dart';
import 'package:shelfish/widgets/author_preview_widget.dart';
import 'package:shelfish/widgets/publisher_preview_widget.dart';

class PublishersOverviewWidget extends StatelessWidget {
  static const String routeName = "/authors_overview";

  final String searchValue;

  const PublishersOverviewWidget({
    Key? key,
    this.searchValue = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PublishersProvider publishersProvider = Provider.of(context, listen: true);
    final LibrariesProvider librariesProvider = Provider.of(context, listen: true);

    // Fetch all relevant authors based on the currently viewed library. All if no specific library is selected.
    final List<Publisher> unfilteredPublishers = librariesProvider.currentLibrary != null
        ? librariesProvider.currentLibrary!.books
            .where((Book book) => book.publisher != null)
            .map<Publisher>((Book book) => book.publisher!)
            .fold(<Publisher>[], (List<Publisher> result, Publisher element) => result..add(element))
            .toSet()
            .toList()
        : publishersProvider.publishers;

    final List<Publisher> publishers = unfilteredPublishers.where((Publisher publisher) => publisher.toString().toLowerCase().contains(searchValue.toLowerCase())).toList();

    return Scaffold(
        body: publishers.isEmpty
            ? const Center(
                child: Text("No publishers found"),
              )
            : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                // crossAxisCount: 2,
                children: [
                  ...List.generate(
                    publishers.length,
                    (int index) => GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => BooksScreen(publisher: publishers[index]),
                        ),
                      ),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 120.0,
                            child: PublisherPreviewWidget(
                              publisher: publishers[index],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                // Edit the selected author.
                                Navigator.of(context).pushNamed(AuthorInfoScreen.routeName, arguments: publishers[index]);
                              },
                              icon: const Icon(Icons.info_rounded),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: fabAccessHeight),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(EditAuthorScreen.routeName);
          },
          child: const Icon(Icons.add_rounded),
        ));
  }
}
