import 'dart:io';
import 'dart:isolate';
import 'dart:math';

void main() {
  stdout.write('Enter N: ');
  final line = stdin.readLineSync();
  final int N = int.tryParse(line ?? '') ?? 0;
  if (N < 2) {
    print('Sum: 0');
    return;
  }
  final int processors = Platform.numberOfProcessors;
  final int isolateCount = processors > 1 ? processors : 1;
  final int chunkSize = (N ~/ isolateCount) + 1;
  final List<List<int>> ranges = <List<int>>[];
  for (var i = 0; i < isolateCount; i++) {
    final int start = i * chunkSize + 1;
    final int end = min(N, (i + 1) * chunkSize);
    if (start <= end) ranges.add([start, end]);
  }
  final ReceivePort receivePort = ReceivePort();
  int remaining = ranges.length;
  int total = 0;
  receivePort.listen((message) {
    if (message is int) {
      total += message;
      remaining--;
      if (remaining == 0) {
        print('Sum: $total');
        receivePort.close();
      }
    }
  });
  for (final r in ranges) {
    Isolate.spawn(_worker, [r[0], r[1], receivePort.sendPort]);
  }
}

void _worker(List args) {
  final int start = args[0] as int;
  final int end = args[1] as int;
  final SendPort send = args[2] as SendPort;
  int sum = 0;
  for (int n = max(2, start); n <= end; n++) {
    if (_isPrime(n)) sum += n;
  }
  send.send(sum);
}

bool _isPrime(int n) {
  if (n <= 1) return false;
  if (n <= 3) return true;
  if (n % 2 == 0) return false;
  final int r = sqrt(n).toInt();
  for (int i = 3; i <= r; i += 2) {
    if (n % i == 0) return false;
  }
  return true;
}
