import 'package:flutter/material.dart';

class HealthMeasurementCreatorScreen extends StatelessWidget {
  final DateTime? date;

  const HealthMeasurementCreatorScreen({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health measurement creator'),
      ),
    );
  }
}
