import 'package:flutter/material.dart';

import '../../widgets/qr_scanner.dart';
import '../../widgets/qr_upload.dart';

class Qr extends StatelessWidget {
  const Qr({Key? key}) : super(key: key);

  final bool res = true;

  @override
  Widget build(BuildContext context) {
    return res ? QrUpload() : QrScanner();
  }
}
