extension StringExtensions on String {
  String trimZeros() {
    final String numAsStr = double.parse(this).toString();
    if (numAsStr.contains('.')) {
      RegExp regex = RegExp(r'([.]*0+)(?!.*\d)');
      return double.parse(this).toString().replaceAll(regex, '');
    }
    return numAsStr;
  }

  DateTime toDateTime({
    String separator = '-',
  }) {
    final List<String> dateParts = split(separator);
    final int day = int.parse(dateParts[0]);
    final int month = int.parse(dateParts[1]);
    final int year = int.parse(dateParts[2]);
    return DateTime(year, month, day);
  }
}
