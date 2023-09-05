import 'package:intl/intl.dart';

DateTime mapDateTimeFromString(String date) =>
    DateFormat('yyyy-MM-dd').parse(date);

String mapDateTimeToString(DateTime date) =>
    DateFormat('yyyy-MM-dd').format(date);
