import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/appointment_details.dart';
import '../../data/models/doctor.dart';
import '../../data/repositories/medical_repository.dart';
import 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit(this._repository) : super(const AppointmentLoading());

  final MedicalRepository _repository;

  Future<void> load(Doctor doctor) async {
    emit(const AppointmentLoading());
    try {
      final details = (await _repository.loadAppointmentDetails()).forDoctor(
        doctor,
      );
      emit(
        AppointmentSuccess(
          details: details,
          selectedHourId: _initiallySelected(details.hours),
          selectedDateId: _initiallySelected(details.dates),
        ),
      );
    } catch (error) {
      emit(AppointmentError('Could not load appointment details.\n$error'));
    }
  }

  String? _initiallySelected(List<TimeSlot> slots) {
    for (final slot in slots) {
      if (slot.selected) return slot.id;
    }
    return slots.isEmpty ? null : slots.first.id;
  }

  void selectHour(String id) => _update((s) => s.copyWith(selectedHourId: id));

  void selectDate(String id) => _update((s) => s.copyWith(selectedDateId: id));

  void toggleAllHours() =>
      _update((s) => s.copyWith(showAllHours: !s.showAllHours));

  void toggleAllDates() =>
      _update((s) => s.copyWith(showAllDates: !s.showAllDates));

  void book() {
    _update((s) {
      String label(List<TimeSlot> slots, String? id) =>
          slots.where((slot) => slot.id == id).map((e) => e.label).join();

      final date = label(s.details.dates, s.selectedDateId);
      final hour = label(s.details.hours, s.selectedHourId);
      return s.copyWith(
        confirmation: 'Booked with ${s.details.doctorName}: $date, $hour',
      );
    });
  }

  void _update(AppointmentSuccess Function(AppointmentSuccess) change) {
    final current = state;
    if (current is AppointmentSuccess) emit(change(current));
  }
}
