import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';

import '../../widgets/restaurant_details_view.dart';
import '../../widgets/restaurants_catalog.dart';

class Restaurants extends StatelessWidget {
  const Restaurants({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool res = Provider.of<Auth>(context, listen: false).userMode;
    return res ? ResDetails() : ResCatalog();
  }
}

/*
ListTile(
                    title: _buildTextFormField(
                      constraints,
                      hintText: 'ingredient name',
                      validator: (String? val) {
                        if (val!.isEmpty) {
                          return 'required!';
                        }
                        return null;
                      },
                      onSaved: (val) {},
                      keyboard: TextInputType.name,
                    ),
                    trailing: DropdownButton(
                      value: _dropDownValue,
                      onChanged: (String? newVal) {
                        setState(() {
                          _dropDownValue = newVal;
                        });
                      },
                      items: <String>[
                        'Fruits',
                        'Vegetables',
                        'Nuts and Seeds',
                        'Dairy'
                      ]
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                    ),
                  ),
 */
