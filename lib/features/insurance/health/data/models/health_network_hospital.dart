/// A hospital row from `GET /api/insurance/health/network-hospitals`.
class HealthNetworkHospital {
  const HealthNetworkHospital({
    required this.name,
    this.address,
    this.city,
    this.pincode,
  });

  factory HealthNetworkHospital.fromJson(Map<String, dynamic> json) {
    return HealthNetworkHospital(
      name: (json['name'] ?? json['hospitalName'] ?? json['title'] ?? '')
          .toString()
          .trim(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      pincode: json['pincode']?.toString(),
    );
  }

  final String name;
  final String? address;
  final String? city;
  final String? pincode;
}
