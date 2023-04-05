import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/language_service.dart';

class LanguageProvider extends StatelessWidget {
  final Widget child;

  const LanguageProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LanguageService>(
      create: (_) => LanguageService(),
      child: child,
    );
  }
}
