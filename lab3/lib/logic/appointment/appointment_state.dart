import '../../data/models/appointment_details.dart';

sealed class AppointmentState {
  const AppointmentState();
}

class AppointmentLoading extends AppointmentState {
  const AppointmentLoading();
}

class AppointmentError extends AppointmentState {
  const AppointmentError(this.message);

  final String message;
}

class AppointmentSuccess extends AppointmentState {
  const AppointmentSuccess({
    required this.details,
    required this.selectedHourId,
    required this.selectedDateId,
    this.showAllHours = false,
    this.showAllDates = false,
    this.confirmation,
  });

  final AppointmentDetails details;
  final String? selectedHourId;
  final String? selectedDateId;

  // "See All" comută între lista orizontală și afișarea tuturor opțiunilor
  final bool showAllHours;
  final bool showAllDates;

  // Mesajul afișat o singură dată, imediat după rezervare
  final String? confirmation;

  AppointmentSuccess copyWith({
    String? selectedHourId,
    String? selectedDateId,
    bool? showAllHours,
    bool? showAllDates,
    String? confirmation,
  }) {
    return AppointmentSuccess(
      details: details,
      selectedHourId: selectedHourId ?? this.selectedHourId,
      selectedDateId: selectedDateId ?? this.selectedDateId,
      showAllHours: showAllHours ?? this.showAllHours,
      showAllDates: showAllDates ?? this.showAllDates,
      confirmation: confirmation,
    );
  }
}
