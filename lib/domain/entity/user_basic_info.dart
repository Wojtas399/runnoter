import 'entity.dart';
import 'user.dart';

class UserBasicInfo extends Entity {
  final Gender gender;
  final String name;
  final String surname;
  final String email;
  final String? coachId;

  const UserBasicInfo({
    required super.id,
    required this.gender,
    required this.name,
    required this.surname,
    required this.email,
    this.coachId,
  });

  @override
  List<Object?> get props => [id, gender, name, surname, email, coachId];
}
