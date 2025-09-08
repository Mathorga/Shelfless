import 'package:flutter/material.dart';

/// Text form field wrapper:
/// this widget exposes a TextFormField with automatic unfocus on tap outside and scroll.
class SlipperyTextFormFieldWidget extends StatefulWidget {
  final String? initialValue;
  final InputDecoration? decoration;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;

  const SlipperyTextFormFieldWidget({
    super.key,
    this.initialValue,
    this.decoration,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.onChanged,
  });

  @override
  State<SlipperyTextFormFieldWidget> createState() => _SlipperyTextFormFieldWidgetState();
}

class _SlipperyTextFormFieldWidgetState extends State<SlipperyTextFormFieldWidget> {
  late final TextEditingController _controller = TextEditingController(text: widget.initialValue ?? "");
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: widget.decoration,
      onTapOutside: (PointerDownEvent event) => _focusNode.unfocus(),
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
    );
  }
}
