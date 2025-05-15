/// Kumpulan extension method untuk memanipulasi String
extension StringUtils on String {
  /// Menangani overflow text dengan memotong dan menambahkan replacement
  /// [maxChars] - Panjang maksimal karakter sebelum dipotong
  /// [replacement] - Text yang akan ditambahkan di akhir jika dipotong
  String truncate({int? maxChars, String replacement = '...'}) =>
      maxChars != null && length > maxChars
          ? replaceRange(maxChars, null, replacement)
          : this;

  /// Mengecek apakah string kosong (termasuk whitespace)
  bool get isBlank => trim().isEmpty;

  /// Mengecek apakah string tidak kosong (termasuk whitespace)
  bool get isNotBlank => !isBlank;
  String removeNumbers() {
    return replaceAll(RegExp(r'\d'), '');
  }

  /// Mengubah string ke format Title Case
  /// Contoh: "hello world" -> "Hello World"
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  /// Membalikkan string
  /// Contoh: "hello" -> "olleh"
  String reverse() {
    if (isEmpty) return this;
    return String.fromCharCodes(runes.toList().reversed);
  }

  /// Menghitung jumlah kata dalam string
  /// [delimiter] - Pemisah kata (default: whitespace)
  // int countWords({Pattern delimiter = r'\s+'}) {
  //   if (isEmpty) return 0;
  //   return split(RegExp(delimiter)).where((s) => s.isNotBlank).length;
  // }

  /// Mengecek apakah string mengandung substring tertentu (case insensitive)
  bool containsIgnoreCase(String substring) {
    return toLowerCase().contains(substring.toLowerCase());
  }

  /// Menghapus semua whitespace dari string
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Mengecek apakah string adalah email yang valid
  bool get isEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  /// Mengecek apakah string adalah URL yang valid
  bool get isUrl {
    return RegExp(
      r'^(https?://)?([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?$',
      caseSensitive: false,
    ).hasMatch(this);
  }

  /// Mengubah string menjadi slug
  /// Contoh: "Hello World!" -> "hello-world"
  String toSlug() {
    return toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  /// Mengekstrak angka dari string
  /// Contoh: "Rp 10.000" -> 10000
  int extractNumbers() {
    final numberStr = replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numberStr) ?? 0;
  }

  /// Menambahkan prefix jika string tidak kosong
  String prefixIfNotEmpty(String prefix) => isNotBlank ? '$prefix$this' : this;

  /// Menambahkan suffix jika string tidak kosong
  String suffixIfNotEmpty(String suffix) => isNotBlank ? '$this$suffix' : this;
}
