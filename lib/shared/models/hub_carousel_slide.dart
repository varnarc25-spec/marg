import 'dart:convert';
import 'dart:ui';

/// One slide in a hub promo carousel (shape matches API / JSON).
class HubCarouselSlide {
  const HubCarouselSlide({
    required this.title,
    this.subtitle,
    this.gradientColors,
    this.icon,
    this.image,
    this.section,
    this.category,
    this.menuItem,
    this.buttonText,
    this.buttonLink,
    this.buttonFlowType,
    this.buttonActionSlug,
  });

  final String title;
  final String? subtitle;
  /// Hex strings with optional `#`, e.g. `["#1565C0", "#1976D2"]`.
  final List<String>? gradientColors;
  /// Small image URL (e.g. badge) shown above the title in the hub carousel.
  final String? icon;
  /// Background / hero image URL under the gradient overlay.
  final String? image;
  /// Hub key from API (e.g. `recharges-bills`); optional on client-only slides.
  final String? section;
  /// Optional sub-target within [section].
  final String? category;

  /// Optional service / menu item slug (item-level carousel).
  final String? menuItem;

  /// Optional CTA label; when null/empty, no button is shown.
  final String? buttonText;

  /// URL opened when the CTA is tapped (optional; external — checked before in-app fields).
  final String? buttonLink;

  /// In-app flow key (e.g. `recharge_flow`) — same idea as app banner [AppBanner.flowType].
  final String? buttonFlowType;

  /// In-app service slug — same idea as app banner [AppBanner.actionSlug].
  final String? buttonActionSlug;

  /// True when the app should render a call-to-action control.
  bool get showsButton {
    final t = buttonText?.trim();
    return t != null && t.isNotEmpty;
  }

  /// True when the CTA can do something: external link, flow, or service slug.
  bool get hasCtaTarget {
    final l = buttonLink?.trim();
    if (l != null && l.isNotEmpty) return true;
    final f = buttonFlowType?.trim();
    if (f != null && f.isNotEmpty) return true;
    final s = buttonActionSlug?.trim();
    return s != null && s.isNotEmpty;
  }

  factory HubCarouselSlide.fromJson(Map<String, dynamic> json) {
    final imageStr = (json['image'] as String?)?.trim();
    final legacyImage = (json['imageUrl'] as String?)?.trim();
    final gradRaw = json['gradientColors'] ?? json['gradient_colors'];
    List<String>? gradients;
    if (gradRaw is List) {
      gradients = gradRaw
          .map((e) => e.toString())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return HubCarouselSlide(
      title: (json['title'] as String?)?.trim() ?? '',
      subtitle: (json['subtitle'] as String?)?.trim(),
      gradientColors: gradients,
      icon: (json['icon'] as String?)?.trim(),
      image: (imageStr != null && imageStr.isNotEmpty)
          ? imageStr
          : (legacyImage != null && legacyImage.isNotEmpty ? legacyImage : null),
      section: (json['section'] as String?)?.trim(),
      category: (json['category'] as String?)?.trim(),
      menuItem: (json['menuItem'] as String?)?.trim() ??
          (json['menu_item'] as String?)?.trim(),
      buttonText: (json['buttonText'] as String?)?.trim() ??
          (json['button_text'] as String?)?.trim(),
      buttonLink: (json['buttonLink'] as String?)?.trim() ??
          (json['button_link'] as String?)?.trim(),
      buttonFlowType: (json['buttonFlowType'] as String?)?.trim() ??
          (json['button_flow_type'] as String?)?.trim() ??
          (json['flow_type'] as String?)?.trim(),
      buttonActionSlug: (json['buttonActionSlug'] as String?)?.trim() ??
          (json['button_action_slug'] as String?)?.trim() ??
          (json['action_slug'] as String?)?.trim(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        if (subtitle != null) 'subtitle': subtitle,
        if (gradientColors != null) 'gradientColors': gradientColors,
        if (icon != null) 'icon': icon,
        if (image != null) 'image': image,
        if (section != null) 'section': section,
        if (category != null) 'category': category,
        if (menuItem != null) 'menuItem': menuItem,
        if (buttonText != null) 'buttonText': buttonText,
        if (buttonLink != null) 'buttonLink': buttonLink,
        if (buttonFlowType != null) 'buttonFlowType': buttonFlowType,
        if (buttonActionSlug != null) 'buttonActionSlug': buttonActionSlug,
      };

  bool get isEmpty => title.isEmpty;
}

/// API wrapper: `{ "slides": [ ... ] }` (or `banners` / `items` as aliases).
class HubCarouselResponse {
  const HubCarouselResponse({required this.slides});

  final List<HubCarouselSlide> slides;

  factory HubCarouselResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['slides'] ?? json['banners'] ?? json['items'];
    if (raw is! List) {
      return const HubCarouselResponse(slides: []);
    }
    final slides = raw
        .whereType<Map<String, dynamic>>()
        .map(HubCarouselSlide.fromJson)
        .where((s) => !s.isEmpty)
        .toList();
    return HubCarouselResponse(slides: slides);
  }

  /// Root may be a map with `slides` or a raw list of slide objects.
  static List<HubCarouselSlide> parseSlides(dynamic json) {
    if (json == null) return [];
    if (json is List) {
      return json
          .whereType<Map<String, dynamic>>()
          .map(HubCarouselSlide.fromJson)
          .where((s) => !s.isEmpty)
          .toList();
    }
    if (json is Map<String, dynamic>) {
      return HubCarouselResponse.fromJson(json).slides;
    }
    return [];
  }

  static List<HubCarouselSlide> parseSlidesFromJsonString(String source) {
    if (source.trim().isEmpty) return [];
    final decoded = jsonDecode(source);
    return parseSlides(decoded);
  }
}

Color hubCarouselParseHexColor(String hex) {
  var s = hex.trim();
  if (s.startsWith('#')) s = s.substring(1);
  if (s.length == 6) s = 'FF$s';
  if (s.length != 8) return const Color(0xFF1565C0);
  return Color(int.tryParse(s, radix: 16) ?? 0xFF1565C0);
}

/// Sample payload matching [assets/data/sample_hub_carousel.json].
/// Swap for [HubCarouselResponse.parseSlides] / [parseSlidesFromJsonString] with your API body.
class HubCarouselSample {
  HubCarouselSample._();

  static final List<HubCarouselSlide> slides =
      HubCarouselResponse.parseSlidesFromJsonString(_kJson);

  static const String _kJson = r'''
{
  "slides": [
    {
      "title": "Special offers this week",
      "subtitle": "Limited time deals",
      "section": "recharges-bills",
      "category": "",
      "icon": "https://cdn-icons-png.flaticon.com/512/2331/2331966.png",
      "gradientColors": ["#1565C0", "#1976D2", "#1E88E5"],
      "buttonText": "Recharge Now",
      "buttonFlowType": "recharge_flow"
    },
    {
      "title": "Save more on recharges",
      "section": "recharges-bills",
      "image": "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800&q=80",
      "gradientColors": ["#2E7D32", "#388E3C", "#43A047"]
    },
    {
      "title": "Exclusive deals for you",
      "section": "recharges-bills",
      "gradientColors": ["#6A1B9A", "#7B1FA2", "#8E24AA"]
    }
  ]
}
''';
}
