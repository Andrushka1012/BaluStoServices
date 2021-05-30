extension ListExtension<T> on List<T> {
  List<T> innerList([int startIndex = 0, int? endIndex]) {
    final end = endIndex ?? length;

    return sublist(startIndex, end > length ? length : end);
  }

  T? firstOrNull(bool Function(T element) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}
