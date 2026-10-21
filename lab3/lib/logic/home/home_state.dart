import '../../data/models/doctor.dart';
import '../../data/models/home_data.dart';

enum DoctorSort {
  none('Default order'),
  nameAsc('Name A - Z'),
  nameDesc('Name Z - A'),
  nearest('Nearest first');

  const DoctorSort(this.label);

  final String label;
}

sealed class HomeState {
  const HomeState();
}

// Datele se încarcă din JSON
class HomeLoading extends HomeState {
  const HomeLoading();
}

// Încărcarea a eșuat
class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;
}

// Datele sunt încărcate; ține și căutarea, filtrele și sortarea curente
sealed class HomeReady extends HomeState {
  const HomeReady({
    required this.data,
    required this.query,
    required this.selectedServiceId,
    required this.sort,
    required this.favoritesOnly,
    required this.favoriteIds,
  });

  final HomeData data;
  final String query;
  final String? selectedServiceId;
  final DoctorSort sort;
  final bool favoritesOnly;
  final Set<String> favoriteIds;

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      selectedServiceId != null ||
      favoritesOnly ||
      sort != DoctorSort.none;
}

// Există medici de afișat
class HomeSuccess extends HomeReady {
  const HomeSuccess({
    required super.data,
    required super.query,
    required super.selectedServiceId,
    required super.sort,
    required super.favoritesOnly,
    required super.favoriteIds,
    required this.doctors,
  });

  // Lista după căutare, filtrare și sortare
  final List<Doctor> doctors;
}

// Niciun medic nu corespunde căutării sau filtrelor
class HomeEmpty extends HomeReady {
  const HomeEmpty({
    required super.data,
    required super.query,
    required super.selectedServiceId,
    required super.sort,
    required super.favoritesOnly,
    required super.favoriteIds,
  });
}
