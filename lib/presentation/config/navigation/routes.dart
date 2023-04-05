enum Routes {
  signIn('/'),
  signUp('/sign-up'),
  forgotPassword('/forgot-password'),
  home('/home'),
  profile('/home/profile'),
  themeMode('/home/profile/theme-mode'),
  language('/home/profile/language');

  final String path;
  const Routes(this.path);
}
