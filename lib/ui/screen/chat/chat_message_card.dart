import 'package:flutter/material.dart';

class ChatMessageCard extends StatelessWidget {
  final bool hasMessageBeenSentByLoggedUser;
  final Widget child;

  const ChatMessageCard({
    super.key,
    required this.hasMessageBeenSentByLoggedUser,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    const Radius borderRadius = Radius.circular(16);

    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: borderRadius,
          topRight: borderRadius,
          bottomLeft:
              hasMessageBeenSentByLoggedUser ? borderRadius : Radius.zero,
          bottomRight:
              hasMessageBeenSentByLoggedUser ? Radius.zero : borderRadius,
        ),
      ),
      color: hasMessageBeenSentByLoggedUser
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.surfaceVariant,
      child: child,
    );
  }
}
