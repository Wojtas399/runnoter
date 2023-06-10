import 'package:runnoter/domain/bloc/mileage/mileage_cubit.dart';

ChartMonth createChartMonth({
  Month month = Month.january,
  double mileage = 0.0,
}) =>
    ChartMonth(
      month: month,
      mileage: mileage,
    );
