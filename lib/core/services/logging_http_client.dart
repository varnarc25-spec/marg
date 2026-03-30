import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

/// An `http.BaseClient` wrapper that logs every request/response.
///
/// Notes:
/// - Logs response body only (truncated).
/// - Avoids logging request headers/body to reduce risk of leaking secrets.
class LoggingHttpClient extends http.BaseClient {
  LoggingHttpClient({http.Client? inner, this.maxBodyChars = 2000})
    : _inner = inner ?? http.Client();

  final http.Client _inner;
  final int maxBodyChars;

  /// Serialize file writes so concurrent HTTP calls don't interleave.
  Future<void> _writeQueue = Future.value();
  Directory? _logsDir;
  bool _logsDirResolved = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final startedAt = DateTime.now();
    final requestLine = 'HTTP -> ${request.method} ${request.url}';

    final streamedResponse = await _inner.send(request);

    // Read the full body so we can log it and still return a usable stream.
    final bytes = await streamedResponse.stream.toBytes();
    final elapsedMs = DateTime.now().difference(startedAt).inMilliseconds;

    final bodyText = _decodeBody(bytes);
    final preview = bodyText == null
        ? '<non-text response>'
        : _truncate(bodyText);

    final responseLine =
        'HTTP <- ${streamedResponse.statusCode} (${elapsedMs}ms) ${request.method} ${request.url}';
    final bodyLine = 'HTTP body: $preview';

    await _appendDailyLog('$requestLine\n$responseLine\n$bodyLine');

    return http.StreamedResponse(
      Stream.value(bytes),
      streamedResponse.statusCode,
      contentLength: bytes.length,
      headers: streamedResponse.headers,
      reasonPhrase: streamedResponse.reasonPhrase,
      request: request,
      isRedirect: streamedResponse.isRedirect,
    );
  }

  String? _decodeBody(List<int> bytes) {
    if (bytes.isEmpty) return '';
    try {
      return utf8.decode(bytes, allowMalformed: true);
    } catch (_) {
      return null;
    }
  }

  String _truncate(String s) {
    if (s.length <= maxBodyChars) return s;
    final shown = s.substring(0, maxBodyChars);
    final remaining = s.length - maxBodyChars;
    return '$shown... [truncated $remaining chars]';
  }

  Future<void> _appendDailyLog(String message) async {
    if (kIsWeb) return;

    final logsDir = await _getOrCreateLogsDir();
    if (logsDir == null) return;

    final dateSuffix = _dateSuffix(DateTime.now());
    final file = File('${logsDir.path}/api_http_$dateSuffix.log');

    // Append one block per request (fewer writes, keeps entries intact).
    _writeQueue = _writeQueue.then((_) async {
      await file.writeAsString(
        '$message\n',
        mode: FileMode.append,
        flush: true,
      );
    });

    await _writeQueue;
  }

  Future<Directory?> _getOrCreateLogsDir() async {
    if (_logsDirResolved) return _logsDir;
    _logsDirResolved = true;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${appDir.path}/logs');
      await logsDir.create(recursive: true);
      _logsDir = logsDir;
      return _logsDir;
    } catch (_) {
      // If we can't resolve a writable directory, don't crash the app.
      return null;
    }
  }

  String _dateSuffix(DateTime now) {
    final y = now.year.toString();
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  void close() {
    _inner.close();
  }
}
