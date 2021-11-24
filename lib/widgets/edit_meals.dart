import 'package:flutter/material.dart';

import '../providers/firestore.dart' as firestore;

/// TODO
/// delete button for deleting meals
/// check box fro confirming
class EditMeals extends StatefulWidget {
  EditMeals({Key? key}) : super(key: key);

  @override
  _EditMealsState createState() => _EditMealsState();
}

class _EditMealsState extends State<EditMeals> {
  var _isloading = false;
  var _meals;

// firestore.fetchSingleResMeals().then((value) {
//       print(value.length);
//       value.forEach((meal) {
//         // print(meal['resName']);
//       });
//     });
  void getMeals() async {
    setState(() {
      _isloading = true;
    });
    _meals = await firestore.fetchSingleResMeals();
    setState(() {
      _isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getMeals();
  }

  @override
  Widget build(BuildContext context) {
    // List ne = [];
    // ne.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        title: Text(
          'Meals',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
        ),
        centerTitle: true,
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (ctx, constraints) {
                if (_meals.length == 0) {
                  return Center(
                    child: Text('No meals!'),
                  );
                } else
                  return ListView.builder(
                    itemCount: _meals.length,
                    itemBuilder: (
                      ctx,
                      i,
                    ) {
                      var meal = _meals[i];
                      var ingredients = List<String>.from(meal['ingredients']);
                      return Card(
                        margin: const EdgeInsets.all(5),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              meal['imageUrl'],
                            ),
                          ),
                          title: Text(meal['mealName'] as String),
                          subtitle: Row(
                            // width: constraints.maxWidth * 0.5,
                            // child: ListView.builder(
                            //   scrollDirection: Axis.horizontal,
                            //   itemCount: ingredients.length,
                            //   itemBuilder: (ctx, i) =>
                            //       Text(ingredients.toList()[i]),
                            mainAxisSize: MainAxisSize.max,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ...List.generate(
                                2,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Text(ingredients[index]),
                                ),
                              ),
                              Text('...'),
                              SizedBox(width: 5),
                              Text('etc'),
                            ],
                            // ingredients
                            // .map((ingredient) => Text(ingredient))
                            // .toList(),
                            // ),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              var answer = await showDialog<String>(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: Text('Delete this meal!'),
                                    content: Text('Are you sure?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, 'Yes'),
                                        child: Text('Yes'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, 'No'),
                                        child: Text('No'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (answer == 'Yes') {
                                var deleted =
                                    await firestore.deleteMeal(meal['mealId']);
                                if (!deleted) {
                                  await showDialog<void>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Could not delete this meal'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: Text('Okay'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    _meals.removeAt(i);
                                  });
                                }
                              }
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  );
              },
            ),
    );
  }
}
