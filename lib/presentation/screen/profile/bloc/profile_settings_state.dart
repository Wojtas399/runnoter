import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/entity/settings.dart';

class ProfileSettingsState extends BlocState {
  final ThemeMode? themeMode;
  final Language? language;
  final DistanceUnit? distanceUnit;
  final PaceUnit? paceUnit;

  const ProfileSettingsState({
    required super.status,
    required this.themeMode,
    required this.language,
    required this.distanceUnit,
    required this.paceUnit,
  });

  @override
  List<Object?> get props => [
        themeMode,
        language,
        distanceUnit,
        paceUnit,
      ];

  @override
  ProfileSettingsState copyWith({
    BlocStatus? status,
    ThemeMode? themeMode,
    Language? language,
    DistanceUnit? distanceUnit,
    PaceUnit? paceUnit,
  }) {
    return ProfileSettingsState(
      status: status ?? const BlocStatusComplete(),
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      paceUnit: paceUnit ?? this.paceUnit,
    );
  }
}
