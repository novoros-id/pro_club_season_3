import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';

// Класс состояния фильтров
class AnalyticsFilters {
  final Goalkeeper? selectedGoalkeeper;
  final DateTime? startDate;
  final DateTime? endDate;

  AnalyticsFilters({
    this.selectedGoalkeeper,
    this.startDate,
    this.endDate,
  });

  AnalyticsFilters copyWith({
    Goalkeeper? selectedGoalkeeper,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return AnalyticsFilters(
      selectedGoalkeeper: selectedGoalkeeper ?? this.selectedGoalkeeper,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

// Провайдер состояния
class AnalyticsFilterNotifier extends StateNotifier<AnalyticsFilters> {
  AnalyticsFilterNotifier() : super(AnalyticsFilters());

  void setGoalkeeper(Goalkeeper? goalkeeper) {
    state = state.copyWith(selectedGoalkeeper: goalkeeper);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void clearFilters() {
    state = AnalyticsFilters();
  }
}

final analyticsFilterProvider = StateNotifierProvider<AnalyticsFilterNotifier, AnalyticsFilters>(
      (ref) => AnalyticsFilterNotifier(),
);