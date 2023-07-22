import 'entity.dart';
import 'settings.dart';

enum Gender {
  male,
  female,
}

class User extends Entity {
  final Gender gender;
  final String name;
  final String surname;
  final Settings settings;

  const User({
    required super.id,
    required this.gender,
    required this.name,
    required this.surname,
    required this.settings,
  });

  @override
  List<Object> get props => [
        id,
        gender,
        name,
        surname,
        settings,
      ];
}
