import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../component/responsive_layout_component.dart';
import 'client_content_desktop.dart';
import 'client_content_mobile.dart';

@RoutePage()
class ClientScreen extends StatelessWidget {
  final String? clientId;

  const ClientScreen({super.key, @PathParam('clientId') this.clientId});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: ClientContentMobile(),
      desktopBody: ClientContentDesktop(),
    );
  }
}
