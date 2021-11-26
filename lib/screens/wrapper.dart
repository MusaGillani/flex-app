import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart'; //as Auth;
import './splash_screen.dart';
import './dashboard_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('build ran inside wrapper');
    final auth = Provider.of<Auth>(context);
    final userType = Provider.of<Auth>(context).userMode;
    // print('auth status in wrapper ${auth.isAuth}');
    return auth.isAuth ? DashboardScreen(userType) : SplashScreen();
  }
}
