import 'package:flutter/material.dart';

class MealForm extends StatefulWidget {
  const MealForm({Key? key}) : super(key: key);

  @override
  _MealFormState createState() => _MealFormState();
}

class _MealFormState extends State<MealForm> {
  final GlobalKey<FormState> _formKey = GlobalKey(debugLabel: 'mealform-key');
  // String? _dropDownValue = 'Fruits';

  List<Widget> _ingredientEntry = [];
  List<String> _ingredients = [];

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
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _submit,
            ),
          ],
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
                  Expanded(
                    child: ListView.separated(
                      itemCount: _ingredientEntry.length,
                      itemBuilder: (_, i) => _ingredientEntry[i],
                      separatorBuilder: (_, i) => SizedBox(height: 10),
                    ),
                  ),
                  // ..._ingredientEntry,
                ],
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
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

  // Widget _buildIngredientSelector() {
  //   return ListTile(
  //     title: _buildTextFormField(constraints, hintText: hintText, validator: validator, onSaved: onSaved, keyboard: keyboard),
  //   );
  // }

  Widget _buildTextFormField(
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
