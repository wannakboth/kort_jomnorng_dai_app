import 'dart:io';

String apiUrl = '';
String searchUrl = '';
String createUrl = '';

// Initialize IP address and set URLs
Future<void> initializeIpAddress() async {
  String localIP = await _getLocalIpAddress();
  apiUrl = 'http://$localIP:5000/api';
  searchUrl = '$apiUrl/search';
  createUrl = '$apiUrl/currency';
  print('API URL: $apiUrl');
}

Future<String> _getLocalIpAddress() async {
  try {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
          return addr.address;
        }
      }
    }
  } catch (e) {
    print('Failed to get local IP address: $e');
  }
  return 'Unable to fetch IP address';
}
