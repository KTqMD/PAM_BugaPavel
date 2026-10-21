import 'doctor.dart';

class TimeSlot {
  const TimeSlot({
    required this.id,
    required this.label,
    required this.selected,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'] as String,
      label: json['label'] as String? ?? '',
      selected: json['selected'] as bool? ?? false,
    );
  }

  final String id;
  final String label;
  final bool selected;
}

// Secțiunea "appointmentDetails" din JSON
class AppointmentDetails {
  const AppointmentDetails({
    required this.title,
    required this.doctorName,
    required this.clinic,
    required this.avatarUrl,
    required this.avatarAsset,
    required this.canMessage,
    required this.canCall,
    required this.canVideoCall,
    required this.paymentLabel,
    required this.paymentFormatted,
    required this.detailsTitle,
    required this.description,
    required this.hoursTitle,
    required this.hours,
    required this.dateTitle,
    required this.dates,
    required this.bookLabel,
    required this.bookEnabled,
  });

  factory AppointmentDetails.fromJson(Map<String, dynamic> json) {
    final doctor = json['doctor'] as Map<String, dynamic>? ?? const {};
    final actions = doctor['actions'] as Map<String, dynamic>? ?? const {};
    final payment = json['payment'] as Map<String, dynamic>? ?? const {};
    final details = json['details'] as Map<String, dynamic>? ?? const {};
    final hours = json['workingHours'] as Map<String, dynamic>? ?? const {};
    final date = json['date'] as Map<String, dynamic>? ?? const {};
    final book =
        (json['actions'] as Map<String, dynamic>?)?['bookAppointment']
            as Map<String, dynamic>? ??
        const {};

    List<TimeSlot> slots(Map<String, dynamic> section) => [
      for (final item in section['slots'] as List? ?? const [])
        TimeSlot.fromJson(item as Map<String, dynamic>),
    ];

    return AppointmentDetails(
      title: json['title'] as String? ?? '',
      doctorName: doctor['name'] as String? ?? '',
      clinic: doctor['clinic'] as String? ?? '',
      avatarUrl: doctor['avatarUrl'] as String?,
      avatarAsset: doctor['avatarAsset'] as String?,
      canMessage: actions['message'] as bool? ?? false,
      canCall: actions['call'] as bool? ?? false,
      canVideoCall: actions['videoCall'] as bool? ?? false,
      paymentLabel: payment['label'] as String? ?? '',
      paymentFormatted: payment['formatted'] as String? ?? '',
      detailsTitle: details['title'] as String? ?? '',
      description: details['description'] as String? ?? '',
      hoursTitle: hours['title'] as String? ?? '',
      hours: slots(hours),
      dateTitle: date['title'] as String? ?? '',
      dates: slots(date),
      bookLabel: book['label'] as String? ?? '',
      bookEnabled: book['enabled'] as bool? ?? true,
    );
  }

  final String title;
  final String doctorName;
  final String clinic;
  final String? avatarUrl;
  final String? avatarAsset;
  final bool canMessage;
  final bool canCall;
  final bool canVideoCall;
  final String paymentLabel;
  final String paymentFormatted;
  final String detailsTitle;
  final String description;
  final String hoursTitle;
  final List<TimeSlot> hours;
  final String dateTitle;
  final List<TimeSlot> dates;
  final String bookLabel;
  final bool bookEnabled;

  // Aceleași detalii, dar pentru medicul ales din listă
  AppointmentDetails forDoctor(Doctor doctor) {
    return AppointmentDetails(
      title: title,
      doctorName: doctor.name,
      clinic: doctor.specialty,
      avatarUrl: doctor.avatarUrl,
      avatarAsset: doctor.avatarAsset,
      canMessage: canMessage,
      canCall: canCall,
      canVideoCall: canVideoCall,
      paymentLabel: paymentLabel,
      paymentFormatted: paymentFormatted,
      detailsTitle: detailsTitle,
      description: description,
      hoursTitle: hoursTitle,
      hours: hours,
      dateTitle: dateTitle,
      dates: dates,
      bookLabel: bookLabel,
      bookEnabled: bookEnabled,
    );
  }
}
