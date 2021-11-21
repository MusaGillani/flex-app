import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';

import './image_input.dart';

class ResDetails extends StatefulWidget {
  const ResDetails({Key? key}) : super(key: key);

  @override
  _ResDetailsState createState() => _ResDetailsState();
}

class _ResDetailsState extends State<ResDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey(debugLabel: 'resform-key');
  bool init = true;
  bool _readOnly = false;
  late final Size deviceSize;

  TextEditingController _openTimectrl = TextEditingController();
  TextEditingController _closeTimectrl = TextEditingController();

  File? _pickedImage;
  String _resName = '';
  String _website = '';
  String _desc = '';
  String _openingHours = '';
  String _closingHours = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {}
    init = false;
  }

  @override
  void dispose() {
    super.dispose();
    _openTimectrl.dispose();
    _closeTimectrl.dispose();
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
      child: GestureDetector(
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
              'Restaurants',
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
                child: SingleChildScrollView(
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
                      _buildTextFormField(
                        constraints,
                        hintText: 'website',
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
                        hintText: 'description',
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
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextFormField(
                              constraints,
                              right: false,
                              readOnly: true,
                              hintText: 'Opening time',
                              controller: _openTimectrl,
                              onTap: () async {
                                TimeOfDay? selectedTime24Hour =
                                    await showTimePicker(
                                  context: context,
                                  initialTime:
                                      const TimeOfDay(hour: 09, minute: 15),
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child!,
                                    );
                                  },
                                );
                                if (selectedTime24Hour != null) {
                                  _openTimectrl.text =
                                      selectedTime24Hour.format(context);
                                }
                              },
                              validator: (String? value) {
                                if (value!.isEmpty) return 'required!';
                                return null;
                              },
                              onSaved: (String? value) {
                                _openingHours = value!;
                              },
                              keyboard: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _buildTextFormField(
                              constraints,
                              left: false,
                              readOnly: true,
                              hintText: 'Closing time',
                              controller: _closeTimectrl,
                              onTap: () async {
                                TimeOfDay? selectedTime24Hour =
                                    await showTimePicker(
                                  context: context,
                                  initialTime:
                                      const TimeOfDay(hour: 09, minute: 15),
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child!,
                                    );
                                  },
                                );
                                if (selectedTime24Hour != null) {
                                  _closeTimectrl.text =
                                      selectedTime24Hour.format(context);
                                }
                              },
                              validator: (String? value) {
                                if (value!.isEmpty) return 'required!';
                                return null;
                              },
                              onSaved: (String? value) {
                                _closingHours = value!;
                              },
                              keyboard: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
      ),
    );
  }

  void _selectImage(File myPickedImage) {
    _pickedImage = myPickedImage;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    log('closing time: $_openingHours');
    log('opening time: $_closingHours');
    // for (var item in _ingredients) {
    //   print(item);
    // }
    // setState(() {

    // });
  }

  Widget _buildTextFormField(
    BoxConstraints constraints, {
    bool left = true,
    bool right = true,
    bool readOnly = false,
    void Function()? onTap,
    TextEditingController? controller,
    required String hintText,
    required String? Function(String? val) validator,
    required void Function(String? val) onSaved,
    required TextInputType keyboard,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        right: right ? constraints.maxWidth * 0.1 : 0,
        left: left ? constraints.maxWidth * 0.1 : 0,
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboard,
        onTap: onTap,
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
