import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/client_search/clients_search_state.dart';
import 'package:runnoter/domain/entity/client.dart';
import 'package:runnoter/domain/entity/user.dart';

void main() {
  late ClientsSearchState state;

  setUp(() {
    state = const ClientsSearchState(
      status: BlocStatusInitial(),
      searchText: '',
    );
  });

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with search text',
    () {
      const String expectedSearchText = 'sea';

      state = state.copyWith(searchText: expectedSearchText);
      final state2 = state.copyWith();

      expect(state.searchText, expectedSearchText);
      expect(state2.searchText, expectedSearchText);
    },
  );

  test(
    'copy with clients',
    () {
      const List<Client> expectedClients = [
        Client(
          id: 'c1',
          gender: Gender.male,
          name: 'name1',
          surname: 'surname1',
          email: 'email1@example.com',
        ),
        Client(
          id: 'c2',
          gender: Gender.female,
          name: 'name2',
          surname: 'surname2',
          email: 'email2@example.com',
        ),
      ];

      state = state.copyWith(clients: expectedClients);
      final state2 = state.copyWith();

      expect(state.clients, expectedClients);
      expect(state2.clients, expectedClients);
    },
  );
}
