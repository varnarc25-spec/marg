import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/gold_silver/models/augmont_rates_models.dart';
import '../../shared/models/faq_item.dart';
import '../../shared/models/trend_item.dart';
import '../../shared/models/shop_product_item.dart';
import '../../shared/models/services_catalog.dart';
import '../../shared/models/hub_menu_item.dart';
import '../../features/home/data/models/app_banner_model.dart';
import '../../shared/models/hub_carousel_slide.dart';
import '../../shared/models/reminder_policy.dart';

/// Client for marg_api: user register and onboarding.
/// Set [baseUrl] to your API base (e.g. http://localhost:3000 or https://api.example.com).
class MargApiService {
  MargApiService({
    String? baseUrl,
    http.Client? httpClient,
  })  : _baseUrl = (baseUrl ?? _defaultBaseUrl).replaceAll(RegExp(r'/$'), ''),
        _http = httpClient ?? http.Client();

  static const String _defaultBaseUrl = 'http://localhost:3000';

  final String _baseUrl;
  final http.Client _http;

  String get baseUrl => _baseUrl;

  /// Register user in PostgreSQL after Firebase signup.
  /// [idToken] from FirebaseAuth.instance.currentUser?.getIdToken().
  Future<Map<String, dynamic>> register({
    required String idToken,
    String? name,
  }) async {
    final url = '$_baseUrl/api/user/register';
    final payload = <String, dynamic>{'idToken': idToken};
    if (name != null && name.isNotEmpty) payload['name'] = name;
    final body = jsonEncode(payload);

    http.Response res;
    try {
      res = await _http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
    } catch (_) {
      rethrow;
    }

    Object? data;
    try {
      data = jsonDecode(res.body);
    } catch (_) {
      data = res.body;
    }

    final dataMap = data is Map<String, dynamic> ? data : null;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return dataMap ?? {};
    }
    final err = dataMap?['error'];
    final message = err is Map ? (err['message'] ?? dataMap?['message']) : (err ?? dataMap?['message']);
    throw Exception(message is String ? message : 'Registration failed');
  }

  /// Ensure the user has a paper wallet (fintech app_wallets). Creates one if missing.
  /// Call after login so the user always has a wallet. Requires [idToken].
  /// Throws on 4xx/5xx so callers can log or handle (e.g. migrations not run).
  Future<Map<String, dynamic>?> ensurePaperWallet({
    required String idToken,
    String? currency,
  }) async {
    final body = <String, dynamic>{};
    if (currency != null && currency.isNotEmpty) body['currency'] = currency;
    final res = await _http.post(
      Uri.parse('$_baseUrl/api/user/paper-wallet'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode(body),
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>?;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final d = data?['data'];
      return d is Map<String, dynamic> ? d : null;
    }
    final message = data?['message'] ?? data?['error'] ?? 'Paper wallet failed (${res.statusCode})';
    throw Exception(message is String ? message : 'Paper wallet failed (${res.statusCode})');
  }

  /// Get onboarding. Pass [idToken] when logged in, or [sessionId] when anonymous.
  Future<Map<String, dynamic>?> getOnboarding({
    String? idToken,
    String? sessionId,
  }) async {
    if (idToken == null && sessionId == null) return null;
    final uri = sessionId != null
        ? Uri.parse('$_baseUrl/api/user/onboarding').replace(queryParameters: {'sessionId': sessionId})
        : Uri.parse('$_baseUrl/api/user/onboarding');
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (idToken != null) headers['Authorization'] = 'Bearer $idToken';

    final res = await _http.get(uri, headers: headers);
    final data = jsonDecode(res.body) as Map<String, dynamic>?;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final d = data?['data'];
      return d is Map<String, dynamic> ? d : null;
    }
    return null;
  }

  /// Save onboarding (create or update). Pass [idToken] when logged in, or [sessionId] when anonymous.
  Future<void> saveOnboarding({
    required Map<String, dynamic> payload,
    String? idToken,
    String? sessionId,
  }) async {
    if (idToken == null && sessionId == null) {
      throw Exception('Either idToken or sessionId is required');
    }
    if (sessionId != null) payload['sessionId'] = sessionId;

    final headers = <String, String>{'Content-Type': 'application/json'};
    if (idToken != null) headers['Authorization'] = 'Bearer $idToken';

    final res = await _http.post(
      Uri.parse('$_baseUrl/api/user/onboarding'),
      headers: headers,
      body: jsonEncode(payload),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) return;
    final data = jsonDecode(res.body) as Map<String, dynamic>?;
    final message = data?['error']?['message'] ?? data?['message'] ?? 'Failed to save onboarding';
    throw Exception(message);
  }

  /// Claim anonymous onboarding (by [sessionId]) to the logged-in user. Requires [idToken].
  Future<void> claimOnboarding({
    required String idToken,
    required String sessionId,
  }) async {
    final res = await _http.post(
      Uri.parse('$_baseUrl/api/user/onboarding/claim'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({'sessionId': sessionId}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) return;
    final data = jsonDecode(res.body) as Map<String, dynamic>?;
    final message = data?['error']?['message'] ?? data?['message'] ?? 'Failed to claim onboarding';
    throw Exception(message);
  }

  /// Get personal data for the authenticated user. Requires [idToken].
  Future<Map<String, dynamic>?> getPersonalData({required String idToken}) async {
    final res = await _http.get(
      Uri.parse('$_baseUrl/api/user/personal-data'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>?;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final d = data?['data'];
      return d is Map<String, dynamic> ? d : null;
    }
    return null;
  }

  /// Save personal data for the authenticated user. Requires [idToken].
  Future<void> savePersonalData({
    required String idToken,
    required Map<String, dynamic> payload,
  }) async {
    final res = await _http.put(
      Uri.parse('$_baseUrl/api/user/personal-data'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode(payload),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) return;
    final data = jsonDecode(res.body) as Map<String, dynamic>?;
    final message = data?['error']?['message'] ?? data?['message'] ?? 'Failed to save personal data';
    throw Exception(message);
  }

  /// Upload image for ID card OCR (PAN/Aadhaar). Works from Flutter web, Android, iOS.
  /// Image is stored on server in uploads/<userId>/ and recorded in uploads table (requires [idToken]).
  /// [imageBytes] – raw image bytes (JPEG, PNG, or WebP).
  /// [idToken] – Firebase ID token; required so the server can associate the upload with the user.
  /// Returns extracted fields: fullName, dateOfBirth, gender, address, panNumber, aadhaarNumber, rawText,
  /// and optionally upload: { id, filePath, createdAt }.
  Future<Map<String, dynamic>?> extractIdFromImage(
    List<int> imageBytes, {
    String filename = 'image.jpg',
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/ocr/id-card');
    final request = http.MultipartRequest('POST', uri);
    if (idToken != null && idToken.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $idToken';
    }
    request.files.add(http.MultipartFile.fromBytes(
      'image',
      imageBytes,
      filename: filename,
    ));
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    final data = jsonDecode(res.body) as Map<String, dynamic>?;
            if (res.statusCode >= 200 && res.statusCode < 300) {
      final d = data?['data'];
      if (d is Map<String, dynamic>) {
              }
      return d is Map<String, dynamic> ? d : null;
    }
    final message = data?['message'] ?? data?['error'] ?? 'OCR failed';
    throw Exception(message is String ? message : 'OCR failed');
  }

  /// GET /api/commodities/gold-silver — gold & silver rates in INR (gBuy, sBuy per gram).
  /// Use data.rates.gBuy and data.rates.sBuy for gold/silver INR/gm; use global only for usdPerOz.
  /// Returns { success, data: { rates: { gBuy, sBuy, gBuyGst, sBuyGst }, taxes, blockId, change }, global: { gold, silver } }.
  Future<Map<String, dynamic>?> getGoldSilverRates() async {
    final res = await _http.get(
      Uri.parse('$_baseUrl/api/commodities/gold-silver'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>?;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return data;
    }
    return null;
  }

  /// GET /api/account/augmont/rates — live gold/silver rates + blockId (for buy/sell).
  /// Requires [idToken]. Maps server's GET /rates payload into [AugmontRates].
  Future<AugmontRates?> getAugmontRates({required String idToken}) async {
    final res = await _http.get(
      Uri.parse('$_baseUrl/api/account/augmont/rates'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>?;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final d = data?['data'];
      if (d is Map<String, dynamic>) {
        return AugmontRates.fromJson(d);
      }
      return null;
    }
    return null;
  }

  /// GET /api/account/augmont/sip/rates — SIP rates (gBuy, sBuy + GST + blockId).
  Future<AugmontSipRates?> getAugmontSipRates({required String idToken}) async {
    final res = await _http.get(
      Uri.parse('$_baseUrl/api/account/augmont/sip/rates'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>?;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final d = data?['data'];
      if (d is Map<String, dynamic>) {
        return AugmontSipRates.fromJson(d);
      }
      return null;
    }
    return null;
  }

  /// GET /api/banners — dynamic promos per [pageSlug] (e.g. home, travel).
  /// No auth. Returns empty list on error or non-200.
  Future<List<AppBanner>> getBannersForPage({
    required String pageSlug,
    String variant = 'default',
  }) async {
    final uri = Uri.parse('$_baseUrl/api/banners').replace(
      queryParameters: <String, String>{
        'page_slug': pageSlug,
        if (variant.isNotEmpty) 'variant': variant,
      },
    );
    try {
      final res = await _http.get(
        uri,
        headers: const {'Content-Type': 'application/json'},
      );
      if (res.statusCode < 200 || res.statusCode >= 300) {
        return const <AppBanner>[];
      }
      final map = jsonDecode(res.body);
      if (map is! Map<String, dynamic>) return const <AppBanner>[];
      final data = map['data'];
      if (data is! List) return const <AppBanner>[];
      final out = <AppBanner>[];
      for (var i = 0; i < data.length; i++) {
        final raw = data[i];
        if (raw is! Map) continue;
        final row = Map<String, dynamic>.from(raw);
        final b = AppBanner.tryParse(row);
        if (b != null) {
          out.add(b);
        }
      }
      return out;
    } catch (_) {
      return const <AppBanner>[];
    }
  }

  /// GET /api/hub-ads-slides — hub carousel slides for [section] (e.g. recharges-bills).
  /// Optional [category] for category-level carousels; [menuItem] for item-level slides.
  /// Returns empty on error; caller may fall back to local samples.
  Future<List<HubCarouselSlide>> getHubAdsSlides({
    required String section,
    String? category,
    String? menuItem,
  }) async {
    final qp = <String, String>{'section': section};
    final c = category?.trim();
    if (c != null && c.isNotEmpty) {
      qp['category'] = c;
    }
    final m = menuItem?.trim();
    if (m != null && m.isNotEmpty) {
      qp['menu_item'] = m;
    }
    final uri = Uri.parse('$_baseUrl/api/hub-ads-slides').replace(
      queryParameters: qp,
    );
    try {
      final res = await _http.get(
        uri,
        headers: const {'Content-Type': 'application/json'},
      );
      if (res.statusCode < 200 || res.statusCode >= 300) {
        return const <HubCarouselSlide>[];
      }
      final decoded = jsonDecode(res.body);
      if (decoded is! Map) {
        return const <HubCarouselSlide>[];
      }
      final map = Map<String, dynamic>.from(decoded);
      final dynamic data = map['data'];
      List<HubCarouselSlide> slides = const [];

      if (data is Map) {
        slides = HubCarouselResponse.parseSlides(
          Map<String, dynamic>.from(data),
        );
      } else if (data is List) {
        slides = HubCarouselResponse.parseSlides(data);
      }
      if (slides.isEmpty && map['slides'] is List) {
        slides = HubCarouselResponse.parseSlides(map['slides']);
      }

      return slides;
    } catch (_) {
      return const <HubCarouselSlide>[];
    }
  }

  /// GET /api/reminders/policy?menu_item_slug=...&channel=...
  ///
  /// Returns `null` on error (network/server/parsing/auth).
  Future<ReminderPolicyDecision?> getReminderPolicyDecision({
    required String idToken,
    required String menuItemSlug,
    required String channel,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/reminders/policy').replace(
      queryParameters: <String, String>{
        'menu_item_slug': menuItemSlug,
        'channel': channel,
      },
    );

    try {
      final res = await _http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
      );
      if (res.statusCode < 200 || res.statusCode >= 300) return null;

      final decoded = jsonDecode(res.body);
      if (decoded is! Map) return null;
      final map = Map<String, dynamic>.from(decoded);
      final data = map['data'];
      if (data is! Map<String, dynamic>) return null;
      return ReminderPolicyDecision.fromJson(Map<String, dynamic>.from(data));
    } catch (_) {
      return null;
    }
  }

  /// POST /api/reminders/consent
  ///
  /// Body:
  /// `{ menu_item_slug, channel, consent: true|false, policy_version? }`
  ///
  /// Throws on non-2xx so callers can show UX feedback.
  Future<void> postReminderConsent({
    required String idToken,
    required String menuItemSlug,
    required String channel,
    required bool consent,
    int? policyVersion,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/reminders/consent');
    final payload = <String, dynamic>{
      'menu_item_slug': menuItemSlug,
      'channel': channel,
      'consent': consent,
      if (policyVersion != null) 'policy_version': policyVersion,
    };

    final res = await _http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode(payload),
    );

    if (res.statusCode >= 200 && res.statusCode < 300) return;
    final decoded = jsonDecode(res.body) as Map<String, dynamic>?;
    final message = decoded?['message'] ??
        decoded?['error']?['message'] ??
        decoded?['error'] ??
        'Consent failed (${res.statusCode})';
    throw Exception(message is String ? message : 'Consent failed');
  }

  /// GET /api/services/catalog — services catalog for home (suggested + categories).
  /// No auth required. Returns [ServicesCatalog] or null on error.
  Future<ServicesCatalog?> getServicesCatalog() async {
    final res = await _http.get(
      Uri.parse('$_baseUrl/api/services/catalog'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>?;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final d = data?['data'];
      if (d is Map<String, dynamic>) {
        return ServicesCatalog.fromJson(d);
      }
      return null;
    }
    return null;
  }

  /// GET /api/services/menu-items?section_slug= — menu rows for a hub section.
  /// Returns null on error or empty payload.
  Future<MenuItemsBySection?> getMenuItemsBySection({
    required String sectionSlug,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/services/menu-items').replace(
      queryParameters: <String, String>{'section_slug': sectionSlug.trim()},
    );
    try {
      final res = await _http.get(
        uri,
        headers: const {'Content-Type': 'application/json'},
      );
      if (res.statusCode < 200 || res.statusCode >= 300) {
        return null;
      }
      final decoded = jsonDecode(res.body);
      if (decoded is! Map) return null;
      final map = Map<String, dynamic>.from(decoded);
      final dynamic data = map['data'];
      if (data is! Map) return null;
      return MenuItemsBySection.fromJson(Map<String, dynamic>.from(data));
    } catch (_) {
      return null;
    }
  }

  /// Mock FAQ JSON for different sections (gold_buy, silver_buy, etc.).
  /// In future this can call a real backend endpoint instead.
  static const String _faqMockJson = '''
{
  "gold_buy": [
    {
      "question": "What is Digital Gold?",
      "answer": "Digital gold lets you buy and hold gold online in small amounts with 24K 99.9% purity backing."
    },
    {
      "question": "Can I convert my gold to coins or jewellery?",
      "answer": "Yes, you can convert accumulated digital gold into coins or jewellery through supported partners."
    },
    {
      "question": "Is my gold stored safely?",
      "answer": "Your gold is stored in insured, secure vaults with the custodian appointed by the provider."
    },
    {
      "question": "What are the minimum and maximum buy limits?",
      "answer": "Minimum purchase is usually ₹1; maximum limits depend on KYC and provider policies."
    },
    {
      "question": "How is the buy price decided?",
      "answer": "Buy price is linked to live wholesale market rates plus applicable taxes and platform charges."
    },
    {
      "question": "Can I sell my digital gold anytime?",
      "answer": "You can typically sell your digital gold 24x7 at the prevailing live sell price, subject to liquidity windows."
    },
    {
      "question": "Do I need full KYC to buy?",
      "answer": "You can start with basic KYC for small amounts; full KYC may be required for higher limits and redemptions."
    },
    {
      "question": "Are there any hidden charges?",
      "answer": "All charges like GST and spread are shown upfront in the buy price; there are no hidden fees."
    }
  ]
}
''';

  /// Get FAQs for a given [section] (e.g. 'gold_buy') using mock JSON.
  Future<List<FaqItem>> getFaqs({required String section}) async {
    final decoded = jsonDecode(_faqMockJson) as Map<String, dynamic>;
    final list = decoded[section];
    if (list is List) {
      return list
          .whereType<Map>()
          .map((e) => FaqItem.fromJson(e.cast<String, dynamic>()))
          .toList();
    }
    return const <FaqItem>[];
  }

  /// Mock trends JSON for different sections (gold_buy, silver_buy, etc.).
  /// Each item has a title and contentType (article, guide, video, etc.).
  static const String _trendsMockJson = '''
{
  "gold_buy": [
    {
      "title": "Digital Gold is for all financial goals",
      "contentType": "article"
    },
    {
      "title": "Top 5 benefits of investing in Digital Gold",
      "contentType": "article"
    },
    {
      "title": "How to grow your gold with Digital Gold SIP?",
      "contentType": "guide"
    },
    {
      "title": "Is Digital Gold safe compared to physical gold?",
      "contentType": "article"
    },
    {
      "title": "What taxes apply on Digital Gold?",
      "contentType": "faq"
    }
  ]
}
''';

  /// Get trends for a given [section] (e.g. 'gold_buy'). Optionally filter by [contentType].
  Future<List<TrendItem>> getTrends({
    required String section,
    String? contentType,
  }) async {
    final decoded = jsonDecode(_trendsMockJson) as Map<String, dynamic>;
    final list = decoded[section];
    if (list is List) {
      var items = list
          .whereType<Map>()
          .map((e) => TrendItem.fromJson(e.cast<String, dynamic>()))
          .toList();
      if (contentType != null && contentType.isNotEmpty) {
        items = items
            .where((t) => t.contentType.toLowerCase() == contentType.toLowerCase())
            .toList();
      }
      return items;
    }
    return const <TrendItem>[];
  }

  /// Mock shop products JSON for different sections (gold_buy, silver_buy, etc.).
  static const String _shopProductsMockJson = '''
{
  "gold_buy": [
    {
      "title": "Link Chain",
      "meta": "7.0gms | 22K",
      "price": "\u20b91,05,355.47"
    },
    {
      "title": "Ring",
      "meta": "5.0gms | 22K",
      "price": "\u20b975,137.23"
    }
  ]
}
''';

  /// Get shop products for a given [section] using mock JSON.
  Future<List<ShopProductItem>> getShopProducts({required String section}) async {
    final decoded = jsonDecode(_shopProductsMockJson) as Map<String, dynamic>;
    final list = decoded[section];
    if (list is List) {
      return list
          .whereType<Map>()
          .map((e) => ShopProductItem.fromJson(e.cast<String, dynamic>()))
          .toList();
    }
    return const <ShopProductItem>[];
  }
}
