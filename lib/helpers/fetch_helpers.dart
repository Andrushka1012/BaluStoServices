const STATUS_CODE_ACCEPTED = 202;
const STATUS_CODE_NO_CONTENT = 204;
const STATUS_CODE_NOT_MODIFIED = 304;
const STATUS_CODE_BAD_REQUEST = 400;
const STATUS_CODE_UNAUTHORIZED = 401;
const STATUS_CODE_NOT_FOUND = 404;

enum ResponseStatus { SUCCESS, FAILURE }

class SafeResponse<T> {
  late final ResponseStatus status;
  late final T? data;
  late final dynamic? error;

  bool get isSuccessful => status == ResponseStatus.SUCCESS;

  bool get isFailure => status == ResponseStatus.FAILURE;

  T get requiredData =>
      isSuccessful ? data! : throw Exception('Cannot access to requiredData because SafeResponse has failure status');

  dynamic get requiredError =>
      isFailure ? error! : throw Exception('Cannot access to requiredError because SafeResponse has success status');

  SafeResponse.success(this.data) {
    status = ResponseStatus.SUCCESS;
    error = null;
  }

  SafeResponse.error(this.error) {
    status = ResponseStatus.FAILURE;
    data = null;
  }

  void throwIfNotSuccessful() {
    if (isFailure) {
      throw error!;
    }
  }
}

Future<SafeResponse<T>> fetchSafety<T>(Future<T> Function() request, {Function(dynamic)? onError}) async {
  try {
    final T data = await request();
    return SafeResponse.success(data);
  } catch (error) {
    return SafeResponse.error(error);
  }
}
