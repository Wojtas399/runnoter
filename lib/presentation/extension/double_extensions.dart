extension DoubleExtensions on double {
  double decimal(int decimalRange) => double.parse(
        toStringAsFixed(decimalRange),
      );
}
