import 'dart:io';

import 'package:cherifla/screens/changeComite/change_comite_target.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/log/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrCodeScreen extends StatefulWidget {
  const ScanQrCodeScreen({super.key});

  @override
  State<ScanQrCodeScreen> createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final api = ApiServices();
  Barcode? result;
  QRViewController? controller;
  var showLoading = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                  cutOutSize: 250,
                  borderColor: primaryColor,
                  borderWidth: 10,
                  borderRadius: 18,
                  overlayColor: Colors.black.withOpacity(0.8)),
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(' Data: ${result!.code}'),
                        IconButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                            },
                            icon: const Icon(
                              Icons.flashlight_on_outlined,
                              color: primaryColor,
                              size: 40,
                            ))
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('Scannez le qr code'),
                        IconButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                            },
                            icon: const Icon(
                              Icons.flashlight_on_outlined,
                              color: primaryColor,
                              size: 40,
                            ))
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.first.then((scanData) {
      HapticFeedback.vibrate();
      setState(() {
        result = scanData;
      });
      api.getAdherentByCode(result?.code ?? '', showAlert: false).then(
        (value) {
          logger().d(value);
          if (value != null) {
            Get.to(() => ChangeComiteTarget(adherent: value));
          } else {
            api.getAdherentByCode(result?.code ?? '', showAlert: true);
          }
        },
      );
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
