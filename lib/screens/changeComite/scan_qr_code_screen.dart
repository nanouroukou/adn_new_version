import 'dart:io';

import 'package:cherifla/screens/changeComite/change_comite_target.dart';
import 'package:cherifla/services/api/api.services.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

class ScanQrCodeScreen extends StatefulWidget {
  const ScanQrCodeScreen({super.key});

  @override
  State<ScanQrCodeScreen> createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final api = ApiServices();

  var showLoading = false;
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
    } else if (Platform.isIOS) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                MobileScanner(
                  controller: MobileScannerController(autoStart: true),
                  onDetect: (data) {
                    MobileScannerController().stop();
                    api
                        .getAdherentByCode(
                            data.barcodes.first.rawValue.toString(),
                            showAlert: false)
                        .then(
                      (value) {
                        if (value != null) {
                          Get.to(() => ChangeComiteTarget(adherent: value))
                              ?.then(
                            (value) async =>
                                await MobileScannerController().start(),
                          );
                        } else {
                          api
                              .getAdherentByCode(
                                  data.barcodes.first.rawValue.toString(),
                                  showAlert: true)
                              .then(
                                (value) async =>
                                    await MobileScannerController().start(),
                              );
                        }
                      },
                    );
                  },
                ),
                QRScannerOverlay(
                    scanAreaHeight: 240,
                    scanAreaWidth: 240,
                    overlayColor: Colors.black.withValues(alpha: 0.8)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
