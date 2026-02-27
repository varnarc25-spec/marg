/// Gas bill. TODO: BBPS integration.
class GasRepository {
  Future<List<Map<String, String>>> getBillers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {'id': 'mahanagar', 'name': 'Mahanagar Gas'},
      {'id': 'indraprastha', 'name': 'Indraprastha Gas'},
    ];
  }
}
