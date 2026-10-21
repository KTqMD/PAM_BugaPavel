import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/models/home_data.dart';
import 'app_image.dart';

// Un serviciu din "Health Services"; apăsat, filtrează lista de medici
class ServiceTile extends StatelessWidget {
  const ServiceTile({
    super.key,
    required this.service,
    required this.selected,
    required this.onTap,
  });

  final HealthService service;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFDFF3F6) : AppColors.field,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: AppImage(
              asset: service.iconAsset,
              url: service.iconUrl,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
              placeholderIcon: Icons.medical_services_outlined,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            service.name,
            style: TextStyle(
              fontSize: 14,
              color: selected ? AppColors.primary : AppColors.grey,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
