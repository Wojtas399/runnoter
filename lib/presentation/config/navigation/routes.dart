enum Routes {
  signIn('/'),
  signUp('/sign-up'),
  forgotPassword('/forgot-password'),
  home('/home'),
  profile('/home/profile'),
  themeMode('/home/profile/theme-mode'),
  language('/home/profile/language'),
  distanceUnit('/home/profile/distance-unit');

  final String path;
  const Routes(this.path);
}
