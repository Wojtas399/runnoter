import 'package:flutter/material.dart';

class CardBody extends StatelessWidget {
  final Widget child;

  const CardBody({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Container(
        padding: const EdgeInsets.all(24),
        color: Theme.of(context).colorScheme.background,
        child: child,
      ),
    );
  }
}
