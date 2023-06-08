import 'package:flutter/material.dart';

class CompetitionPreviewScreen extends StatelessWidget {
  final String competitionId;

  const CompetitionPreviewScreen({
    super.key,
    required this.competitionId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Competition preview'),
      ),
    );
  }
}
