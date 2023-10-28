extension StringExtension on String? {
  String get replaceNull {
    if (this!.isEmpty) {
      return 'N/A';
    }

    if (this == null) {
      return 'N/A';
    }

    return this!;
  }
}
