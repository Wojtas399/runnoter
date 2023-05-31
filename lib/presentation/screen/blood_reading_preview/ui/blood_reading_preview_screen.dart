import 'package:flutter/material.dart';

class BloodReadingPreviewScreen extends StatelessWidget {
  final String bloodReadingId;

  const BloodReadingPreviewScreen({
    super.key,
    required this.bloodReadingId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood reading preview'),
      ),
    );
  }
}
