extension StreamExtensions<T> on Stream<T?> {
  Stream<T> whereNotNull() => where((event) => event != null).map((event) => event!);
}

Stream<T> flattenStreams<T>(Stream<Stream<T>> source) async* {
  await for (var stream in source) yield* stream;
}