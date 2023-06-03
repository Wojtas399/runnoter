import '../../domain/entity/workout_status.dart';

extension MoodRateFormatter on MoodRate {
  String toUIFormat() {
    switch (this) {
      case MoodRate.mr1:
        return '1 - Maksymalne wyczerpanie';
      case MoodRate.mr2:
        return '2 - Bardzo ciężko w trakcie, bardzo duże zmęczenie po';
      case MoodRate.mr3:
        return '3 - Ciężko w trakcie, bardzo duże zmęczenie po';
      case MoodRate.mr4:
        return '4 - Umiarkowanie w trakcie, bardzo duże zmęczenie';
      case MoodRate.mr5:
        return '5 - Umiarkowanie w trakcie, większe niż zwykle zmęczenie po';
      case MoodRate.mr6:
        return '6 - Umiarkowanie w trakcie, normalne zmęczenie po';
      case MoodRate.mr7:
        return '7 - Normalnie w trakcie, normalne zmęczenie po';
      case MoodRate.mr8:
        return '8 - Normalnie w trakcie, lekkie zmęczenie po';
      case MoodRate.mr9:
        return '9 - Normalnie w trakcie, prawie brak zmęczenia po';
      case MoodRate.mr10:
        return '10 - Normalnie w trakcie, brak zmęczenia po';
    }
  }
}
