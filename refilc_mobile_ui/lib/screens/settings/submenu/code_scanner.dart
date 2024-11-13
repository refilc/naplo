import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_mobile_ui/common/custom_snack_bar.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_screen.i18n.dart';
import 'package:url_launcher/url_launcher.dart';

class CodeScannerScreen extends StatefulWidget {
  const CodeScannerScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CodeScannerScreenState();
}

class _CodeScannerScreenState extends State<CodeScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  // @override
  // void initState() {
  //   super.initState();

  //   controller!.resumeCamera();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('qr_scanner'.i18n),
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: FutureBuilder(
              future: controller?.getFlashStatus(),
              builder: (context, snapshot) {
                return Icon(
                  snapshot.data == true
                      ? FeatherIcons.zapOff
                      : FeatherIcons.zap,
                );
              },
            ),
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {});
            },
          ),
        ],
      ),
      body: _buildQrView(context),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 280.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).primaryColor,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      // controller.pauseCamera();
      if (result?.code == scanData.code) return;

      setState(() {
        result = scanData;
      });

      if (scanData.code != null) {
        if (scanData.code!.startsWith('qw://')) {
          // String data = scanData.code!.replaceFirst('qw://', '');
          // check the qr id from api
          // TODO: this qr shit
        } else if (scanData.code!.startsWith('https://') ||
            scanData.code!.startsWith('http://')) {
          Uri uri =
              Uri.parse(scanData.code!.replaceFirst('http://', 'https://'));

          // print(uri);

          if (uri.host.contains('refilc.hu') ||
              uri.host.contains('refilcapp.hu') ||
              uri.host.contains('filc.one')) {
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
              content: Text("success".i18n,
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: const Color(0xFF00A900),
              context: context,
            ));

            // launch refilc url
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(context).pop();
              launchUrl(uri, mode: LaunchMode.inAppBrowserView);
            });
          } else {
            // show invalid code error
            // Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
              content: Text("invalid_qr_code".i18n,
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: AppColors.of(context).red,
              context: context,
            ));

            controller.resumeCamera();
          }
        } else {
          // show invalid code error
          // Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
            content: Text("invalid_qr_code".i18n,
                style: const TextStyle(color: Colors.white)),
            backgroundColor: AppColors.of(context).red,
            context: context,
          ));

          controller.resumeCamera();
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
        content: Text("camera_perm_error".i18n,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.of(context).red,
        context: context,
      ));
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
