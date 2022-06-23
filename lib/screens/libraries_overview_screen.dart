import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfish/models/library.dart';
import 'package:shelfish/providers/libraries_provider.dart';

class LibrariesOverviewScreen extends StatelessWidget {
  static const String routeName = "/libraries_overview";

  const LibrariesOverviewScreen({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Libraries"),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    LibrariesProvider _librariesProvider = Provider.of(context, listen: true);
    final _libraries = _librariesProvider.libraries;

    return Scaffold(
      appBar: _buildAppBar(),
      body: ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
