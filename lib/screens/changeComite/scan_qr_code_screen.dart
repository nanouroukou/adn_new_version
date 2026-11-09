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
    // Zone de scan proportionnelle à l'écran, bornée entre 200 et 340 px
    final size = MediaQuery.sizeOf(context);
    final scanArea = (size.shortestSide * 0.7).clamp(200.0, 340.0).toDouble();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Scanner le QR code'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          tooltip: 'Retour',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
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
                    scanAreaHeight: scanArea,
                    scanAreaWidth: scanArea,
                    overlayColor: Colors.black.withValues(alpha: 0.75)),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 48,
                  child: SafeArea(
                    child: Text(
                      'Placez le QR code dans le cadre',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16),
                    ),
                  ),
                ),
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
