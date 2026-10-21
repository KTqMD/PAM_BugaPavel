import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_colors.dart';
import '../../data/models/appointment_details.dart';
import '../../data/models/doctor.dart';
import '../../data/repositories/medical_repository.dart';
import '../../logic/appointment/appointment_cubit.dart';
import '../../logic/appointment/appointment_state.dart';
import '../widgets/app_image.dart';
import '../widgets/option_chips.dart';
import '../widgets/section_header.dart';
import '../widgets/state_views.dart';

// Pagina de detalii; își creează propriul Cubit pentru medicul primit
class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key, required this.doctor});

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppointmentCubit(context.read<MedicalRepository>())..load(doctor),
      child: _AppointmentView(doctor: doctor),
    );
  }
}

class _AppointmentView extends StatelessWidget {
  const _AppointmentView({required this.doctor});

  final Doctor doctor;

  static const _sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  void _message(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: const Text(
          'Appointment',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AppointmentCubit, AppointmentState>(
          // Mesajul de confirmare apare o singură dată, după rezervare
          listenWhen: (_, current) =>
              current is AppointmentSuccess && current.confirmation != null,
          listener: (context, state) =>
              _message(context, (state as AppointmentSuccess).confirmation!),
          builder: (context, state) {
            return switch (state) {
              AppointmentLoading() => const LoadingView(
                message: 'Loading details...',
              ),
              AppointmentError(:final message) => ErrorView(
                message: message,
                onRetry: () => context.read<AppointmentCubit>().load(doctor),
              ),
              AppointmentSuccess() => _content(context, state),
            };
          },
        ),
      ),
    );
  }

  Widget _content(BuildContext context, AppointmentSuccess state) {
    final cubit = context.read<AppointmentCubit>();
    final details = state.details;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _doctor(context, details),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(details.detailsTitle, style: _sectionTitle),
                      const SizedBox(height: 14),
                      Text(
                        details.description,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                if (details.hours.isEmpty && details.dates.isEmpty)
                  const EmptyView(message: 'No available time slots'),
                if (details.hours.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SectionHeader(
                      title: details.hoursTitle,
                      titleStyle: _sectionTitle,
                      actionLabel: state.showAllHours ? 'See Less' : 'See All',
                      actionStyle: const TextStyle(fontSize: 14),
                      onAction: cubit.toggleAllHours,
                    ),
                  ),
                  const SizedBox(height: 14),
                  OptionChips(
                    slots: details.hours,
                    selectedId: state.selectedHourId,
                    expanded: state.showAllHours,
                    onSelected: cubit.selectHour,
                  ),
                  const SizedBox(height: 24),
                ],
                if (details.dates.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SectionHeader(
                      title: details.dateTitle,
                      titleStyle: _sectionTitle,
                      actionLabel: state.showAllDates ? 'See Less' : 'See All',
                      actionStyle: const TextStyle(fontSize: 14),
                      onAction: cubit.toggleAllDates,
                    ),
                  ),
                  const SizedBox(height: 14),
                  OptionChips(
                    slots: details.dates,
                    selectedId: state.selectedDateId,
                    expanded: state.showAllDates,
                    onSelected: cubit.selectDate,
                  ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: details.bookEnabled ? cubit.book : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                details.bookLabel,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _doctor(BuildContext context, AppointmentDetails details) {
    Widget action(IconData icon, String name) {
      return GestureDetector(
        onTap: () => _message(context, '$name: ${details.doctorName}'),
        child: Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.only(left: 8),
          decoration: const BoxDecoration(
            color: Color(0xFFD8ECE8),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 17, color: Colors.black87),
        ),
      );
    }

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AppImage(
            asset: details.avatarAsset,
            url: details.avatarUrl,
            width: 130,
            height: 130,
          ),
        ),
        const SizedBox(width: 22),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      details.doctorName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (details.canMessage)
                    action(Icons.chat_bubble_outline, 'Chat'),
                  if (details.canCall) action(Icons.phone_outlined, 'Call'),
                  if (details.canVideoCall)
                    action(Icons.videocam_outlined, 'Video call'),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                details.clinic,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      details.paymentLabel,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    details.paymentFormatted,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
