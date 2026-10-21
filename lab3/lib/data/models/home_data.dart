import 'doctor.dart';

class UserProfile {
  const UserProfile({
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
    required this.avatarAsset,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      greeting: json['greeting'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      avatarAsset: json['avatarAsset'] as String?,
    );
  }

  final String greeting;
  final String subtitle;
  final String? avatarUrl;
  final String? avatarAsset;
}

class HealthService {
  const HealthService({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.iconAsset,
  });

  factory HealthService.fromJson(Map<String, dynamic> json) {
    return HealthService(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      iconUrl: json['iconUrl'] as String?,
      iconAsset: json['iconAsset'] as String?,
    );
  }

  final String id;
  final String name;
  final String? iconUrl;
  final String? iconAsset;
}

class AppointmentSummary {
  const AppointmentSummary({
    required this.title,
    required this.date,
    required this.time,
    required this.doctor,
  });

  factory AppointmentSummary.fromJson(Map<String, dynamic> json) {
    return AppointmentSummary(
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      doctor: Doctor.fromJson(json['doctor'] as Map<String, dynamic>),
    );
  }

  final String title;
  final String date;
  final String time;
  final Doctor doctor;
}

// Tot ce afișează ecranul principal (secțiunea "homeScreen" din JSON)
class HomeData {
  const HomeData({
    required this.user,
    required this.hasUnreadNotifications,
    required this.searchHint,
    required this.appointment,
    required this.services,
    required this.doctors,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
      hasUnreadNotifications:
          (json['notifications'] as Map<String, dynamic>?)?['hasUnread']
              as bool? ??
          false,
      searchHint:
          (json['search'] as Map<String, dynamic>?)?['hint'] as String? ?? '',
      appointment: AppointmentSummary.fromJson(
        json['appointment'] as Map<String, dynamic>,
      ),
      services: [
        for (final item in json['healthServices'] as List? ?? const [])
          HealthService.fromJson(item as Map<String, dynamic>),
      ],
      doctors: [
        for (final item in json['nearbyDoctors'] as List? ?? const [])
          Doctor.fromJson(item as Map<String, dynamic>),
      ],
    );
  }

  final UserProfile user;
  final bool hasUnreadNotifications;
  final String searchHint;
  final AppointmentSummary appointment;
  final List<HealthService> services;
  final List<Doctor> doctors;
}
