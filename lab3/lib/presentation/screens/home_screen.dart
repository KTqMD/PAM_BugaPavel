import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_colors.dart';
import '../../data/models/doctor.dart';
import '../../data/models/home_data.dart';
import '../../logic/home/home_cubit.dart';
import '../../logic/home/home_state.dart';
import '../widgets/app_image.dart';
import '../widgets/appointment_card.dart';
import '../widgets/doctor_tile.dart';
import '../widgets/section_header.dart';
import '../widgets/service_tile.dart';
import '../widgets/sort_filter_sheet.dart';
import '../widgets/state_views.dart';
import 'appointment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAppointment(Doctor doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AppointmentScreen(doctor: doctor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<HomeCubit, HomeState>(
          // Când filtrele sunt resetate, golește și câmpul de căutare
          listener: (context, state) {
            if (state is HomeReady &&
                state.query != _searchController.text.trim()) {
              _searchController.text = state.query;
            }
          },
          builder: (context, state) {
            return switch (state) {
              HomeLoading() => const LoadingView(message: 'Loading doctors...'),
              HomeError(:final message) => ErrorView(
                message: message,
                onRetry: context.read<HomeCubit>().load,
              ),
              HomeReady() => _content(context, state),
            };
          },
        ),
      ),
    );
  }

  Widget _content(BuildContext context, HomeReady state) {
    final cubit = context.read<HomeCubit>();
    final data = state.data;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(data, cubit),
          const SizedBox(height: 24),
          _searchField(data.searchHint, state, cubit),
          const SizedBox(height: 24),
          AppointmentCard(
            appointment: data.appointment,
            onTap: () => _openAppointment(data.appointment.doctor),
          ),
          const SizedBox(height: 52),
          SectionHeader(
            title: 'Health Services',
            actionLabel: state.selectedServiceId == null ? 'See All' : 'Clear',
            onAction: () {
              final selected = state.selectedServiceId;
              if (selected != null) cubit.toggleService(selected);
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final service in data.services)
                ServiceTile(
                  service: service,
                  selected: service.id == state.selectedServiceId,
                  onTap: () => cubit.toggleService(service.id),
                ),
            ],
          ),
          const SizedBox(height: 28),
          SectionHeader(
            title: 'Nearby Doctor',
            actionLabel: state.hasActiveFilters ? 'Reset' : 'See All',
            onAction: cubit.clearFilters,
          ),
          if (state.sort != DoctorSort.none || state.favoritesOnly)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                [
                  if (state.sort != DoctorSort.none) state.sort.label,
                  if (state.favoritesOnly) 'Favorites only',
                ].join(' · '),
                style: const TextStyle(fontSize: 12, color: AppColors.grey),
              ),
            ),
          const SizedBox(height: 8),
          switch (state) {
            HomeEmpty() => EmptyView(
              message: 'No doctors found',
              actionLabel: 'Clear filters',
              onAction: cubit.clearFilters,
            ),
            HomeSuccess(:final doctors) => Column(
              children: [
                for (final doctor in doctors)
                  DoctorTile(
                    doctor: doctor,
                    isFavorite: state.favoriteIds.contains(doctor.id),
                    onTap: () => _openAppointment(doctor),
                    onFavoriteTap: () => cubit.toggleFavorite(doctor.id),
                  ),
              ],
            ),
          },
        ],
      ),
    );
  }

  Widget _header(HomeData data, HomeCubit cubit) {
    return Row(
      children: [
        ClipOval(
          child: AppImage(
            asset: data.user.avatarAsset,
            url: data.user.avatarUrl,
            width: 48,
            height: 48,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.user.greeting,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.user.subtitle,
                style: const TextStyle(fontSize: 11, color: AppColors.grey),
              ),
            ],
          ),
        ),
        // Apăsare lungă: simulează o eroare de încărcare (pentru demonstrație)
        GestureDetector(
          onLongPress: () => cubit.load(simulateError: true),
          child: Stack(
            children: [
              const Icon(
                Icons.notifications_none,
                size: 28,
                color: AppColors.dark,
              ),
              if (data.hasUnreadNotifications)
                Positioned(
                  right: 3,
                  top: 3,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _searchField(String hint, HomeReady state, HomeCubit cubit) {
    final filtersActive = state.sort != DoctorSort.none || state.favoritesOnly;

    return TextField(
      controller: _searchController,
      onChanged: cubit.search,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.hint, fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: AppColors.hint),
        suffixIcon: IconButton(
          onPressed: () => SortFilterSheet.show(context),
          tooltip: 'Sort and filter',
          icon: Icon(
            Icons.tune,
            color: filtersActive ? AppColors.primary : AppColors.hint,
          ),
        ),
        filled: true,
        fillColor: AppColors.field,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
