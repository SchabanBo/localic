extension StringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;

  bool get isNotNullOrEmpty => !isNullOrEmpty;

  bool get asBool {
    if (isNullOrEmpty) return false;
    switch (this!.toLowerCase()) {
      case 'true':
      case '1':
        return true;
      case 'false':
      case '0':
        return false;
      default:
        throw Exception('Invalid boolean value: $this');
    }
  }

  /// remove all whitespace from the string
  String removeAllWhitespace() {
    return this!.trim().replaceAll(' ', '');
  }

  bool containsIgnoreCase(String other) {
    return this!.toLowerCase().contains(other.toLowerCase());
  }
}
