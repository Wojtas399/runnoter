import 'package:runnoter/domain/cubit/mileage_cubit.dart';

ChartMonth createChartMonth({
  Month month = Month.january,
  double mileage = 0.0,
}) =>
    ChartMonth(
      month: month,
      mileage: mileage,
    );
