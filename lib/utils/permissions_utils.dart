List<int> extractStoreIds(List<dynamic> permissions) {
  if (permissions.isNotEmpty) {
    final firstPermission = permissions[0];
    if (firstPermission.containsKey('stores') &&
        firstPermission['stores'] is List) {
      final stores = firstPermission['stores'] as List<dynamic>;
      return stores.map<int>((store) => store['id'] as int).toList();
    }
  }
  return [];
}

List<Map<String, dynamic>> extractStoreIdAndName(List<dynamic> permissions) {
  List<Map<String, dynamic>> storeInfo = [];
  if (permissions.isNotEmpty) {
    final firstPermission = permissions[0];
    if (firstPermission.containsKey('stores') &&
        firstPermission['stores'] is List) {
      final stores = firstPermission['stores'] as List<dynamic>;
      return stores.map<Map<String, dynamic>>((store) {
        return {'id': store['id'], 'storename': store['storename']};
      }).toList();
    }
  }
  return storeInfo;
}

String extractUsername(List<dynamic> permissions) {
  if (permissions.isNotEmpty) {
    final firstPermission = permissions[0];
    if (firstPermission.containsKey('name') &&
        firstPermission['name'] is String) {
      return firstPermission['name'];
    }
  }
  return 'Usuário';
}
