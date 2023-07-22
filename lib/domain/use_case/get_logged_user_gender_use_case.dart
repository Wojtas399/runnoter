import 'package:rxdart/rxdart.dart';

import '../entity/user.dart';
import '../repository/user_repository.dart';
import '../service/auth_service.dart';

class GetLoggedUserGenderUseCase {
  final AuthService _authService;
  final UserRepository _userRepository;

  const GetLoggedUserGenderUseCase({
    required AuthService authService,
    required UserRepository userRepository,
  })  : _authService = authService,
        _userRepository = userRepository;

  Stream<Gender> execute() => _authService.loggedUserId$
      .whereNotNull()
      .switchMap(
        (String loggedUserId) => _userRepository.getUserById(
          userId: loggedUserId,
        ),
      )
      .whereNotNull()
      .map((User user) => user.gender);
}
