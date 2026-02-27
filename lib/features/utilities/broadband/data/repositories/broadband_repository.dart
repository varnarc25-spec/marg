/// Broadband / internet bill. TODO: BBPS integration.
class BroadbandRepository {
  Future<List<Map<String, String>>> getBillers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {'id': 'airtel', 'name': 'Airtel Broadband'},
      {'id': 'jio', 'name': 'Jio Fiber'},
      {'id': 'act', 'name': 'ACT Fibernet'},
      {'id': 'bsnl', 'name': 'BSNL Broadband'},
    ];
  }
}
