import 'dart:io';

import 'package:flutter/material.dart';

import './image_input.dart';

class ResDetails extends StatefulWidget {
  const ResDetails({Key? key}) : super(key: key);

  @override
  _ResDetailsState createState() => _ResDetailsState();
}

class _ResDetailsState extends State<ResDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey(debugLabel: 'resform-key');
  File? _pickedImage;

  bool init = true;
  bool _readOnly = false;
  late final Size deviceSize;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {}
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.pink.shade50,
          title: Text(
            'Restaurants',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
          ),
          centerTitle: true,
          actions: [
            TextButton.icon(
              label: Text('Save'),
              icon: Icon(Icons.check),
              onPressed: _submit,
              style: TextButton.styleFrom(primary: Colors.black),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (
            ctx,
            constraints,
          ) =>
              Form(
            key: _formKey,
            child: Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  ImageInput(_selectImage, 'images/restaurant.png'),
                  SizedBox(height: 10),
                  _buildTextFormField(
                    constraints,
                    hintText: 'restaurant name',
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
                  // _buildTextFormField(
                  //   constraints,
                  //   hintText: 'price \$',
                  //   validator: (String? value) {
                  //     if (value!.isEmpty) {
                  //       return 'required!';
                  //     }
                  //     return null;
                  //   },
                  //   onSaved: (String? value) {},
                  //   keyboard: TextInputType.number,
                  // ),
                  // SizedBox(height: 10),
                  // Text('Enter Ingredients: '),
                  // Expanded(
                  //   child: ListView.separated(
                  //     itemCount: _ingredientEntry.length,
                  //     itemBuilder: (_, i) => _ingredientEntry[i],
                  //     separatorBuilder: (_, i) => SizedBox(height: 10),
                  //   ),
                  // ),
                  // ..._ingredientEntry,
                ],
              ),
            ),
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: null,
        //   label: const Text('Save'),
        //   icon: const Icon(Icons.check),
        //   backgroundColor: Colors.pink.shade50,
        // ),
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
        readOnly: _readOnly,
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
