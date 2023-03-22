import 'package:runnoter/domain/model/user.dart';

User createUser({
  String id = '',
  String name = '',
  String surname = '',
}) {
  return User(
    id: id,
    name: name,
    surname: surname,
  );
}
