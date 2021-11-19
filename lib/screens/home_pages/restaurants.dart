import 'package:flutter/material.dart';

class Restaurants extends StatelessWidget {
  const Restaurants({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        title: Text(
          'Restaurants',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
        ),
        centerTitle: true,
      ),
    );
  }
}
