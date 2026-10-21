// Laborator 3 - Varianta 2: aplicație medicală
// State management cu Cubit (flutter_bloc), date încărcate asincron din JSON
// Student: Buga Pavel

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app_colors.dart';
import 'data/repositories/medical_repository.dart';
import 'logic/home/home_cubit.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const MedicalApp());
}

class MedicalApp extends StatelessWidget {
  const MedicalApp({super.key, this.repository = const MedicalRepository()});

  final MedicalRepository repository;

  @override
  Widget build(BuildContext context) {
    // Repository-ul și Cubit-ul ecranului principal sunt disponibile în toată
    // aplicația
    return RepositoryProvider.value(
      value: repository,
      child: BlocProvider(
        create: (_) => HomeCubit(repository)..load(),
        child: MaterialApp(
          title: 'Medical App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
