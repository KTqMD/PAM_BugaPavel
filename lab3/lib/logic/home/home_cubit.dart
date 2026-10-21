import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/home_data.dart';
import '../../data/repositories/medical_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeLoading());

  final MedicalRepository _repository;

  HomeData? _data;
  String _query = '';
  String? _serviceId;
  DoctorSort _sort = DoctorSort.none;
  bool _favoritesOnly = false;
  Set<String> _favoriteIds = {};

  // simulateError există doar pentru a demonstra starea Error
  Future<void> load({bool simulateError = false}) async {
    emit(const HomeLoading());
    try {
      if (simulateError) {
        await Future<void>.delayed(const Duration(milliseconds: 600));
        throw Exception('Simulated loading error');
      }

      final data = await _repository.loadHome();
      _data = data;
      _favoriteIds = {
        for (final doctor in data.doctors)
          if (doctor.isFavorite) doctor.id,
      };
      _emitReady();
    } catch (error) {
      emit(HomeError('Could not load data.\n$error'));
    }
  }

  void search(String query) {
    _query = query.trim();
    _emitReady();
  }

  // A doua apăsare pe același serviciu scoate filtrul
  void toggleService(String serviceId) {
    _serviceId = _serviceId == serviceId ? null : serviceId;
    _emitReady();
  }

  void setSort(DoctorSort sort) {
    _sort = sort;
    _emitReady();
  }

  void setFavoritesOnly(bool value) {
    _favoritesOnly = value;
    _emitReady();
  }

  void toggleFavorite(String doctorId) {
    _favoriteIds = {..._favoriteIds};
    if (!_favoriteIds.remove(doctorId)) _favoriteIds.add(doctorId);
    _emitReady();
  }

  void clearFilters() {
    _query = '';
    _serviceId = null;
    _sort = DoctorSort.none;
    _favoritesOnly = false;
    _emitReady();
  }

  // Aplică pe rând căutarea, filtrele și sortarea, apoi emite starea
  void _emitReady() {
    final data = _data;
    if (data == null) return;

    final text = _query.toLowerCase();
    final doctors = data.doctors.where((doctor) {
      final matchesText =
          text.isEmpty ||
          doctor.name.toLowerCase().contains(text) ||
          doctor.specialty.toLowerCase().contains(text);
      final matchesService =
          _serviceId == null || doctor.serviceIds.contains(_serviceId);
      final matchesFavorite =
          !_favoritesOnly || _favoriteIds.contains(doctor.id);
      return matchesText && matchesService && matchesFavorite;
    }).toList();

    switch (_sort) {
      case DoctorSort.none:
        break;
      case DoctorSort.nameAsc:
        doctors.sort((a, b) => a.name.compareTo(b.name));
      case DoctorSort.nameDesc:
        doctors.sort((a, b) => b.name.compareTo(a.name));
      case DoctorSort.nearest:
        doctors.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    }

    if (doctors.isEmpty) {
      emit(
        HomeEmpty(
          data: data,
          query: _query,
          selectedServiceId: _serviceId,
          sort: _sort,
          favoritesOnly: _favoritesOnly,
          favoriteIds: _favoriteIds,
        ),
      );
    } else {
      emit(
        HomeSuccess(
          data: data,
          query: _query,
          selectedServiceId: _serviceId,
          sort: _sort,
          favoritesOnly: _favoritesOnly,
          favoriteIds: _favoriteIds,
          doctors: doctors,
        ),
      );
    }
  }
}
