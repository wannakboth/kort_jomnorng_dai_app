import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../widget/app_widget.dart';
import '../../widget/background.dart';
import '../../widget/color.dart';
import '../../widget/go_navigate.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({super.key});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample>
    with WidgetsBindingObserver {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;
  bool showContainer = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        showContainer = true;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller != null) {
      if (state == AppLifecycleState.inactive) {
        controller!.pauseCamera();
      } else if (state == AppLifecycleState.resumed) {
        controller!.resumeCamera();
      }
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      widgets: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: buildAppBar(),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    AnimatedOpacity(
                      opacity: showContainer ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 1200),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: QRView(
                                key: qrKey,
                                onQRViewCreated: _onQRViewCreated,
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: AppColor.PRIMARY.withOpacity(0.2),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: AnimatedOpacity(
                        opacity: showContainer ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 1200),
                        child: Container(
                          color: Colors.transparent,
                          child: Lottie.asset(
                            'assets/icons/scanQR.json',
                            width: MediaQuery.of(context).size.width * 0.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.GREEN_OPACITY,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: const EdgeInsets.all(12),
                        color: AppColor.WHITE,
                        iconSize: 32,
                        icon: Icon(Icons.flip_camera_ios_outlined),
                        onPressed: () => controller?.flipCamera(),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.RED_OPACITY,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: const EdgeInsets.all(12),
                        color: AppColor.WHITE,
                        iconSize: 32,
                        icon: Icon(Icons.flash_on),
                        onPressed: () => controller?.toggleFlash(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      leading: BackButton(
        color: AppColor.WHITE,
      ),
      title: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
        child: AppWidget.name(
          context,
          fontSize: 12,
          imageSize: MediaQuery.of(context).size.width * 0.1,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      controller.pauseCamera();

      GoNavigate.pushReplacementNamedWithArguments(
        '/insert-name',
        {'name': result?.code},
      );
    });
  }
}
