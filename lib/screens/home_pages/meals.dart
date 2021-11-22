import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';

import '../../widgets/meal_adding_form.dart';
import '../../widgets/meals_view.dart';

class Meals extends StatelessWidget {
  const Meals({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool res = Provider.of<Auth>(context, listen: false).userMode;
    return res ? MealForm() : MealsView();
  }
}
