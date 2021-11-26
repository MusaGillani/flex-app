import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';

import '../../widgets/qr_scanner.dart';
import '../../widgets/qr_upload.dart';

class Qr extends StatelessWidget {
  const Qr({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool res = Provider.of<Auth>(context, listen: false).userMode;
    return res ? AddQR() : QrScanner();
  }
}
