import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();

  void _barcodeDetected(BarcodeCapture capture) {
    final Barcode? barcode = capture.barcodes.first;
    if (barcode != null) {
      final String code = barcode.rawValue ?? 'Unknown';
      debugPrint('Barcode found! $code');
    } else {
      debugPrint('Failed to scan Barcode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: MobileScanner(
            controller: cameraController,
            onDetect: _barcodeDetected,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.switch_camera),
              onPressed: () => cameraController.switchCamera(),
            ),
            IconButton(
              icon: const Icon(Icons.flash_on),
              onPressed: () => cameraController.toggleTorch(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => cameraController.stop(),
              child: const Text('Stop Scanning'),
            ),
            ElevatedButton(
              onPressed: () => cameraController.start(),
              child: const Text('Start Scanning'),
            ),
          ],
        ),
      ],
    );
  }
}