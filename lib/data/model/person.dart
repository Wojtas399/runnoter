import 'entity.dart';
import 'user.dart';

class Person extends Entity {
  final AccountType accountType;
  final Gender gender;
  final String name;
  final String surname;
  final String email;
  final DateTime? dateOfBirth;
  final String? coachId;

  const Person({
    required super.id,
    required this.accountType,
    required this.gender,
    required this.name,
    required this.surname,
    required this.email,
    required this.dateOfBirth,
    this.coachId,
  });

  @override
  List<Object?> get props => [
        id,
        accountType,
        gender,
        name,
        surname,
        email,
        dateOfBirth,
        coachId,
      ];
}
