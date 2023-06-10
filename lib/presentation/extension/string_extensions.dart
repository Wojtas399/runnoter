extension StringExtensions on String {
  String trimZeros() {
    RegExp regex = RegExp(r'([.]*0+)(?!.*\d)');

    return double.parse(this).toString().replaceAll(regex, '');
  }
}
