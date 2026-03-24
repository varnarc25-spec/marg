/// Row from `GET /api/insurance/life/partners`.
class LifePartner {
  const LifePartner({
    required this.id,
    required this.name,
    this.code,
    this.logoUrl,
  });

  factory LifePartner.fromJson(Map<String, dynamic> json) {
    return LifePartner(
      id: json['id']?.toString().trim() ?? '',
      name: json['name']?.toString().trim() ?? '',
      code: json['code']?.toString().trim(),
      logoUrl: json['logoUrl']?.toString().trim(),
    );
  }

  final String id;
  final String name;
  final String? code;
  final String? logoUrl;
}
