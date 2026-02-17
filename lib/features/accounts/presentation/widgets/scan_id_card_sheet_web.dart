import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/id_card_ocr_service.dart';
import '../../../../core/services/marg_api_service.dart';

const Color _sheetPurple = Color(0xFF6C63FF);

String _extensionFromBytes(List<int> bytes) {
  if (bytes.length >= 12) {
    if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) return 'png';
    if (bytes[0] == 0xFF && bytes[1] == 0xD8) return 'jpg';
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46 &&
        bytes[8] == 0x57 && bytes[9] == 0x45 && bytes[10] == 0x42 && bytes[11] == 0x50) return 'webp';
  }
  return 'jpg';
}

/// On web: when [margApi] is provided, uses API OCR; otherwise shows "use mobile app" message.
/// [idToken] is required for server to store the image and link it to the user.
Future<ExtractedIdData?> showScanIdCardSheet(
  BuildContext context, {
  MargApiService? margApi,
  String? idToken,
}) async {
  if (margApi == null) {
    return _showUnsupportedSheet(context);
  }
  return showModalBottomSheet<ExtractedIdData?>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _ScanIdCardSheetWeb(api: margApi, idToken: idToken),
  );
}

Future<ExtractedIdData?> _showUnsupportedSheet(BuildContext context) async {
  return showModalBottomSheet<ExtractedIdData?>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Icon(Icons.phone_android_rounded, size: 48, color: _sheetPurple.withValues(alpha: 0.8)),
              const SizedBox(height: 16),
              Text(
                'Scan ID card',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'ID card scanning is available only on the Android and iOS app, or when the API is configured. Please use the mobile app or enter your details manually.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(backgroundColor: _sheetPurple, padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _ScanIdCardSheetWeb extends StatefulWidget {
  final MargApiService api;
  final String? idToken;

  const _ScanIdCardSheetWeb({required this.api, this.idToken});

  @override
  State<_ScanIdCardSheetWeb> createState() => _ScanIdCardSheetWebState();
}

class _ScanIdCardSheetWebState extends State<_ScanIdCardSheetWeb> {
  final ImagePicker _picker = ImagePicker();
  bool _loading = false;
  String? _error;

  Future<void> _pickAndRecognize(ImageSource source) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final XFile? xFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
      );
      if (xFile == null || !mounted) {
        setState(() => _loading = false);
        return;
      }

      final bytes = await xFile.readAsBytes();
      if (bytes.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'Could not read image';
        });
        return;
      }

      final ext = _extensionFromBytes(bytes);
      final filename = 'image.$ext';

      if (widget.idToken == null || widget.idToken!.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'Please sign in to scan and save your ID card.';
        });
        return;
      }

      final data = await widget.api.extractIdFromImage(
        bytes,
        filename: filename,
        idToken: widget.idToken,
      );
      if (!mounted) return;

      setState(() => _loading = false);

      final result = data != null ? ExtractedIdData.fromJson(data) : null;
      if (result != null &&
          (result.fullName != null ||
              result.dateOfBirth != null ||
              result.gender != null ||
              result.address != null)) {
        Navigator.of(context).pop(result);
      } else {
        setState(() {
          _error = 'Could not read details from this image. Try a clearer photo of PAN or Aadhaar.';
        });
      }
    } catch (e, stack) {
      debugPrint('ScanIdCardSheetWeb: $e');
      debugPrint(stack.toString());
      if (mounted) {
        setState(() {
          _loading = false;
          _error = kDebugMode && e is Exception
              ? 'Error: ${e.toString().replaceFirst('Exception: ', '')}'
              : 'Something went wrong. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Scan ID card',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Upload a photo of your PAN or Aadhaar card to auto-fill details.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'JPG, PNG or WebP work best.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                    ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _error!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onErrorContainer,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: _sheetPurple),
                      SizedBox(height: 12),
                      Text('Reading card...'),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _pickAndRecognize(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt_rounded, size: 24),
                        label: const Text('Take picture'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _sheetPurple,
                          side: const BorderSide(color: _sheetPurple),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _pickAndRecognize(ImageSource.gallery),
                        icon: const Icon(Icons.upload_rounded, size: 24),
                        label: const Text('Upload from gallery'),
                        style: FilledButton.styleFrom(
                          backgroundColor: _sheetPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
