import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/config.dart';
import 'package:shelfless/utils/shared_prefs_helper.dart';
import 'package:shelfless/utils/shared_prefs_keys.dart';
import 'package:shelfless/utils/strings/strings.dart';

class DateFormatDialogContentWidget extends StatefulWidget {
  final String? startingValue;
  final void Function(String value)? onChanged;

  const DateFormatDialogContentWidget({
    super.key,
    this.startingValue,
    this.onChanged,
  });

  @override
  State<DateFormatDialogContentWidget> createState() => __DateFormatStateDialogContentWidget();
}

class __DateFormatStateDialogContentWidget extends State<DateFormatDialogContentWidget> {
  late final TextEditingController _controller = TextEditingController(text: widget.startingValue ?? "");

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Themes.spacingSmall,
      children: [
        TextFormField(
          controller: _controller,
          onChanged: (String value) {
            _controller.text = value;

            widget.onChanged?.call(value);
          },
        ),
        Text("${strings.example}: ${DateFormat(_controller.text).format(DateTime.now())}"),
      ],
    );
  }
}

class DateFormatSettingDialog extends StatefulWidget {
  final void Function()? onCancel;
  final void Function(String value)? onConfirm;

  const DateFormatSettingDialog({
    super.key,
    this.onCancel,
    this.onConfirm,
  });

  @override
  State<DateFormatSettingDialog> createState() => _DateFormatSettingDialogState();
}

class _DateFormatSettingDialogState extends State<DateFormatSettingDialog> {
  String _value = SharedPrefsHelper.instance.data.getString(SharedPrefsKeys.dateFormat) ?? Config.defaultDateFormat;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(strings.settingDateFormat),
      content: SizedBox(
        width: Themes.maxContentWidth,
        child: DateFormatDialogContentWidget(
          startingValue: _value,
          onChanged: (String value) {
            setState(() {
              _value = value;
            });
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onCancel?.call();
          },
          child: Text(strings.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onConfirm?.call(_value);
          },
          child: Text(strings.confirm),
        ),
      ],
    );
  }
}
