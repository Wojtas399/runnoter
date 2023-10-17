import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DateOfBirthPicker extends StatefulWidget {
  final DateTime? initialDateOfBirth;
  final Function(DateTime date) onDatePicked;

  const DateOfBirthPicker({
    super.key,
    this.initialDateOfBirth,
    required this.onDatePicked,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DateOfBirthPicker> {
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.initialDateOfBirth != null) {
      _controller.text = _dateFormat.format(widget.initialDateOfBirth!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        label: Text(Str.of(context).dateOfBirth),
        prefixIcon: const Icon(Icons.cake),
        suffixIcon: const Icon(Icons.calendar_month),
      ),
      controller: _controller,
      readOnly: true,
      onTap: () => _onTap(context),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime lastDate = DateTime(now.year - 12, now.month, now.day);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _controller.text.isNotEmpty
          ? _dateFormat.parse(_controller.text)
          : lastDate,
      firstDate: DateTime.fromMillisecondsSinceEpoch(1),
      lastDate: lastDate,
    );
    if (pickedDate == null) return;
    _controller.text = _dateFormat.format(pickedDate);
    widget.onDatePicked(pickedDate);
  }
}
