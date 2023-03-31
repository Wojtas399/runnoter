import 'entity.dart';
import 'settings.dart';

class User extends Entity {
  final String name;
  final String surname;
  final Settings settings;

  const User({
    required super.id,
    required this.name,
    required this.surname,
    required this.settings,
  });

  @override
  List<Object> get props => [
        id,
        name,
        surname,
        settings,
      ];
}
