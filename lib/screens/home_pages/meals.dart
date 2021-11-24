import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';

import '../../widgets/meals_view.dart';

class Meals extends StatelessWidget {
  const Meals({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool res = Provider.of<Auth>(context, listen: false).userMode;
    return res ? MealsControl() : MealsView();
  }
}

class MealsControl extends StatelessWidget {
  const MealsControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        title: Text(
          'Meals',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                padding: EdgeInsets.all(25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/meals/check');
              },
              child: Text('Check All Meals'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                padding: EdgeInsets.all(25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/meals/add');
              },
              child: Text('Add New Meal'),
            ),
          ],
        ),
      ),
    );
  }
}
