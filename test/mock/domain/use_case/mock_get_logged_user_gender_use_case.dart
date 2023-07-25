import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/use_case/get_logged_user_gender_use_case.dart';

class MockGetLoggedUserGenderUseCase extends Mock
    implements GetLoggedUserGenderUseCase {
  void mock({
    required Gender gender,
  }) {
    when(
      () => execute(),
    ).thenAnswer((_) => Stream.value(gender));
  }
}
