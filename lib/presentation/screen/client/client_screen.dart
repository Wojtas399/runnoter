import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ClientScreen extends StatelessWidget {
  final String clientId;

  const ClientScreen({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return Text(clientId);
  }
}
