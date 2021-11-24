import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            'images/Logo.jpeg',
            fit: BoxFit.contain,
            height: deviceSize.height * 0.4,
            width: deviceSize.height * 0.9,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/restaurant');
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  height: deviceSize.height * 0.15,
                  width: deviceSize.height * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/restaurant.png',
                        fit: BoxFit.contain,
                        height: deviceSize.height * 0.1125,
                        width: deviceSize.height * 0.1125,
                      ),
                      Text('Restaurants'),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/meals');
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  height: deviceSize.height * 0.15,
                  width: deviceSize.height * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/meal.png',
                        fit: BoxFit.contain,
                        height: deviceSize.height * 0.1125,
                        width: deviceSize.height * 0.1125,
                      ),
                      Text('Meals'),
                    ],
                  ),
                  //  Image.asset(
                  //   'images/qr-code.png',
                  //   fit: BoxFit.contain,
                  // ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/qr');
            },
            child: Container(
                padding: const EdgeInsets.all(5),
                height: deviceSize.height * 0.15,
                width: deviceSize.height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.orange.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.qr_code_scanner_outlined,
                      size: deviceSize.height * 0.1125,
                    ),
                    Text('Scan QR'),
                  ],
                )
                //  Image.asset(
                //   'images/qr-code.png',
                //   fit: BoxFit.contain,
                // ),
                ),
          ),
        ],
      ),
    );
  }
}
