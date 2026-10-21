import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/models/appointment_details.dart';

// Opțiuni selectabile (ore sau zile): listă orizontală sau, extins, pe rânduri
class OptionChips extends StatelessWidget {
  const OptionChips({
    super.key,
    required this.slots,
    required this.selectedId,
    required this.expanded,
    required this.onSelected,
  });

  final List<TimeSlot> slots;
  final String? selectedId;
  final bool expanded;
  final ValueChanged<String> onSelected;

  Widget _chip(TimeSlot slot) {
    final active = slot.id == selectedId;
    return GestureDetector(
      onTap: () => onSelected(slot.id),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.chip,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              slot.label,
              style: TextStyle(
                fontSize: 18,
                color: active ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [for (final slot in slots) _chip(slot)],
        ),
      );
    }

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: slots.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, i) => _chip(slots[i]),
      ),
    );
  }
}
