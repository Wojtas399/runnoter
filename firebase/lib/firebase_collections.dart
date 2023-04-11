part of firebase;

CollectionReference<UserDto> getUsersRef() {
  return FirebaseFirestore.instance.collection('Users').withConverter<UserDto>(
        fromFirestore: (snapshot, _) => UserDto.fromJson(
          snapshot.id,
          snapshot.data(),
        ),
        toFirestore: (UserDto userDto, _) => userDto.toJson(),
      );
}

DocumentReference<UserDto> getUserRef(String userId) {
  return getUsersRef().doc(userId);
}

CollectionReference<WorkoutDto> getWorkoutsRef(String userId) {
  return getUserRef(userId).collection('Workouts').withConverter<WorkoutDto>(
        fromFirestore: (snapshot, _) => WorkoutDto.fromJson(
          docId: snapshot.id,
          userId: userId,
          json: snapshot.data(),
        ),
        toFirestore: (workoutDto, _) => workoutDto.toJson(),
      );
}

DocumentReference<AppearanceSettingsDto> getAppearanceSettingsRef(
  String userId,
) {
  return getUserRef(userId)
      .collection('Settings')
      .doc('AppearanceSettings')
      .withConverter<AppearanceSettingsDto>(
        fromFirestore: (snapshot, _) => AppearanceSettingsDto.fromJson(
          userId,
          snapshot.data(),
        ),
        toFirestore: (appearanceSettingsDto, _) =>
            appearanceSettingsDto.toJson(),
      );
}

DocumentReference<WorkoutSettingsDto> getWorkoutSettingsRef(
  String userId,
) {
  return getUserRef(userId)
      .collection('Settings')
      .doc('WorkoutSettings')
      .withConverter<WorkoutSettingsDto>(
        fromFirestore: (snapshot, _) => WorkoutSettingsDto.fromJson(
          userId,
          snapshot.data(),
        ),
        toFirestore: (workoutSettingsDto, _) => workoutSettingsDto.toJson(),
      );
}
