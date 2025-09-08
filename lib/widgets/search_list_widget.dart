import 'package:flutter/material.dart';

import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/slippery_text_form_field_widget.dart';

/// Simple searchable list of elements.
class SearchListWidget<T> extends StatefulWidget {
  final bool Function(T, String?) filter;
  final Widget Function(T) builder;
  final void Function(Set<T>)? onElementsSelected;
  final void Function()? onCancel;
  final bool multiple;
  final List<T> values;

  /// List of all preselected values.
  final List<T> selectedValues;

  const SearchListWidget({
    super.key,
    required this.filter,
    required this.builder,
    this.onElementsSelected,
    this.onCancel,
    this.multiple = false,
    this.values = const [],
    this.selectedValues = const [],
  });

  @override
  State<SearchListWidget> createState() => _SearchListWidgetState<T>();
}

class _SearchListWidgetState<T> extends State<SearchListWidget<T>> {
  String? _filter;
  final Set<T> _selection = {};

  @override
  void initState() {
    super.initState();

    _selection.addAll(widget.selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SlipperyTextFormFieldWidget(
          decoration: InputDecoration(
            labelText: strings.search,
          ),
          onChanged: (String value) {
            setState(() {
              _filter = value.toLowerCase();
            });
          },
        ),
        Themes.spacer,
        Expanded(
          child: SingleChildScrollView(
            physics: Themes.scrollPhysics,
            child: Column(
              children: [
                ...widget.values
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
                              onTap: widget.multiple
                                  ? () => setState(() => _selection.contains(element) ? _selection.remove(element) : _selection.add(element))
                                  : () => widget.onElementsSelected?.call({element}),
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
          Column(
            children: [
              Themes.spacer,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final NavigatorState navigator = Navigator.of(context);

                      widget.onCancel?.call();

                      navigator.pop();
                    },
                    child: Text(strings.cancel),
                  ),
                  Themes.spacer,
                  ElevatedButton(
                    onPressed: () => widget.onElementsSelected?.call(_selection),
                    child: Text(strings.confirm),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
