class CachedData<T> {
  CachedData({required this.data, required this.expiresAt});

  final T data;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isValid => !isExpired;
}
