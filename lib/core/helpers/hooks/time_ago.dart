class TimeAgo {
  // static String format(DateTime date) {
  //   final now = DateTime.now();
  //   final difference = now.difference(date);

  //   if (difference.inDays > 30) {
  //     return '${(difference.inDays / 30).floor()} Mounth';
  //   } else if (difference.inDays > 0) {
  //     return '${difference.inDays} Day';
  //   } else if (difference.inHours > 0) {
  //     return '${difference.inHours} Hours';
  //   } else if (difference.inMinutes > 0) {
  //     return '${difference.inMinutes} Minute';
  //   } else {
  //     return 'Now';
  //   }
  // }
  static String format(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays == 1) {
      return 'kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks minggu yang lalu';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years tahun yang lalu';
    }
  }
}
