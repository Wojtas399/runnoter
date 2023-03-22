enum Routes {
  signIn('/'),
  signUp('/sign-up'),
  forgotPassword('/forgot-password'),
  home('/home'),
  profile('/home/profile');

  final String path;
  const Routes(this.path);
}
