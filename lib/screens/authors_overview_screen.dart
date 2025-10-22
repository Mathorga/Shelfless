import 'package:flutter/material.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/models/library_filters.dart';
import 'package:shelfless/screens/edit_author_screen.dart';
import 'package:shelfless/utils/constants.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/author_preview_widget.dart';

class AuthorsOverviewScreen extends StatefulWidget {
  final String searchValue;

  const AuthorsOverviewScreen({
    super.key,
    this.searchValue = "",
  });

  @override
  State<AuthorsOverviewScreen> createState() => _AuthorsOverviewScreenState();
}

class _AuthorsOverviewScreenState extends State<AuthorsOverviewScreen> {
  @override
  void initState() {
    super.initState();

    LibraryContentProvider.instance.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.authorsSectionTitle),
      ),
      body: SafeArea(
        child: LibraryContentProvider.instance.authors.isEmpty
            ? Center(
                child: Text(strings.noAuthorsFound),
              )
            : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12.0),
                children: [
                  ...List.generate(
                    LibraryContentProvider.instance.authors.length,
                    (int index) {
                      // Make sure the received index is somewhat valid.
                      if (index > LibraryContentProvider.instance.authors.values.length) return const Placeholder();
        
                      // Prefetch the genre for later use.
                      Author? author = LibraryContentProvider.instance.authors.values.toList()[index];
        
                      return AuthorPreviewWidget(
                        author: author,
                        onTap: () {
                          final NavigatorState navigator = Navigator.of(context);
        
                          // Filter the current library by the selected author.
                          LibraryContentProvider.instance.applyFilters(
                            LibraryFilters(
                              inAuthorsFilter: {author.id},
                            ),
                          );
        
                          navigator.pop();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: fabAccessHeight),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => const EditAuthorScreen(),
            ),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
