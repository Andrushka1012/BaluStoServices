extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  bool get isValidEmail {
    final RegExp emailExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return emailExp.hasMatch(trim());
  }

  bool get isValidPassword {
    final RegExp passwordPolicy = RegExp(r'^(?=.*?[A-Z]).{6,24}$');
    return isNotBlank && passwordPolicy.hasMatch(trim());
  }

  String get formatPhoneNumber {
    final currentNumber = this;
    if (currentNumber.length < 6) return currentNumber;
    String formattedNumber = '';
    formattedNumber += currentNumber.substring(0, 3) + ' ';
    formattedNumber += currentNumber.substring(3, 6) + ' ';
    formattedNumber += currentNumber.substring(6, currentNumber.length);
    return formattedNumber;
  }

  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => trim().isNotEmpty;

  String overflowEllipseFor(int symbolsCount) => length >= symbolsCount ? '${substring(0, symbolsCount)}..' : this;

  String asBearerToken() => 'Bearer $this';
}
