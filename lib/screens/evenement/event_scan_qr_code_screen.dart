import 'dart:io';

import 'package:cherifla/services/api/api.services.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

class EventScanQrCodeScreen extends StatefulWidget {
  const EventScanQrCodeScreen({super.key});

  @override
  State<EventScanQrCodeScreen> createState() => _EventScanQrCodeScreenState();
}

class _EventScanQrCodeScreenState extends State<EventScanQrCodeScreen> {
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
                    api.getAdherentByCodeEvent(api.idEvent.value,
                        data.barcodes.first.rawValue.toString(),
                        showAlert: true);
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
