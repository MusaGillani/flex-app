import 'package:flutter/material.dart';

import '../widgets/buttons.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (ctx, constraints) => Container(
          child: Column(
            children: [
              Image.asset(
                'images/Logo.jpeg',
                fit: BoxFit.contain,
              ),
              Spacer(),
              buildYellowButton(
                handler: () => Navigator.of(context).pushNamed('/signup'),
                child: Text(
                  'SIGN UP',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Theme.of(context).primaryColor,
                h: constraints.maxHeight * 0.1,
                w: constraints.maxWidth * 0.8,
                radius: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ALREADY HAVE AN ACCOUNT? ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed('/login'),
                    child: Text('LOG IN'),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
