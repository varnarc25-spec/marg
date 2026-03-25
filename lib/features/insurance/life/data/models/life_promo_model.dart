/// Promotional banner from `GET /api/insurance/life/promos`.
class LifePromoBanner {
  const LifePromoBanner({
    this.title,
    this.subtitle,
    this.imageUrl,
    this.actionUrl,
  });

  factory LifePromoBanner.fromJson(Map<String, dynamic> json) {
    return LifePromoBanner(
      title: json['title']?.toString(),
      subtitle: json['subtitle']?.toString() ?? json['description']?.toString(),
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString(),
      actionUrl: json['actionUrl']?.toString(),
    );
  }

  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final String? actionUrl;
}
