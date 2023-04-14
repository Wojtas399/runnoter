extension DoubleFormatter on double {
  String toKilometersFormat() {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    final distance = toString().replaceAll(regex, '');
    return '${distance}km';
  }
}
