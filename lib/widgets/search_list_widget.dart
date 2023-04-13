import 'package:flutter/material.dart';
import 'package:shelfish/themes/themes.dart';

class SearchListWidget<T> extends StatefulWidget {
  final List<T> children;
  final bool Function(T, String?) filter;
  final Widget Function(T) builder;

  const SearchListWidget({
    Key? key,
    this.children = const [],
    required this.filter,
    required this.builder,
  }) : super(key: key);

  @override
  State<SearchListWidget> createState() => _SearchListWidgetState<T>();
}

class _SearchListWidgetState<T> extends State<SearchListWidget<T>> {
  String? _filter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: "Search"),
          onChanged: (String? value) {
            setState(() {
              _filter = value?.toLowerCase();
            });
          },
        ),

        Themes.spacer,

        Expanded(
          child: SingleChildScrollView(
            physics: Themes.scrollPhysics,
            child: Column(
              children: [
                ...widget.children.where((T element) => widget.filter(element, _filter)).map(widget.builder),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
