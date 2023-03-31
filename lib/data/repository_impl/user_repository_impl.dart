import 'package:firebase/firebase.dart';
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

  @override
  Future<void> updateUser({
    required String userId,
    String? name,
    String? surname,
  }) async {
    final UserDto? userDto = await _firebaseUserService.updateUserData(
      userId: userId,
      name: name,
      surname: surname,
    );
    if (userDto != null) {
      final User user = mapUserFromDtoModel(
        userDto: userDto,
        appearanceSettingsDto: const AppearanceSettingsDto(
          userId: '',
          themeMode: ThemeMode.light,
          language: Language.polish,
        ),
        workoutSettingsDto: const WorkoutSettingsDto(
          userId: '',
          distanceUnit: DistanceUnit.kilometers,
          paceUnit: PaceUnit.minutesPerKilometer,
        ),
      );
      if (doesEntityNotExistInState(user.id)) {
        addEntity(user);
      } else {
        updateEntity(user);
      }
    }
  }

  @override
  Future<void> deleteUser({
    required String userId,
  }) async {
    await _firebaseUserService.deleteUserData(userId: userId);
    removeEntity(userId);
  }

  Future<void> _loadUserFromFirebase(String userId) async {
    final UserDto? userDto = await _firebaseUserService.loadUserById(
      userId: userId,
    );
    if (userDto != null) {
      final User user = mapUserFromDtoModel(
        userDto: userDto,
        appearanceSettingsDto: const AppearanceSettingsDto(
          userId: '',
          themeMode: ThemeMode.light,
          language: Language.polish,
        ),
        workoutSettingsDto: const WorkoutSettingsDto(
          userId: '',
          distanceUnit: DistanceUnit.kilometers,
          paceUnit: PaceUnit.minutesPerKilometer,
        ),
      );
      addEntity(user);
    }
  }
}
