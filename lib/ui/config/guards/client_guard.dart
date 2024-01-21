import 'package:auto_route/auto_route.dart';

import '../../../data/model/person.dart';
import '../../../data/repository/person/person_repository.dart';
import '../../../data/service/auth/auth_service.dart';
import '../../../dependency_injection.dart';

class ClientGuard extends AutoRouteGuard {
  final AuthService _authService;
  final PersonRepository _personRepository;

  ClientGuard()
      : _authService = getIt<AuthService>(),
        _personRepository = getIt<PersonRepository>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    final String clientId = resolver.route.pathParams.get('clientId');
    final Stream<Person?> client$ = _personRepository.getPersonById(
      personId: clientId,
    );
    await for (final client in client$) {
      resolver.next(client != null &&
          loggedUserId != null &&
          client.coachId == loggedUserId);
      return;
    }
  }
}
