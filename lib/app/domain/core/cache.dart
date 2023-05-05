abstract class Cache {
  void store<T extends Object>({required String key, required T value});

  bool hasKey(String key);

  T? retrieve<T extends Object>({required String key});

  void clearCache({String? key});

  String toString();
}
