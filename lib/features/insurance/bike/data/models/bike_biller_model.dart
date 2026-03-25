/// Insurer / biller returned by bike insurance billers API.
class BikeBiller {
  const BikeBiller({
    required this.id,
    required this.name,
    required this.code,
    this.logoUrl,
    this.state,
    this.category,
    this.fetchSupported = false,
  });

  factory BikeBiller.fromJson(Map<String, dynamic> json) {
    String pickStr(dynamic v) {
      if (v == null) return '';
      final s = v.toString().trim();
      return s;
    }

    return BikeBiller(
      // Backend may send numeric ids; avoid `as String` casts that throw.
      id: pickStr(json['id'] ?? json['billerId'] ?? json['insurerId']),
      name: pickStr(json['name'] ?? json['billerName'] ?? json['companyName']),
      code: pickStr(json['code'] ?? json['insurerCode'] ?? json['billerCode']),
      logoUrl: json['logoUrl']?.toString(),
      state: json['state']?.toString(),
      category: json['category']?.toString(),
      fetchSupported: json['fetchSupported'] as bool? ?? false,
    );
  }

  final String id;
  final String name;
  final String code;
  final String? logoUrl;
  final String? state;
  final String? category;
  final bool fetchSupported;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'logoUrl': logoUrl,
        'state': state,
        'category': category,
        'fetchSupported': fetchSupported,
      };
}
