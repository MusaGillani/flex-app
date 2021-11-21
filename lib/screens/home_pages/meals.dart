import 'package:flutter/material.dart';

import '../../widgets/meal_adding_form.dart';
import '../../widgets/meals_view.dart';

class Meals extends StatelessWidget {
  bool res = true;
  @override
  Widget build(BuildContext context) {
    return res ? MealForm() : MealsView();
  }
}
