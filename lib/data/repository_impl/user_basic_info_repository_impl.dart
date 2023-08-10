import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart';

import '../../dependency_injection.dart';
import '../../domain/additional_model/state_repository.dart';
import '../../domain/entity/user_basic_info.dart';
import '../../domain/repository/user_basic_info_repository.dart';
import '../mapper/user_basic_info_mapper.dart';

class UserBasicInfoRepositoryImpl extends StateRepository<UserBasicInfo>
    implements UserBasicInfoRepository {
  final FirebaseUserService _firebaseUserService;

  UserBasicInfoRepositoryImpl({super.initialData})
      : _firebaseUserService = getIt<FirebaseUserService>();

  @override
  Stream<UserBasicInfo?> getUserBasicInfoByUserId({
    required String userId,
  }) async* {
    await for (final users in dataStream$) {
      UserBasicInfo? userBasicInfo = users?.firstWhereOrNull(
        (UserBasicInfo userInfo) => userInfo.id == userId,
      );
      userBasicInfo ??= await _loadUserByUserIdFromDb(userId);
      yield userBasicInfo;
    }
  }

  @override
  Stream<List<UserBasicInfo>?> getUsersBasicInfoByCoachId({
    required String coachId,
  }) async* {
    await _loadUsersByCoachIdFromDb(coachId);
    await for (final users in dataStream$) {
      yield users
          ?.where((UserBasicInfo userInfo) => userInfo.coachId == coachId)
          .toList();
    }
  }

  @override
  Future<List<UserBasicInfo>> searchForUsers({required searchQuery}) async {
    await _searchForUsersInDb(searchQuery);
    final Stream<List<UserBasicInfo>> matchingUsers$ = dataStream$.map(
      (List<UserBasicInfo>? usersInfo) => [
        ...?usersInfo?.where(
          (UserBasicInfo userInfo) {
            final String lowerCaseSearchQuery = searchQuery.toLowerCase();
            bool doesNameMatch =
                userInfo.name.toLowerCase().contains(lowerCaseSearchQuery);
            bool doesSurnameMatch =
                userInfo.surname.toLowerCase().contains(lowerCaseSearchQuery);
            bool doesEmailMatch =
                userInfo.email.toLowerCase().contains(lowerCaseSearchQuery);
            return doesNameMatch || doesSurnameMatch || doesEmailMatch;
          },
        ),
      ],
    );
    return await matchingUsers$.first;
  }

  Future<UserBasicInfo?> _loadUserByUserIdFromDb(String userId) async {
    final userDto = await _firebaseUserService.loadUserById(userId: userId);
    if (userDto == null) return null;
    final UserBasicInfo userBasicInfo = mapUserBasicInfoFromDto(userDto);
    addEntity(userBasicInfo);
    return userBasicInfo;
  }

  Future<void> _loadUsersByCoachIdFromDb(String coachId) async {
    final List<UserDto> userDtos =
        await _firebaseUserService.loadUsersByCoachId(coachId: coachId);
    if (userDtos.isEmpty) return;
    final List<UserBasicInfo> usersBasicInfo =
        userDtos.map(mapUserBasicInfoFromDto).toList();
    addEntities(usersBasicInfo);
  }

  Future<void> _searchForUsersInDb(String searchQuery) async {
    final List<UserDto> foundUserDtos =
        await _firebaseUserService.searchForUsers(searchQuery: searchQuery);
    final List<UserBasicInfo> usersBasicInfo =
        foundUserDtos.map(mapUserBasicInfoFromDto).toList();
    addEntities(usersBasicInfo);
  }
}
