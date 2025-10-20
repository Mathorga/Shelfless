import 'package:flutter/material.dart';

import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/slippery_text_form_field_widget.dart';

class SelectionController<T> with ChangeNotifier {
  List<T> domain;
  Set<T> selection;

  SelectionController({
    this.domain = const [],
    this.selection = const {},
  });

  void setDomain(List<T> elements) {
    domain = [...elements];
    notifyListeners();
  }

  void setSelection(Set<T> elements) {
    selection = {...elements};
    notifyListeners();
  }

  void clearSelection() {
    selection.clear();
    notifyListeners();
  }

  /// Adds [element] to the list of all possible elements.
  /// If [select] is true, then [element] is also selected.
  void addToDomain(T element, {bool select = false}) {
    domain.add(element);

    if (select) selection.add(element);

    notifyListeners();
  }

  void addToSelection(Set<T> elements) {
    selection.addAll(elements);
    notifyListeners();
  }

  void removeFromSelection(Set<T> ids) {
    selection.removeAll(ids);
    notifyListeners();
  }
}

/// Simple searchable list of elements.
class SearchListWidget<T> extends StatefulWidget {
  final bool Function(T, String?) filter;
  final Widget Function(T) builder;
  final void Function(Set<T>)? onElementsSelected;
  final void Function()? onCancel;
  final bool multiple;

  final SelectionController<T> selectionController;
  final ScrollController? scrollController;

  const SearchListWidget({
    super.key,
    required this.filter,
    required this.builder,
    this.onElementsSelected,
    this.onCancel,
    this.multiple = false,
    required this.selectionController,
    this.scrollController,
  });

  @override
  State<SearchListWidget> createState() => _SearchListWidgetState<T>();
}

class _SearchListWidgetState<T> extends State<SearchListWidget<T>> {
  String? _filter;
  late double _currentScrollExtent = widget.scrollController?.position.maxScrollExtent ?? 0.0;

  @override
  void initState() {
    super.initState();

    widget.selectionController.addListener(_onSelectionControllerUpdated);
  }

  @override
  void dispose() {
    widget.selectionController.removeListener(_onSelectionControllerUpdated);

    super.dispose();
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
            controller: widget.scrollController,
            child: Column(
              children: [
                ...widget.selectionController.domain
                    .where(
                      (T element) => widget.filter(element, _filter),
                    )
                    .map(
                      (T element) => Row(
                        children: [
                          if (widget.multiple)
                            Checkbox(
                              value: widget.selectionController.selection.contains(element),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    widget.selectionController.addToSelection({element});
                                  } else {
                                    widget.selectionController.removeFromSelection({element});
                                  }
                                });
                              },
                            ),
                          Expanded(
                            child: GestureDetector(
                              onTap: widget.multiple
                                  ? () => setState(() => widget.selectionController.selection.contains(element)
                                      ? widget.selectionController.removeFromSelection({element})
                                      : widget.selectionController.addToSelection({element}))
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
                    onPressed: () {
                      final NavigatorState navigator = Navigator.of(context);

                      widget.onElementsSelected?.call(widget.selectionController.selection);

                      navigator.pop();
                    },
                    child: Text(strings.confirm),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  /// Reacts to changes in the provided selection controller.
  void _onSelectionControllerUpdated() {
    // Make sure setState is called AFTER the build phase is finished.
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      // Refresh the widget upon change.
      if (context.mounted) setState(() {});

      // Make sure a scroll controller is provided and return otherwise.
      final double? maxScrollExtent = widget.scrollController?.position.maxScrollExtent;
      if (maxScrollExtent == null) return;

      // Only go on if the scroll controller max extent increaded.
      if (_currentScrollExtent >= maxScrollExtent) return;

      // Move to the end of the list.
      _currentScrollExtent = maxScrollExtent;
      widget.scrollController?.animateTo(
        maxScrollExtent,
        duration: Themes.durationShort,
        curve: Curves.fastOutSlowIn,
      );
    });
  }
}
