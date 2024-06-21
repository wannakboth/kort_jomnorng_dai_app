import 'dart:io';

String filePath = 'lib/ip_address.dart'; // Dart file to store the IP address

void main() async {
  String pcIpAddress = await _getLocalIpAddress();
  await _writeIpAddressToFile(pcIpAddress);
  final server = await HttpServer.bind(pcIpAddress, 8080);
  print('Listening on http://${server.address.address}:${server.port}');
  print('PC IP Address: $pcIpAddress');

  await for (HttpRequest request in server) {
    request.response
      ..write(pcIpAddress)
      ..close();
  }
}

Future<String> _getLocalIpAddress() async {
  for (var interface in await NetworkInterface.list()) {
    for (var addr in interface.addresses) {
      if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
        return addr.address;
      }
    }
  }
  return 'Unable to fetch IP address';
}

Future<void> _writeIpAddressToFile(String ipAddress) async {
  try {
    final file = File(filePath);
    String content = "const String pcIpAddress = '$ipAddress';";
    await file.writeAsString(content);
    print('IP address written to file: $filePath');
  } catch (e) {
    print('Failed to write IP address to file: $e');
  }
}
