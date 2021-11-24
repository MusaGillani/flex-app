import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import './image_input.dart';
import '../providers/firestore.dart' as firestore;

class MealForm extends StatefulWidget {
  const MealForm({Key? key}) : super(key: key);

  @override
  _MealFormState createState() => _MealFormState();
}

// TODO show popup when done, and pop screen
class _MealFormState extends State<MealForm> {
  final GlobalKey<FormState> _formKey = GlobalKey(debugLabel: 'mealform-key');

  bool _isLoading = false;

  File? _pickedImage;
  List<Widget> _ingredientEntry = [];
  List<String> _ingredients = [];
  String _mealName = '';
  int _price = 0;

  var init = true;
  late final Size deviceSize;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      deviceSize = MediaQuery.of(context).size;
      // _ingredients.add('');
      _ingredientEntry.add(
        _buildTextFormField(
          BoxConstraints(
            maxHeight: deviceSize.height,
            maxWidth: deviceSize.width,
          ),
          hintText: 'ingredient name',
          validator: (String? val) {
            if (val!.isEmpty) {
              return 'required!';
            }
            return null;
          },
          onSaved: (String? val) {
            _ingredients.add(val!);
          },
          keyboard: TextInputType.name,
        ),
      );
    }
    init = false;
  }

  void _selectImage(File myPickedImage) {
    _pickedImage = myPickedImage;
  }

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
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.pink.shade50,
          title: Text(
            'Meals',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }

              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton.icon(
              label: Text('Add Meal'),
              icon: Icon(Icons.check),
              onPressed: _submit,
              style: TextButton.styleFrom(primary: Colors.black),
            ),
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (
                  ctx,
                  constraints,
                ) =>
                    Form(
                  key: _formKey,
                  child: Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          ImageInput(_selectImage, 'images/meal.png'),
                          SizedBox(height: 10),
                          _buildTextFormField(
                            constraints,
                            hintText: 'meal name',
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'required!';
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              _mealName = value!;
                            },
                            keyboard: TextInputType.name,
                          ),
                          // SizedBox(height: 10),
                          _buildTextFormField(
                            constraints,
                            hintText: 'price \$',
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'required!';
                              } else if (int.parse(value) < 0) {
                                return 'enter a valid price!';
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              _price = int.parse(value!);
                            },
                            keyboard: TextInputType.number,
                          ),
                          Text('Enter Ingredients: '),
                          SizedBox(height: 10),
                          // Expanded(
                          //   child: ListView.separated(
                          //     itemCount: _ingredientEntry.length,
                          //     itemBuilder: (_, i) => _ingredientEntry[i],
                          //     separatorBuilder: (_, i) => SizedBox(height: 10),
                          //   ),
                          // ),
                          ..._ingredientEntry,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _addField,
          label: const Text('Add Ingredient'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.pink.shade50,
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() && _pickedImage != null) return;
    _formKey.currentState!.save();

    try {
      setState(() {
        _isLoading = true;
      });
      // await Provider.of<FireStoreDB>(context, listen: false)
      // TODO get resName somehow and send it
      await firestore.addMeal(
        resName: 'resName',
        mealName: _mealName,
        price: _price.toString(),
        ingredients: _ingredients,
        img: _pickedImage!,
      );

      log('mealName $_mealName');
      log('price $_price');
      for (var i in _ingredients) {
        log('$i');
      }
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Meal added Successfully!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    // for (var item in _ingredients) {
    //   print(item);
    // }
    // setState(() {

    // });
  }

  void _addField() {
    setState(() {
      _ingredientEntry.add(
        _buildTextFormField(
          BoxConstraints(
            maxHeight: deviceSize.height,
            maxWidth: deviceSize.width,
          ),
          hintText: 'ingredient name',
          validator: (String? val) {
            if (val!.isEmpty) {
              return 'required!';
            }
            return null;
          },
          onSaved: (String? val) {
            _ingredients.add(val!);
          },
          keyboard: TextInputType.name,
        ),
      );
    });
  }

  Widget _buildTextFormField(
    BoxConstraints constraints, {
    required String hintText,
    required String? Function(String? val) validator,
    required void Function(String? val) onSaved,
    required TextInputType keyboard,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        right: constraints.maxWidth * 0.1,
        left: constraints.maxWidth * 0.1,
        bottom: 10,
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
