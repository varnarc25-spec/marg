import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_theme.dart';

/// Marg app logo (SVG asset). When [networkUrl] is set (from `GET /api/app-settings`),
/// it supports both SVG and bitmap URLs (including extensionless GCS URLs).
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 28,
    this.color,
    this.networkUrl,
  });

  final double size;
  final Color? color;
  final String? networkUrl;

  bool get _looksLikeSvg {
    final u = networkUrl?.toLowerCase().trim() ?? '';
    return u.contains('.svg');
  }

  @override
  Widget build(BuildContext context) {
    final url = networkUrl?.trim();
    if (url != null && url.isNotEmpty) {
      return _NetworkLogo(
        url: url,
        size: size,
        color: color,
        preferSvg: _looksLikeSvg,
      );
    }
    return _AssetLogo(size: size, color: color);
  }
}

class _NetworkLogo extends StatefulWidget {
  const _NetworkLogo({
    required this.url,
    required this.size,
    required this.color,
    required this.preferSvg,
  });

  final String url;
  final double size;
  final Color? color;
  final bool preferSvg;

  @override
  State<_NetworkLogo> createState() => _NetworkLogoState();
}

class _NetworkLogoState extends State<_NetworkLogo> {
  late Future<_RemoteLogoData> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadLogo(widget.url, preferSvg: widget.preferSvg);
  }

  @override
  void didUpdateWidget(covariant _NetworkLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url || oldWidget.preferSvg != widget.preferSvg) {
      _future = _loadLogo(widget.url, preferSvg: widget.preferSvg);
    }
  }

  Future<_RemoteLogoData> _loadLogo(String url, {required bool preferSvg}) async {
    final res = await http.get(Uri.parse(url), headers: const {'Accept': 'image/*,*/*'});
    if (res.statusCode < 200 || res.statusCode >= 300 || res.bodyBytes.isEmpty) {
      throw Exception('Failed to fetch logo');
    }
    final bytes = res.bodyBytes;
    final type = (res.headers['content-type'] ?? '').toLowerCase();
    final snippet = utf8.decode(bytes.take(96).toList(), allowMalformed: true).trimLeft();
    final isSvg = type.contains('image/svg') || snippet.startsWith('<svg') || snippet.startsWith('<?xml');
    return _RemoteLogoData(
      bytes: bytes,
      isSvg: isSvg || (preferSvg && !type.contains('image/')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_RemoteLogoData>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: Center(
              child: SizedBox(
                width: widget.size * 0.45,
                height: widget.size * 0.45,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        if (snap.hasError || !snap.hasData) {
          return _AssetLogo(size: widget.size, color: widget.color);
        }
        final data = snap.data!;
        if (data.isSvg) {
          return SvgPicture.memory(
            data.bytes,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.contain,
            placeholderBuilder: (_) => _AssetLogo(size: widget.size, color: widget.color),
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.memory(
            data.bytes,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _AssetLogo(size: widget.size, color: widget.color),
          ),
        );
      },
    );
  }
}

class _RemoteLogoData {
  const _RemoteLogoData({required this.bytes, required this.isSvg});
  final Uint8List bytes;
  final bool isSvg;
}

class _AssetLogo extends StatelessWidget {
  const _AssetLogo({required this.size, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.appLogo;
    return SvgPicture.asset(
      'assets/brand/app_logo.svg',
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(c, BlendMode.srcIn),
    );
  }
}
