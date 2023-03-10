part of firebase;

Future<void> signIn({
  required String email,
  required String password,
}) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

Future<String?> signUp({
  required String name,
  required String surname,
  required String email,
  required String password,
}) async {
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  if (credential.user == null) {
    return null;
  }
  final String userId = credential.user!.uid;
  final UserDto userDto = UserDto(name: name, surname: surname);
  await getUsersRef().doc(userId).set(userDto);
  return userId;
}
