extension DoubleFormatter on double {
  String toDistanceFormat() {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

    return toString().replaceAll(regex, '');
  }
}
