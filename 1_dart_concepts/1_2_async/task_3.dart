import 'dart:io';

void main() async {
  final server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    8080,
  );
  print('Server running on http://${server.address.host}:${server.port}');

  await for (HttpRequest request in server) {
    final path = request.uri.path;

    if (path == '/write') {
      final file = File('dummy.txt');
      final content = 'Hello at ${DateTime.now()}\n';
      await file.writeAsString(content, mode: FileMode.append);
      request.response
        ..statusCode = HttpStatus.ok
        ..write('Written: $content');
      await request.response.close();
    } else if (path == '/read') {
      final file = File('dummy.txt');
      if (await file.exists()) {
        final contents = await file.readAsString();
        request.response
          ..statusCode = HttpStatus.ok
          ..write(contents);
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..write('Error: dummy.txt not found');
      }
      await request.response.close();
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('Unknown route');
      await request.response.close();
    }
  }
}
