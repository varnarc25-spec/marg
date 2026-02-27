/// Water bill. TODO: BBPS integration.
class WaterRepository {
  Future<List<Map<String, String>>> getBillers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {'id': 'mumbai', 'name': 'Municipal Corporation - Water'},
      {'id': 'bangalore', 'name': 'BWSSB'},
    ];
  }

  Future<double?> fetchBill(String billerId, String consumerId) async {
    await Future.delayed(const Duration(seconds: 1));
    return 450.0;
  }
}
