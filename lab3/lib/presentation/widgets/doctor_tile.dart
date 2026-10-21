import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/models/doctor.dart';
import 'app_image.dart';

// Un rând din lista "Nearby Doctor"
class DoctorTile extends StatelessWidget {
  const DoctorTile({
    super.key,
    required this.doctor,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final Doctor doctor;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: AppImage(
                asset: doctor.avatarAsset,
                url: doctor.avatarUrl,
                width: 48,
                height: 48,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    doctor.specialty,
                    style: const TextStyle(fontSize: 12, color: AppColors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: AppColors.teal,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          doctor.distance,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.dark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onFavoriteTap,
              tooltip: isFavorite
                  ? 'Remove from favorites'
                  : 'Add to favorites',
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
