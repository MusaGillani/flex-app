import 'package:flutter/material.dart';

import '../providers/firestore.dart' as firestore;

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // bool _isLoading = false;
  late List<Map<String, dynamic>> _meals;
  // var _mealsCount = 0;
  late Future<List<Map<String, dynamic>>> _future;

  Map<String, bool> _selectedFilters = {
    'apple': false,
    'cherry': false,
    'banana': false,
    'Strawberry': false,
    'avocado': false,
    'carrot': false,
    'spinach': false,
    'potato': false,
    'almonds': false,
    'walnut': false,
    'pistachios': false,
    'cashews': false,
    'full fat milk': false,
    'yogurt': false,
    'ice cream': false,
    'cheese': false,
  };

  @override
  void initState() {
    getMeals();
    super.initState();
  }

  void getMeals() {
    _future = firestore.fetchCusFavMeals();
    // setState(() {
    //   _isLoading = true;
    // });
    // if (widget.allRes)
    // _meals = await firestore.fetchCusFavMeals();
    // else
    //   _meals = await firestore.fetchSingleResMeals(widget.resId!);
    // _meals.length;
    // setState(() {
    //   _isLoading = false;
    // });
  }

  void _applyFilters(bool val, String option) {
    setState(() {
      // if (val != null)
      _selectedFilters[option] = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return LayoutBuilder(builder: (ctx, constraints) => Container());
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (ctx, snaphot) {
          if (snaphot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snaphot.hasData &&
              snaphot.connectionState == ConnectionState.done) {
            _meals = snaphot.data!;
          }
          return LayoutBuilder(
            builder: (
              ctx,
              constraints,
            ) =>
                Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async => await showDialog(
                            context: context,
                            builder: (
                              ctx,
                            ) =>
                                SimpleDialog(
                              title: Text('Sort By:'),
                              children: [
                                SimpleDialogOption(
                                  onPressed: () =>
                                      Navigator.pop(context, 'some data'),
                                  child: Text('Date added'),
                                ),
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.sort_sharp),
                              Text('sort'),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.pink.shade50),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (
                                ctx,
                              ) =>
                                  StatefulBuilder(
                                builder: (ctx, stateSet) => SimpleDialog(
                                  title: Text('Filter:'),
                                  children: _selectedFilters.keys
                                      // _filterOptions
                                      .map(
                                        (option) => CheckboxListTile(
                                          value: _selectedFilters[option],
                                          onChanged: (val) {
                                            _applyFilters(val!, option);
                                            stateSet(() {});
                                          },
                                          title: Text(option),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.filter_alt_sharp),
                              Text('filter'),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.pink.shade50),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      // separatorBuilder: (ctx, i) => Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      //   child: Divider(
                      //     thickness: 5.0,
                      //   ),
                      // ),
                      itemCount: _meals.length,
                      itemBuilder: (
                        ctx,
                        index,
                      ) {
                        var filterOut = false;
                        final data = _meals[index];
                        final ingredients =
                            List<String>.from(data['ingredients']);
                        ingredients.forEach((String ingredient) {
                          _selectedFilters.keys.toList().forEach((filter) {
                            // var filter = 'beef';
                            // print(ingredient);
                            // print(_selectedFilters[filter]);
                            if (_selectedFilters[filter]! &&
                                filter.toLowerCase() ==
                                    ingredient.toLowerCase()) filterOut = true;
                          });
                        });
                        return filterOut
                            ? Container()
                            : Card(
                                margin: const EdgeInsets.all(10),
                                color: Colors.orange.shade200,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  // side: BorderSide(
                                  //     color: Colors.orange.shade200, width: 5),
                                ),
                                // color: Theme.of(context)
                                //     .primaryColorLight.,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 15),
                                  width: constraints.maxWidth,
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(10),
                                  //   border: Border.all(
                                  //       color: Colors.orange.shade200, width: 5),
                                  // ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: constraints.maxHeight * 0.2,
                                        width: constraints.maxWidth * 0.4,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            '${data['imageUrl']}',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            loadingBuilder: (ctx,
                                                child,
                                                ImageChunkEvent?
                                                    loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child: LinearProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: constraints.maxWidth * 0.01),
                                      Container(
                                        height: constraints.maxHeight * 0.2,
                                        width: constraints.maxWidth * 0.49,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                ListItemText(
                                                    child:
                                                        Text(data['mealName'])),
                                                Spacer(),
                                                Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            ListItemText(
                                                child: Text(data['resName'])),
                                            // Spacer(),
                                            Expanded(
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: ingredients.length,
                                                itemBuilder: (ctx, i) {
                                                  final ing = ingredients[i];
                                                  return Chip(
                                                    label: Text(
                                                      '$ing',
                                                    ),
                                                    backgroundColor:
                                                        Colors.pink.shade50,
                                                    // labelStyle: TextStyle(
                                                    //     color: Colors.white),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // ),
          );
        });

    // _isLoading
    //     ? Center(child: CircularProgressIndicator())
    //     : LayoutBuilder(
    //         builder: (
    //           ctx,
    //           constraints,
    //         ) =>
    //             Container(
    //           height: constraints.maxHeight,
    //           width: constraints.maxWidth,
    //           child: Column(
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Row(
    //                   mainAxisSize: MainAxisSize.max,
    //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                   children: [
    //                     ElevatedButton(
    //                       onPressed: () async => await showDialog(
    //                         context: context,
    //                         builder: (
    //                           ctx,
    //                         ) =>
    //                             SimpleDialog(
    //                           title: Text('Sort By:'),
    //                           children: [
    //                             SimpleDialogOption(
    //                               onPressed: () =>
    //                                   Navigator.pop(context, 'some data'),
    //                               child: Text('Date added'),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       child: Row(
    //                         children: [
    //                           Icon(Icons.sort_sharp),
    //                           Text('sort'),
    //                         ],
    //                       ),
    //                       style: ElevatedButton.styleFrom(
    //                           primary: Colors.pink.shade50),
    //                     ),
    //                     ElevatedButton(
    //                       onPressed: () async {
    //                         await showDialog(
    //                           context: context,
    //                           builder: (
    //                             ctx,
    //                           ) =>
    //                               StatefulBuilder(
    //                             builder: (ctx, stateSet) => SimpleDialog(
    //                               title: Text('Filter:'),
    //                               children: _selectedFilters.keys
    //                                   // _filterOptions
    //                                   .map(
    //                                     (option) => CheckboxListTile(
    //                                       value: _selectedFilters[option],
    //                                       onChanged: (val) {
    //                                         _applyFilters(val!, option);
    //                                         stateSet(() {});
    //                                       },
    //                                       title: Text(option),
    //                                     ),
    //                                   )
    //                                   .toList(),
    //                             ),
    //                           ),
    //                         );
    //                       },
    //                       child: Row(
    //                         children: [
    //                           Icon(Icons.filter_alt_sharp),
    //                           Text('filter'),
    //                         ],
    //                       ),
    //                       style: ElevatedButton.styleFrom(
    //                           primary: Colors.pink.shade50),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Expanded(
    //                 child: ListView.builder(
    //                   // separatorBuilder: (ctx, i) => Padding(
    //                   //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
    //                   //   child: Divider(
    //                   //     thickness: 5.0,
    //                   //   ),
    //                   // ),
    //                   itemCount: _meals.length,
    //                   itemBuilder: (
    //                     ctx,
    //                     index,
    //                   ) {
    //                     var filterOut = false;
    //                     final data = _meals[index];
    //                     final ingredients =
    //                         List<String>.from(data['ingredients']);
    //                     ingredients.forEach((String ingredient) {
    //                       _selectedFilters.keys.toList().forEach((filter) {
    //                         // var filter = 'beef';
    //                         // print(ingredient);
    //                         // print(_selectedFilters[filter]);
    //                         if (_selectedFilters[filter]! &&
    //                             filter.toLowerCase() ==
    //                                 ingredient.toLowerCase()) filterOut = true;
    //                       });
    //                     });
    //                     return filterOut
    //                         ? Container()
    //                         : Card(
    //                             margin: const EdgeInsets.all(10),
    //                             color: Colors.orange.shade200,
    //                             shape: RoundedRectangleBorder(
    //                               borderRadius: BorderRadius.circular(25),
    //                               // side: BorderSide(
    //                               //     color: Colors.orange.shade200, width: 5),
    //                             ),
    //                             // color: Theme.of(context)
    //                             //     .primaryColorLight.,
    //                             child: Container(
    //                               margin: const EdgeInsets.symmetric(
    //                                   horizontal: 8, vertical: 15),
    //                               width: constraints.maxWidth,
    //                               // decoration: BoxDecoration(
    //                               //   borderRadius: BorderRadius.circular(10),
    //                               //   border: Border.all(
    //                               //       color: Colors.orange.shade200, width: 5),
    //                               // ),
    //                               child: Row(
    //                                 children: [
    //                                   Container(
    //                                     height: constraints.maxHeight * 0.2,
    //                                     width: constraints.maxWidth * 0.4,
    //                                     decoration: BoxDecoration(
    //                                       borderRadius:
    //                                           BorderRadius.circular(10),
    //                                     ),
    //                                     child: ClipRRect(
    //                                       borderRadius:
    //                                           BorderRadius.circular(10),
    //                                       child: Image.network(
    //                                         '${data['imageUrl']}',
    //                                         fit: BoxFit.cover,
    //                                         width: double.infinity,
    //                                         loadingBuilder: (ctx,
    //                                             child,
    //                                             ImageChunkEvent?
    //                                                 loadingProgress) {
    //                                           if (loadingProgress == null)
    //                                             return child;
    //                                           return Center(
    //                                             child: LinearProgressIndicator(
    //                                               value: loadingProgress
    //                                                           .expectedTotalBytes !=
    //                                                       null
    //                                                   ? loadingProgress
    //                                                           .cumulativeBytesLoaded /
    //                                                       loadingProgress
    //                                                           .expectedTotalBytes!
    //                                                   : null,
    //                                             ),
    //                                           );
    //                                         },
    //                                       ),
    //                                     ),
    //                                   ),
    //                                   SizedBox(
    //                                       width: constraints.maxWidth * 0.01),
    //                                   Container(
    //                                     height: constraints.maxHeight * 0.2,
    //                                     width: constraints.maxWidth * 0.49,
    //                                     child: Column(
    //                                       crossAxisAlignment:
    //                                           CrossAxisAlignment.start,
    //                                       children: [
    //                                         Row(
    //                                           children: [
    //                                             ListItemText(
    //                                                 child:
    //                                                     Text(data['mealName'])),
    //                                             Spacer(),
    //                                             Icon(
    //                                               Icons.favorite,
    //                                               color: Colors.red,
    //                                             ),
    //                                           ],
    //                                         ),
    //                                         SizedBox(height: 5),
    //                                         ListItemText(
    //                                             child: Text(data['resName'])),
    //                                         // Spacer(),
    //                                         Expanded(
    //                                           child: ListView.builder(
    //                                             scrollDirection:
    //                                                 Axis.horizontal,
    //                                             itemCount: ingredients.length,
    //                                             itemBuilder: (ctx, i) {
    //                                               final ing = ingredients[i];
    //                                               return Chip(
    //                                                 label: Text(
    //                                                   '$ing',
    //                                                 ),
    //                                                 backgroundColor:
    //                                                     Colors.pink.shade50,
    //                                                 // labelStyle: TextStyle(
    //                                                 //     color: Colors.white),
    //                                               );
    //                                             },
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                           );
    //                   },
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         // ),
    //       );
  }
}

class ListItemText extends StatelessWidget {
  const ListItemText({Key? key, required this.child}) : super(key: key);
  final Text child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.all(15),
      child: child,
    );
  }
}
