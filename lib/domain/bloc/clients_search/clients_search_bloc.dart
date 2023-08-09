import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../additional_model/user_basic_info.dart';
import '../../entity/user.dart';
import '../../repository/user_repository.dart';

part 'clients_search_event.dart';
part 'clients_search_state.dart';

class ClientsSearchBloc extends BlocWithStatus<ClientsSearchEvent,
    ClientsSearchState, dynamic, dynamic> {
  final UserRepository _userRepository;

  ClientsSearchBloc({
    ClientsSearchState state = const ClientsSearchState(
      status: BlocStatusInitial(),
      searchText: '',
    ),
  })  : _userRepository = getIt<UserRepository>(),
        super(state) {
    on<ClientsSearchEventSearchTextChanged>(_searchTextChanged);
    on<ClientsSearchEventSearch>(_search);
  }

  void _searchTextChanged(
    ClientsSearchEventSearchTextChanged event,
    Emitter<ClientsSearchState> emit,
  ) {
    emit(state.copyWith(
      searchText: event.searchText,
    ));
  }

  Future<void> _search(
    ClientsSearchEventSearch event,
    Emitter<ClientsSearchState> emit,
  ) async {
    if (state.searchText.isEmpty) return;
    emitLoadingStatus(emit);
    final List<User> foundUsers = await _userRepository.searchForUsers(
      name: state.searchText,
      surname: state.searchText,
      email: state.searchText,
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
