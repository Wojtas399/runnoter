import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';

class ProfileState extends BlocState {
  final String? name;
  final String? surname;
  final String? email;

  const ProfileState({
    required super.status,
    required this.name,
    required this.surname,
    required this.email,
  });

  @override
  List<Object?> get props => [
        status,
        name,
        surname,
        email,
      ];

  @override
  ProfileState copyWith({
    BlocStatus? status,
    String? name,
    String? surname,
    String? email,
  }) {
    return ProfileState(
      status: status ?? const BlocStatusComplete(),
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
    );
  }
}
