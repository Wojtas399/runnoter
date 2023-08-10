import '../entity/user_basic_info.dart';

abstract interface class UserBasicInfoRepository {
  Stream<UserBasicInfo?> getUserBasicInfoByUserId({required String userId});

  Stream<List<UserBasicInfo>?> getUsersBasicInfoByCoachId({
    required String coachId,
  });
}
