import 'package:peerpal/repository/cache.dart';

class MemoryCache implements Cache{
  MemoryCache() : _memoryCache = <String, Object>{};

  final Map<String, Object> _memoryCache;

  @override
  void clear({ String? key}) {
    if(key == null) _memoryCache.clear();
    else _memoryCache.remove(key);
  }

  @override
  void set<T extends Object>({required String key, required T value}) {
    _memoryCache[key] = value;
  }

  @override
  bool containsKey(String key) {
    return _memoryCache.containsKey(key);
  }

  @override
  T? get<T extends Object>({required String key}) {
    final value = _memoryCache[key];
    if (value is T) return value;
    return null;
  }
}