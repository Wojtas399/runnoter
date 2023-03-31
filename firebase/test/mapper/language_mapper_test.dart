import 'package:firebase/firebase.dart';
import 'package:firebase/mapper/language_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map language from string to enum, '
    'polish should be mapped to Language.polish',
    () {
      const String strLanguage = 'polish';
      const Language expectedEnumLanguage = Language.polish;

      final Language enumLanguage = mapLanguageFromStringToEnum(strLanguage);

      expect(enumLanguage, expectedEnumLanguage);
    },
  );

  test(
    'map language from string to enum, '
    'english should be mapped to Language.english',
    () {
      const String strLanguage = 'english';
      const Language expectedEnumLanguage = Language.english;

      final Language enumLanguage = mapLanguageFromStringToEnum(strLanguage);

      expect(enumLanguage, expectedEnumLanguage);
    },
  );
}
