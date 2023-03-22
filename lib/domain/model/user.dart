import 'entity.dart';

class User extends Entity {
  final String name;
  final String surname;

  const User({
    required super.id,
    required this.name,
    required this.surname,
  });

  @override
  List<Object> get props => [
        id,
        name,
        surname,
      ];
}
