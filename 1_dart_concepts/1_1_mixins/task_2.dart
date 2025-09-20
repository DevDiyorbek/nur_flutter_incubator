void main() {

  final text = 'Hello, google.com, yay';
  print(text.parseLinks());

  // Implement an extension on [String], parsing links from a text.
  //
  // Extension should return a [List] of texts and links, e.g.:
  // - `Hello, google.com, yay` ->
  //   [Text('Hello, '), Link('google.com'), Text(', yay')].
}

extension LinkParser on String {
  List<String> parseLinks() {
    final List<String> result = [];
    final urlRegExp = RegExp(
      r'(https?://)?[\w-]+(\.[\w-]+)+[/\w-.\?%&=]*',
    );
    final matches = urlRegExp.allMatches(this);
    int lastEnd = 0;

    for (final match in matches) {
      if (match.start > lastEnd) {
        result.add("Text(${substring(lastEnd, match.start)})");
      }
      result.add("Link(${match.group(0)!})");
      lastEnd = match.end;
    }
    if (lastEnd < length) {
      result.add("Text(${substring(lastEnd)})");
    }
    return result.isEmpty ? ["Text($this)"] : result;
  }
}
