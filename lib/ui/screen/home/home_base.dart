import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../component/empty_content_info_component.dart';
import '../../cubit/internet_connection_cubit.dart';

@RoutePage()
class HomeBaseScreen extends StatelessWidget {
  const HomeBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InternetConnectionCubit()..initialize(),
      child: const _InternetConnectionCubitListener(
        child: AutoRouter(),
      ),
    );
  }
}

class _InternetConnectionCubitListener extends StatefulWidget {
  final Widget child;

  const _InternetConnectionCubitListener({required this.child});

  @override
  State<StatefulWidget> createState() =>
      _InternetConnectionCubitListenerState();
}

class _InternetConnectionCubitListenerState
    extends State<_InternetConnectionCubitListener> {
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    removeHighlightOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetConnectionCubit, bool?>(
      listener: (_, bool? isInternetConnection) {
        if (kIsWeb) {
          if (isInternetConnection == false) {
            _overlayEntry = OverlayEntry(
              builder: (BuildContext context) => Container(
                color: Colors.black.withOpacity(0.4),
                child: AlertDialog(
                  content: EmptyContentInfo(
                    icon: Icons.wifi_off,
                    title: Str.of(context).youAreOffline,
                  ),
                ),
              ),
            );
            Overlay.of(context, debugRequiredFor: widget)
                .insert(_overlayEntry!);
          } else if (isInternetConnection == true) {
            removeHighlightOverlay();
          }
        }
      },
      child: widget.child,
    );
  }

  void removeHighlightOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
