import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppLanguage {
  polish(
    Locale('pl'),
  ),
  english(
    Locale('en'),
  );

  final Locale locale;

  const AppLanguage(this.locale);
}

class LanguageService extends Cubit<Locale> {
  LanguageService() : super(const Locale('pl'));

  void changeLanguage(AppLanguage newLanguage) {
    emit(newLanguage.locale);
  }
}
