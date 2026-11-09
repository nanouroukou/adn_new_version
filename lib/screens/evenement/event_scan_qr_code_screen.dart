import 'dart:io';

import 'package:cherifla/services/api/api.services.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

class EventScanQrCodeScreen extends StatefulWidget {
  const EventScanQrCodeScreen({super.key, required this.id});
  final String id;

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
                    api.getAdherentByCodeEvent(
                        widget.id, data.barcodes.first.rawValue.toString(),
                        showAlert: true);
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
