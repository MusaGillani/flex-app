import 'package:flutter/material.dart';

class Restaurants extends StatefulWidget {
  const Restaurants({Key? key}) : super(key: key);

  @override
  _RestaurantsState createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  final GlobalKey<FormState> _formKey = GlobalKey(debugLabel: 'resform-key');
  // List<String> _itemTypes = <String>[
  //   'Fruits',
  //   'Vegetables',
  //   'Nuts and Seeds',
  //   'Dairy'
  // ];
  String? _dropDownValue = 'Fruits';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.pink.shade50,
          title: Text(
            'Restaurants',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
          ),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (
            ctx,
            constraints,
          ) =>
              Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTextFormField(
                    constraints,
                    hintText: 'meal name',
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'required!';
                      }
                      return null;
                    },
                    onSaved: (String? value) {},
                    keyboard: TextInputType.name,
                  ),
                  SizedBox(height: 10),
                  _buildTextFormField(
                    constraints,
                    hintText: 'price \$',
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'required!';
                      }
                      return null;
                    },
                    onSaved: (String? value) {},
                    keyboard: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  Text('Enter Ingredients: '),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildIngredientSelector() {
  //   return ListTile(
  //     title: _buildTextFormField(constraints, hintText: hintText, validator: validator, onSaved: onSaved, keyboard: keyboard),
  //   );
  // }

  Padding _buildTextFormField(
    BoxConstraints constraints, {
    required String hintText,
    required String? Function(String? val) validator,
    required void Function(String? val) onSaved,
    required TextInputType keyboard,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: constraints.maxWidth * 0.1,
      ),
      child: TextFormField(
        keyboardType: keyboard,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade300,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20.0),
          ),
          hintText: hintText,
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
