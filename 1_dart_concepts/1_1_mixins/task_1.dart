void main() {

  final now = DateTime(2003,1,1,0,0,0);
  print(now.formatDate());

  // Implement an extension on [DateTime], returning a [String] in format of
  // `YYYY.MM.DD hh:mm:ss` (e.g. `2023.01.01 00:00:00`).
}

extension DateTimeFormat on DateTime {
  String formatDate(){
    String format(int value, int digits) => value.toString().padLeft(digits,'0');
    return '${format(year, 4)}.'
        '${format(month, 2)}.'
        '${format(day, 2)} '
        '${format(hour, 2)}:'
        '${format(minute, 2)}:'
        '${format(second, 2)}';
  }
}
