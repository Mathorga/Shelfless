import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/screens/books_screen.dart';
import 'package:shelfless/screens/edit_publisher_screen.dart';
import 'package:shelfless/screens/publisher_info_screen.dart';
import 'package:shelfless/utils/constants.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/publisher_preview_widget.dart';

class PublishersOverviewWidget extends StatelessWidget {
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
        backgroundColor: Colors.transparent,
        body: publishers.isEmpty
            ? Center(
                child: Text(strings.noPublishersFound),
              )
            : GridView.count(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12.0),
                crossAxisCount: 1,
                childAspectRatio: 24 / 9,
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
                            height: double.infinity,
                            child: PublisherPreviewWidget(
                              publisher: publishers[index],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                // Edit the selected author.
                                Navigator.of(context).pushNamed(PublisherInfoScreen.routeName, arguments: publishers[index]);
                              },
                              icon: const Icon(Icons.settings_rounded),
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
            Navigator.of(context).pushNamed(EditPublisherScreen.routeName);
          },
          child: const Icon(Icons.add_rounded),
        ));
  }
}
