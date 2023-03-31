import '../firebase.dart';

Language mapLanguageFromStringToEnum(String language) {
  return Language.values.byName(language);
}
