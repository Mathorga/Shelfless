import 'package:flutter/material.dart';

import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';

/// Simple searchable list of elements.
class SearchListWidget<T> extends StatefulWidget {
  final bool Function(T, String?) filter;
  final Widget Function(T) builder;
  final void Function(Set<T>)? onElementsSelected;
  final void Function()? onCancel;
  final bool multiple;
  final List<T> children;

  const SearchListWidget({
    Key? key,
    required this.filter,
    required this.builder,
    this.onElementsSelected,
    this.onCancel,
    this.multiple = false,
    this.children = const [],
  }) : super(key: key);

  @override
  State<SearchListWidget> createState() => _SearchListWidgetState<T>();
}

class _SearchListWidgetState<T> extends State<SearchListWidget<T>> {
  String? _filter;
  final Set<T> _selection = {};

  // @override
  // void initState() {
  //   super.initState();

  //   _selection.addAll();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                ...widget.children
                    .where(
                      (T element) => widget.filter(element, _filter),
                    )
                    .map(
                      (T element) => Row(
                        children: [
                          if (widget.multiple)
                            Checkbox(
                              value: _selection.contains(element),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selection.add(element);
                                  } else {
                                    _selection.remove(element);
                                  }
                                });
                              },
                            ),
                          Expanded(
                            child: GestureDetector(
                              onTap: !widget.multiple && widget.onElementsSelected != null ? () => widget.onElementsSelected!({element}) : null,
                              child: widget.builder(element),
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ),
        if (widget.multiple)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => widget.onCancel,
                child: Text(strings.no),
              ),
              Themes.spacer,
              ElevatedButton(
                onPressed: () => widget.onElementsSelected?.call(_selection),
                child: Text(strings.yes),
              ),
            ],
          ),
      ],
    );
  }
}
