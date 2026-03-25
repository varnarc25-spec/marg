/// Vehicle linked for FASTag (`/api/recharges/fastag/vehicles`).
class VehicleModel {
  final String id;
  /// Registration / plate (`number` in API response).
  final String number;
  final String tagId;
  final double balance;
  final String? vehicleType;
  final String? label;
  final String? issuerBank;
  final bool isPrimary;
  final String? status;
  final DateTime? createdAt;

  /// Unmapped fields from API.
  final Map<String, dynamic> raw;

  const VehicleModel({
    required this.id,
    required this.number,
    required this.tagId,
    this.balance = 0,
    this.vehicleType,
    this.label,
    this.issuerBank,
    this.isPrimary = false,
    this.status,
    this.createdAt,
    this.raw = const {},
  });

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  factory VehicleModel.fromApiJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ??
        json['_id']?.toString() ??
        json['vehicleId']?.toString() ??
        '';
    final reg = (json['registrationNumber'] ??
            json['vehicleNumber'] ??
            json['number'] ??
            json['regNumber'] ??
            '')
        .toString();
    final tag = (json['tagId'] ?? json['fastagId'] ?? json['tagNumber'] ?? '')
        .toString();
    final bal = _toDouble(
      json['balance'] ?? json['availableBalance'] ?? json['walletBalance'],
    );
    final vt = json['vehicleType']?.toString();
    final lab = json['label']?.toString();
    final bank = json['issuerBank']?.toString();
    final primary = json['isPrimary'] == true;
    final st = json['status']?.toString();
    DateTime? created;
    final ca = json['createdAt'] ?? json['created_at'];
    if (ca != null) {
      created = DateTime.tryParse(ca.toString());
    }
    return VehicleModel(
      id: id,
      number: reg.isNotEmpty ? reg : '—',
      tagId: tag.isNotEmpty ? tag : '—',
      balance: bal,
      vehicleType: vt,
      label: lab,
      issuerBank: bank,
      isPrimary: primary,
      status: st,
      createdAt: created,
      raw: Map<String, dynamic>.from(json),
    );
  }
}
