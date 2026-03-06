import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:http/http.dart' as http;

/// Client for marg_api: user register and onboarding.
/// Set [baseUrl] to your API base (e.g. http://localhost:3000 or https://api.example.com).
class MargApiService {
  MargApiService({String? baseUrl}) : _baseUrl = (baseUrl ?? _defaultBaseUrl).replaceAll(RegExp(r'/$'), '');

  static const String _defaultBaseUrl = 'http://localhost:3000';

  final String _baseUrl;

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

    debugPrint('MargApi REGISTER │ POST $url');
    debugPrint('MargApi REGISTER │ Payload: name=${name ?? "(none)"}, idToken.length=${idToken.length}');
    // Copy token from terminal to test in Postman (debug only)
    if (kDebugMode) {
      debugPrint('MargApi REGISTER │ --- idToken for Postman (copy next line) ---');
      debugPrint(idToken);
      debugPrint('MargApi REGISTER │ --- end idToken ---');
    }

    http.Response res;
    try {
      res = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
    } catch (e, st) {
      debugPrint('MargApi REGISTER │ Request threw: $e');
      debugPrint('MargApi REGISTER │ Full stack trace:');
      for (final line in st.toString().split('\n')) {
        if (line.isNotEmpty) debugPrint('MargApi REGISTER │   $line');
      }
      rethrow;
    }

    Object? data;
    try {
      data = jsonDecode(res.body);
    } catch (_) {
      data = res.body;
    }
    debugPrint('MargApi REGISTER │ Response: statusCode=${res.statusCode}');
    debugPrint('MargApi REGISTER │ Response body: $data');

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
    final res = await http.post(
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

    final res = await http.get(uri, headers: headers);
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

    final res = await http.post(
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
    final res = await http.post(
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
    final res = await http.get(
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
    final res = await http.put(
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
    debugPrint('MargApi OCR │ statusCode=${res.statusCode}');
    debugPrint('MargApi OCR │ response: $data');
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final d = data?['data'];
      if (d is Map<String, dynamic>) {
        debugPrint('MargApi OCR │ data: $d');
      }
      return d is Map<String, dynamic> ? d : null;
    }
    final message = data?['message'] ?? data?['error'] ?? 'OCR failed';
    throw Exception(message is String ? message : 'OCR failed');
  }
}
