import 'package:flutter/material.dart';

import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_publisher_screen.dart';
import 'package:shelfless/utils/constants.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/author_preview_widget.dart';
import 'package:shelfless/widgets/publisher_preview_widget.dart';

class PublishersOverviewScreen extends StatefulWidget {
  final String searchValue;

  const PublishersOverviewScreen({
    super.key,
    this.searchValue = "",
  });

  @override
  State<PublishersOverviewScreen> createState() => _PublishersOverviewScreenState();
}

class _PublishersOverviewScreenState extends State<PublishersOverviewScreen> {
  @override
  void initState() {
    super.initState();

    LibraryContentProvider.instance.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.publishersSectionTitle),
      ),
      body: LibraryContentProvider.instance.publishers.isEmpty
          ? Center(
              child: Text(strings.noPublishersFound),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(12.0),
              children: [
                ...List.generate(
                  LibraryContentProvider.instance.publishers.length,
                  (int index) {
                    // Make sure the received index is somewhat valid.
                    if (index > LibraryContentProvider.instance.publishers.values.length) return const Placeholder();

                    // Prefetch the publisher for later use.
                    Publisher? publisher = LibraryContentProvider.instance.publishers.values.toList()[index];

                    return PublisherPreviewWidget(
                      publisher: publisher,
                      onTap: () {
                        // if (!librariesProvider.currentLibrary!.books.any((Book book) => book.publishers.contains(publishers[index]))) {
                        //   return;
                        // }

                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) => BooksScreen(
                        //       publishers: {publishers[index]},
                        //     ),
                        //   ),
                        // );
                      },
                    );
                  },
                ),
                const SizedBox(height: fabAccessHeight),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => const EditPublisherScreen(),
            ),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}