extension StreamExtensions<T> on Stream<T?> {
  Stream<T> whereNotNull() => where((event) => event != null).map((event) => event!);
}
