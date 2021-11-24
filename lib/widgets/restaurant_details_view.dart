import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/firestore.dart' as firestore;
import '../models/Restaurant.dart';
import './image_input.dart';

class ResDetails extends StatefulWidget {
  const ResDetails({Key? key}) : super(key: key);

  @override
  _ResDetailsState createState() => _ResDetailsState();
}

class _ResDetailsState extends State<ResDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey(debugLabel: 'resform-key');
  bool init = true;
  bool _isLoading = false;
  bool _readOnly = false;
  late final Size deviceSize;

  TextEditingController _openTimectrl = TextEditingController();
  TextEditingController _closeTimectrl = TextEditingController();

  // late List<String> resData;

  File? _pickedImage;
  String _resName = '';
  String _website = '';
  String _desc = '';
  String _openingHours = '';
  String _closingHours = '';
  String _imgUrl = '';
  String? _docId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      getResData();
      init = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _openTimectrl.dispose();
    _closeTimectrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // firestore.getRes().then((List<String> values) {
    //   for (var item in values) {
    //     print(item);
    //   }
    // });
    Size deviceSize = MediaQuery.of(context).size;
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
            if (!_readOnly)
              TextButton.icon(
                label: Text('Save'),
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
                          if (!_readOnly)
                            ImageInput(
                              _selectImage,
                              'images/restaurant.png',
                            ),
                          if (_readOnly)
                            Container(
                              // height: 150,
                              // width: 250,
                              constraints: BoxConstraints(
                                maxHeight: deviceSize.height * 0.2,
                                maxWidth: deviceSize.width * 0.8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 3.5, color: Colors.pink.shade50),
                              ),

                              child: Image.network(
                                _imgUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                loadingBuilder: (ctx, child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: LinearProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                              alignment: Alignment.center,
                            ),
                          SizedBox(height: 10),
                          _buildTextFormField(
                            constraints,
                            hintText: _readOnly ? _resName : 'restaurant name',
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'required!';
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              _resName = value!;
                            },
                            keyboard: TextInputType.name,
                          ),
                          SizedBox(height: 10),
                          _buildTextFormField(
                            constraints,
                            hintText: _readOnly ? _website : 'website',
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'required!';
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              _website = value!;
                            },
                            keyboard: TextInputType.name,
                          ),
                          SizedBox(height: 10),
                          _buildTextFormField(
                            constraints,
                            hintText: _readOnly ? _desc : 'description',
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'required!';
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              _desc = value!;
                            },
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
                                  hintText: _readOnly
                                      ? _openingHours
                                      : 'Opening time',
                                  controller: _openTimectrl,
                                  onTap: () async {
                                    TimeOfDay? selectedTime24Hour =
                                        await showTimePicker(
                                      context: context,
                                      initialTime:
                                          const TimeOfDay(hour: 09, minute: 15),
                                      builder: (BuildContext context,
                                          Widget? child) {
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
                                  hintText: _readOnly
                                      ? _closingHours
                                      : 'Closing time',
                                  controller: _closeTimectrl,
                                  onTap: () async {
                                    TimeOfDay? selectedTime24Hour =
                                        await showTimePicker(
                                      context: context,
                                      initialTime:
                                          const TimeOfDay(hour: 22, minute: 00),
                                      builder: (BuildContext context,
                                          Widget? child) {
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
      ),
    );
  }

  void getResData() async {
    setState(() {
      _isLoading = true;
    });
    List<String> resData = await firestore.getRes();
    if (!resData.contains('none')) {
      _resName = resData[0];
      _desc = resData[1];
      _website = resData[2];
      _openingHours = resData[3];
      _closingHours = resData[4];
      _imgUrl = resData[5];
      _docId = resData[6];
      String? phone = resData[7];
      _readOnly = true;
      Provider.of<Restaurant>(context, listen: false).addRes(
        docId: _docId!,
        resName: _resName,
        website: _website,
        desc: _desc,
        openTime: _openingHours,
        closeTime: _closingHours,
        imageUrl: _imgUrl,
        phone: phone,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _selectImage(File myPickedImage) {
    _pickedImage = myPickedImage;
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() && _pickedImage != null) return;
    _formKey.currentState!.save();
    try {
      setState(() {
        _isLoading = true;
      });
      // await Provider.of<FireStoreDB>(context, listen: false)
      _docId = await firestore.addRes(
        name: _resName,
        desc: _desc,
        website: _website,
        openTime: _openingHours,
        closeTime: _closingHours,
        img: _pickedImage!,
      );

      log('closing time: $_openingHours');
      log('opening time: $_closingHours');
      log('resName $_resName');
      log('desc $_desc');
      log('website $_website');
      log('img: ${_pickedImage!.path}');
      _openTimectrl.clear();
      _closeTimectrl.clear();
      getResData();
    } on Exception catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
        readOnly: _readOnly ? true : readOnly,
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
