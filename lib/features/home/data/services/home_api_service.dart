import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../models/home_response_model.dart';

class HomeApiService {
  HomeApiService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = (baseUrl ?? ApiConfig.baseUrl).replaceAll(RegExp(r'/$'), '');

  final http.Client _client;
  final String _baseUrl;

  Future<HomeResponseModel> getHome() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/app-data/page/homescreen1'),
      headers: const {'Content-Type': 'application/json'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load home: ${response.statusCode}');
    }

    final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
    return HomeResponseModel.fromJson(jsonMap);
  }
}
