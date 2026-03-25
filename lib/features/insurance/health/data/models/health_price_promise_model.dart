/// Response from `GET /api/insurance/health/price-promise`.
class HealthPricePromise {
  const HealthPricePromise({
    required this.title,
    required this.subtitle,
    this.howItWorks,
    this.disclaimer,
  });

  factory HealthPricePromise.fromJson(Map<String, dynamic> json) {
    String pick(String a, String b, String c) =>
        (json[a] ?? json[b] ?? json[c])?.toString().trim() ?? '';

    final title = pick('title', 'heading', 'headline');
    final subtitle = pick('subtitle', 'description', 'tagline');
    final how = json['howItWorks'] ?? json['details'] ?? json['body'];
    return HealthPricePromise(
      title: title.isNotEmpty ? title : 'Lowest Price Promise',
      subtitle: subtitle.isNotEmpty
          ? subtitle
          : 'If you find a lower price, we pay the difference',
      howItWorks: how is String
          ? how
          : (how is Map
              ? how['text']?.toString() ?? how['html']?.toString()
              : null),
      disclaimer: json['disclaimer']?.toString(),
    );
  }

  final String title;
  final String subtitle;
  final String? howItWorks;
  final String? disclaimer;
}
