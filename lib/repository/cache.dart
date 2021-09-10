abstract class Cache {
  void set<T extends Object>({required String key, required T value});

  bool containsKey(String key);

  T? get<T extends Object>({required String key});
}
