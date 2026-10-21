import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/appointment_details.dart';
import '../models/home_data.dart';

// Citește asincron datele aplicației din fișierul JSON inclus în proiect
class MedicalRepository {
  const MedicalRepository({
    this.assetPath = 'assets/data/medical.json',
    this.delay = const Duration(milliseconds: 900),
  });

  final String assetPath;

  // Întârziere artificială, ca starea Loading să fie vizibilă
  final Duration delay;

  Future<Map<String, dynamic>> _read() async {
    await Future<void>.delayed(delay);
    final text = await rootBundle.loadString(assetPath);
    return jsonDecode(text) as Map<String, dynamic>;
  }

  Future<HomeData> loadHome() async {
    final json = await _read();
    return HomeData.fromJson(json['homeScreen'] as Map<String, dynamic>);
  }

  Future<AppointmentDetails> loadAppointmentDetails() async {
    final json = await _read();
    return AppointmentDetails.fromJson(
      json['appointmentDetails'] as Map<String, dynamic>,
    );
  }
}
