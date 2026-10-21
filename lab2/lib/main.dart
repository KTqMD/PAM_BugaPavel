// Laborator - Varianta 2: aplicație medicală (Home + Appointment)
// Student: Buga Pavel

import 'package:flutter/material.dart';

import 'home_page.dart';

const kPrimary = Color(0xFF0B8FAC);
const kAccent = Color(0xFF7BC1B7);
const kDark = Color(0xFF1C1F3A);
const kGrey = Color(0xFF8A8A8E);
const kChip = Color(0xFFF3F3F3);

void main() {
  runApp(const MedicalApp());
}

class MedicalApp extends StatelessWidget {
  const MedicalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
