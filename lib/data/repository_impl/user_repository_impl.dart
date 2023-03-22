import 'package:firebase/firebase.dart';
import 'package:firebase/model/dto/user_dto.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/model/state_repository.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/user_repository.dart';
import '../mapper/user_mapper.dart';

class UserRepositoryImpl extends StateRepository<User>
    implements UserRepository {
  final FirebaseUserService _firebaseUserService;

  UserRepositoryImpl({
    required FirebaseUserService firebaseUserService,
    List<User>? initialState,
  })  : _firebaseUserService = firebaseUserService,
        super(
          initialData: initialState,
        );

  @override
  Stream<User?> getUserById({
    required String userId,
  }) {
    return dataStream$
        .map(
      (List<User>? users) => <User?>[...?users].firstWhere(
        (User? user) => user?.id == userId,
        orElse: () => null,
      ),
    )
        .doOnListen(
      () async {
        if (doesEntityNotExistInState(userId)) {
          await _loadUserFromFirebase(userId);
        }
      },
    );
  }

  Future<void> _loadUserFromFirebase(String userId) async {
    final UserDto? userDto = await _firebaseUserService.loadUserById(
      userId: userId,
    );
    if (userDto != null) {
      final User user = mapUserFromDtoModel(userDto);
      addEntity(user);
    }
  }
}
