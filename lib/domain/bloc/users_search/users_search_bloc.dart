import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../additional_model/user_basic_info.dart';
import '../../entity/user.dart';
import '../../repository/user_repository.dart';

part 'users_search_event.dart';
part 'users_search_state.dart';

class UsersSearchBloc extends BlocWithStatus<UsersSearchEvent, UsersSearchState,
    dynamic, dynamic> {
  final UserRepository _userRepository;

  UsersSearchBloc({
    UsersSearchState state = const UsersSearchState(
      status: BlocStatusInitial(),
    ),
  })  : _userRepository = getIt<UserRepository>(),
        super(state) {
    on<UsersSearchEventSearch>(_search);
  }

  Future<void> _search(
    UsersSearchEventSearch event,
    Emitter<UsersSearchState> emit,
  ) async {
    if (event.searchText.isEmpty) {
      emitCompleteStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    final List<User> foundUsers = await _userRepository.searchForUsers(
      name: event.searchText,
      surname: event.searchText,
      email: event.searchText,
    );
    emit(state.copyWith(
      foundUsers: _getUsersBasicInfo(foundUsers),
    ));
  }

  List<UserBasicInfo> _getUsersBasicInfo(List<User> users) => users
      .map(
        (User user) => UserBasicInfo(
          id: user.id,
          gender: user.gender,
          name: user.name,
          surname: user.surname,
          email: user.email,
        ),
      )
      .toList();
}
