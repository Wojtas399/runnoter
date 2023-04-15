import 'package:flutter/material.dart';

class DayPreviewScreen extends StatelessWidget {
  final DateTime date;

  const DayPreviewScreen({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Day preview screen',
        ),
      ),
    );
  }
}
