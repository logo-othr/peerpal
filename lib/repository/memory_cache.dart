class MemoryCache {
  MemoryCache() : _memoryCache = <String, Object>{};

  final Map<String, Object> _memoryCache;

  void set<T extends Object>({required String key, required T value}) {
    _memoryCache[key] = value;
  }

  bool containsKey(String key) {
    return _memoryCache.containsKey(key);
  }

  T? get<T extends Object>({required String key}) {
    final value = _memoryCache[key];
    if (value is T) return value;
    return null;
  }
}