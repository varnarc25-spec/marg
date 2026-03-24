/// Partner row from `GET /api/insurance/health/partners`.
class HealthPartner {
  const HealthPartner({
    required this.id,
    required this.name,
    required this.code,
    this.logoUrl,
  });

  factory HealthPartner.fromJson(Map<String, dynamic> json) {
    return HealthPartner(
      id: json['id']?.toString().trim() ?? '',
      name: json['name']?.toString().trim() ?? '',
      code: json['code']?.toString().trim() ?? '',
      logoUrl: json['logoUrl']?.toString().trim(),
    );
  }

  final String id;
  final String name;
  final String code;
  final String? logoUrl;
}
