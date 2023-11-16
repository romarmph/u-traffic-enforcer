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

  int get toInt {
    if (this == null) {
      return 0;
    }

    return int.parse(this!);
  }
}
