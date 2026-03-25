/// Indian state / UT name with primary vehicle registration (RTO) series prefix.
///
/// Used for hints, validation, and UI (e.g. Kerala → KL, Karnataka → KA).
class IndiaStateRto {
  const IndiaStateRto({
    required this.stateName,
    required this.rtoPrefix,
  });

  final String stateName;
  /// Two-letter code at start of registration (e.g. KL, KA, MH).
  final String rtoPrefix;
}

/// All states and union territories with standard RTO series letters.
const List<IndiaStateRto> indiaStateRtoList = [
  IndiaStateRto(stateName: 'Andaman and Nicobar Islands', rtoPrefix: 'AN'),
  IndiaStateRto(stateName: 'Andhra Pradesh', rtoPrefix: 'AP'),
  IndiaStateRto(stateName: 'Arunachal Pradesh', rtoPrefix: 'AR'),
  IndiaStateRto(stateName: 'Assam', rtoPrefix: 'AS'),
  IndiaStateRto(stateName: 'Bihar', rtoPrefix: 'BR'),
  IndiaStateRto(stateName: 'Chandigarh', rtoPrefix: 'CH'),
  IndiaStateRto(stateName: 'Chhattisgarh', rtoPrefix: 'CG'),
  IndiaStateRto(
    stateName: 'Dadra and Nagar Haveli and Daman and Diu',
    rtoPrefix: 'DD',
  ),
  IndiaStateRto(stateName: 'Delhi', rtoPrefix: 'DL'),
  IndiaStateRto(stateName: 'Goa', rtoPrefix: 'GA'),
  IndiaStateRto(stateName: 'Gujarat', rtoPrefix: 'GJ'),
  IndiaStateRto(stateName: 'Haryana', rtoPrefix: 'HR'),
  IndiaStateRto(stateName: 'Himachal Pradesh', rtoPrefix: 'HP'),
  IndiaStateRto(stateName: 'Jammu and Kashmir', rtoPrefix: 'JK'),
  IndiaStateRto(stateName: 'Jharkhand', rtoPrefix: 'JH'),
  IndiaStateRto(stateName: 'Karnataka', rtoPrefix: 'KA'),
  IndiaStateRto(stateName: 'Kerala', rtoPrefix: 'KL'),
  IndiaStateRto(stateName: 'Ladakh', rtoPrefix: 'LA'),
  IndiaStateRto(stateName: 'Lakshadweep', rtoPrefix: 'LD'),
  IndiaStateRto(stateName: 'Madhya Pradesh', rtoPrefix: 'MP'),
  IndiaStateRto(stateName: 'Maharashtra', rtoPrefix: 'MH'),
  IndiaStateRto(stateName: 'Manipur', rtoPrefix: 'MN'),
  IndiaStateRto(stateName: 'Meghalaya', rtoPrefix: 'ML'),
  IndiaStateRto(stateName: 'Mizoram', rtoPrefix: 'MZ'),
  IndiaStateRto(stateName: 'Nagaland', rtoPrefix: 'NL'),
  IndiaStateRto(stateName: 'Odisha', rtoPrefix: 'OD'),
  IndiaStateRto(stateName: 'Puducherry', rtoPrefix: 'PY'),
  IndiaStateRto(stateName: 'Punjab', rtoPrefix: 'PB'),
  IndiaStateRto(stateName: 'Rajasthan', rtoPrefix: 'RJ'),
  IndiaStateRto(stateName: 'Sikkim', rtoPrefix: 'SK'),
  IndiaStateRto(stateName: 'Tamil Nadu', rtoPrefix: 'TN'),
  IndiaStateRto(stateName: 'Telangana', rtoPrefix: 'TS'),
  IndiaStateRto(stateName: 'Tripura', rtoPrefix: 'TR'),
  IndiaStateRto(stateName: 'Uttar Pradesh', rtoPrefix: 'UP'),
  IndiaStateRto(stateName: 'Uttarakhand', rtoPrefix: 'UK'),
  IndiaStateRto(stateName: 'West Bengal', rtoPrefix: 'WB'),
];

/// Lookup RTO prefix by state name (case-insensitive); null if unknown.
String? rtoPrefixForStateName(String stateName) {
  final q = stateName.trim().toLowerCase();
  for (final s in indiaStateRtoList) {
    if (s.stateName.toLowerCase() == q) return s.rtoPrefix;
  }
  return null;
}
