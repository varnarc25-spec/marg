/// API model: GET /api/banners?page_slug=…
class AppBanner {
  const AppBanner({
    required this.id,
    required this.pageSlug,
    this.title,
    this.subtitle,
    required this.imageUrl,
    this.linkUrl,
    this.flowType,
    this.actionSlug,
    this.displayOrder = 0,
  });

  final int id;
  final String pageSlug;
  final String? title;
  final String? subtitle;
  final String imageUrl;
  final String? linkUrl;
  final String? flowType;
  final String? actionSlug;
  final int displayOrder;

  static int _asInt(dynamic v, [int fallback = 0]) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? fallback;
  }

  /// Returns null if required fields are missing (caller can skip row).
  static AppBanner? tryParse(Map<String, dynamic> json) {
    try {
      final id = _asInt(json['id'], -1);
      final imageUrl = (json['image_url'] ?? '').toString().trim();
      if (id <= 0 || imageUrl.isEmpty) return null;
      return AppBanner(
        id: id,
        pageSlug: (json['page_slug'] ?? '').toString(),
        title: json['title']?.toString(),
        subtitle: json['subtitle']?.toString(),
        imageUrl: imageUrl,
        linkUrl: json['link_url']?.toString(),
        flowType: json['flow_type']?.toString(),
        actionSlug: json['action_slug']?.toString(),
        displayOrder: _asInt(json['display_order'], 0),
      );
    } catch (_) {
      return null;
    }
  }

  factory AppBanner.fromJson(Map<String, dynamic> json) {
    final parsed = tryParse(json);
    if (parsed != null) return parsed;
    throw FormatException('Invalid AppBanner json (id/image_url required)');
  }
}
