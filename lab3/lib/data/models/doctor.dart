class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.distance,
    required this.avatarUrl,
    required this.avatarAsset,
    required this.serviceIds,
    required this.isFavorite,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      distance: json['distance'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      avatarAsset: json['avatarAsset'] as String?,
      serviceIds: [...?(json['serviceIds'] as List?)?.cast<String>()],
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  final String id;
  final String name;
  final String specialty;

  // Text de forma "3167 Durgan Shores - 500M from you"
  final String distance;
  final String? avatarUrl;
  final String? avatarAsset;

  // Serviciile din "Health Services" la care apare medicul
  final List<String> serviceIds;
  final bool isFavorite;

  // Distanța în metri, extrasă din text; folosită la sortare
  double get distanceMeters {
    final match = RegExp(
      r'(\d+(?:\.\d+)?)\s*(KM|M)\s+from you',
      caseSensitive: false,
    ).firstMatch(distance);
    if (match == null) return double.infinity;

    final value = double.parse(match.group(1)!);
    return match.group(2)!.toUpperCase() == 'KM' ? value * 1000 : value;
  }
}
