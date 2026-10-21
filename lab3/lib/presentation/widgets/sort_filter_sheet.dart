import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_colors.dart';
import '../../logic/home/home_cubit.dart';
import '../../logic/home/home_state.dart';

// Panoul deschis din iconița de filtre: sortare și "doar favorite"
class SortFilterSheet extends StatelessWidget {
  const SortFilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const SortFilterSheet()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is! HomeReady) return const SizedBox.shrink();
        final cubit = context.read<HomeCubit>();

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Sort doctors',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.dark,
                    ),
                  ),
                ),
                RadioGroup<DoctorSort>(
                  groupValue: state.sort,
                  onChanged: (sort) => cubit.setSort(sort!),
                  child: Column(
                    children: [
                      for (final sort in DoctorSort.values)
                        RadioListTile<DoctorSort>(
                          value: sort,
                          title: Text(sort.label),
                          dense: true,
                        ),
                    ],
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  value: state.favoritesOnly,
                  onChanged: cubit.setFavoritesOnly,
                  title: const Text('Favorites only'),
                  activeThumbColor: AppColors.primary,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: cubit.clearFilters,
                        child: const Text('Reset'),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
