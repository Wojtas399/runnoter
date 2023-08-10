import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/user_basic_info.dart';
import 'package:runnoter/domain/repository/user_basic_info_repository.dart';

class MockUserBasicInfoRepository extends Mock
    implements UserBasicInfoRepository {
  void mockGetUserBasicInfoByUserId({UserBasicInfo? userBasicInfo}) {
    when(
      () => getUserBasicInfoByUserId(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(userBasicInfo));
  }

  void mockGetUsersBasicInfoByCoachId({List<UserBasicInfo>? usersBasicInfo}) {
    when(
      () => getUsersBasicInfoByCoachId(
        coachId: any(named: 'coachId'),
      ),
    ).thenAnswer((_) => Stream.value(usersBasicInfo));
  }

  void mockSearchForUsers({List<UserBasicInfo>? usersBasicInfo}) {
    when(
      () => searchForUsers(
        searchQuery: any(named: 'searchQuery'),
      ),
    ).thenAnswer((_) => Future.value(usersBasicInfo));
  }
}
