extension StringExtensions on String {
  String trimZeros() {
    final String numAsStr = double.parse(this).toString();
    if (numAsStr.contains('.')) {
      RegExp regex = RegExp(r'([.]*0+)(?!.*\d)');
      return double.parse(this).toString().replaceAll(regex, '');
    }
    return numAsStr;
  }
}
