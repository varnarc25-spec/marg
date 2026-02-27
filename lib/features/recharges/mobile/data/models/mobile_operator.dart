/// Mobile operator model for recharge flow.
/// TODO: Replace with API model when BBPS/recharge API is integrated.
class MobileOperator {
  final String id;
  final String name;
  final String logoUrl;
  final String circle;

  const MobileOperator({
    required this.id,
    required this.name,
    this.logoUrl = '',
    this.circle = 'All India',
  });

  factory MobileOperator.fromJson(Map<String, dynamic> json) {
    return MobileOperator(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      circle: json['circle'] as String? ?? 'All India',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'logoUrl': logoUrl,
        'circle': circle,
      };
}
