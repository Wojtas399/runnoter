import 'package:bloc_test/bloc_test.dart';
import 'package:runnoter/ui/service/language_service.dart';

void main() {
  LanguageService createLanguageService() => LanguageService();

  blocTest(
    'change language, '
    'should update language in state',
    build: () => createLanguageService(),
    act: (LanguageService service) {
      service.changeLanguage(AppLanguage.system);
    },
    expect: () => [
      AppLanguage.system,
    ],
  );
}
