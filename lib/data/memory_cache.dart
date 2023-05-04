import 'package:peerpal/data/cache.dart';

class InMemoryCache implements Cache {
  InMemoryCache() : _cacheStorage = <String, Object>{};

  final Map<String, Object> _cacheStorage;

  @override
  void clearCache({String? key}) {
    if (key == null) {
      _cacheStorage.clear();
    } else {
      _removeCacheEntry(key);
    }
  }

  @override
  void store<T extends Object>({required String key, required T value}) {
    _cacheStorage[key] = value;
  }

  @override
  bool hasKey(String key) {
    return _cacheStorage.containsKey(key);
  }

  @override
  T? retrieve<T extends Object>({required String key}) {
    final value = _cacheStorage[key];
    if (value is T) return value;
    return null;
  }

  void _removeCacheEntry(String key) {
    _cacheStorage.remove(key);
  }

  @override
  String toString() {
    return _cacheStorage.toString();
  }
}