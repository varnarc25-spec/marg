import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Mock MPIN Service
/// Handles MPIN setup and verification
/// Uses SHA-256 hashing for MPIN storage (mock)
class MockMpinService {
  static final MockMpinService _instance = MockMpinService._internal();
  factory MockMpinService() => _instance;
  MockMpinService._internal();

  String? _storedMpinHash;

  /// Hash MPIN using SHA-256
  String _hashMpin(String mpin) {
    final bytes = utf8.encode(mpin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Set MPIN
  Future<void> setMpin(String mpin) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (mpin.length != 4) {
      throw Exception('MPIN must be 4 digits');
    }

    if (!RegExp(r'^\d{4}$').hasMatch(mpin)) {
      throw Exception('MPIN must contain only digits');
    }

    // Store hashed MPIN
    _storedMpinHash = _hashMpin(mpin);
  }

  /// Verify MPIN
  Future<bool> verifyMpin(String mpin) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (_storedMpinHash == null) {
      throw Exception('MPIN not set. Please set up your MPIN first.');
    }

    final inputHash = _hashMpin(mpin);
    return inputHash == _storedMpinHash;
  }

  /// Check if MPIN is set
  bool isMpinSet() {
    return _storedMpinHash != null;
  }

  /// Clear MPIN (for testing/logout)
  void clearMpin() {
    _storedMpinHash = null;
  }
}
