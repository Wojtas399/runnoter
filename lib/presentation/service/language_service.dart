import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppLanguage {
  polish(
    Locale('pl'),
  ),
  english(
    Locale('en'),
  ),
  system(null);

  final Locale? locale;

  const AppLanguage(this.locale);
}

class LanguageService extends Cubit<AppLanguage?> {
  LanguageService() : super(null);

  void changeLanguage(AppLanguage newLanguage) {
    emit(newLanguage);
  }
}
