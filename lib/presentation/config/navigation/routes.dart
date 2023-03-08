enum Routes {
  signIn('/'),
  signUp('/sign-up'),
  forgotPassword('/forgot-password'),
  home('/home');

  final String path;
  const Routes(this.path);
}
