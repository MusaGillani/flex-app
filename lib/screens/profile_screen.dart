import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../providers/auth.dart';
import '../providers/firestore.dart' as firestore;
import '../models/Restaurant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(this.isRes, {Key? key}) : super(key: key);
  final bool isRes;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey(debugLabel: 'profileForm-key');
  var _readOnly = false;
  var _isLoading = false;
  String? _email;
  String? _username;
  String? _phoneNo;

  void getData(bool isRes) async {
    setState(() {
      _isLoading = true;
    });
    final resData = Provider.of<Restaurant>(context).resData;
    _email = FirebaseAuth.instance.currentUser!.email;
    if (isRes) {
      _username = resData['resName'];
    }
    _phoneNo = resData['phone'];
    setState(() {
      _isLoading = false;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(Duration.zero).then((_) => getData());
  // }

  @override
  Widget build(BuildContext context) {
    getData(widget.isRes);
    return LayoutBuilder(
      builder: (
        ctx,
        constraints,
      ) =>
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'images/Logo.jpeg',
                            fit: BoxFit.contain,
                            height: constraints.maxHeight * 0.4,
                            width: constraints.maxWidth * 0.8,
                          ),
                          if (widget.isRes) ...[
                            Text('Username'),
                            _buildTextFormField(
                              constraints,
                              hintText: _username != null
                                  ? _username!
                                  : 'Enter name in Home screen',
                              readOnly: true,
                              validator: _readOnly ? null : (validator) {},
                              onSaved: _readOnly ? null : (onSaved) {},
                              keyboard: TextInputType.name,
                            ),
                          ],
                          Text('email'),
                          _buildTextFormField(
                            constraints,
                            hintText: _email!,
                            readOnly: true,
                            validator: null,
                            onSaved: null,
                            keyboard: TextInputType.emailAddress,
                          ),
                          Text('phone no.'),
                          _buildTextFormField(
                            constraints,
                            readOnly: _phoneNo != null,
                            hintText:
                                _phoneNo != null ? _phoneNo! : 'Enter phone no',
                            validator: _phoneNo != null
                                ? null
                                : (validator) {
                                    if (validator!.isEmpty) {
                                      return 'required';
                                    }
                                    return null;
                                  },
                            onSaved: _phoneNo != null
                                ? null
                                : (phone) {
                                    _phoneNo = phone;
                                  },
                            keyboard: TextInputType.phone,
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                FirebaseAuth.instance.sendPasswordResetEmail(
                                    email: FirebaseAuth.instance.currentUser!
                                        .email!); // FirebaseAuth.instance.sendPasswordResetEmail(
                                await showDialog<void>(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        title: Text('Email has been sent!'),
                                        content: Text(
                                            'Check your inbox for ${FirebaseAuth.instance.currentUser!.email!} to reset the password'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            child: Text('Okay'),
                                          ),
                                        ],
                                      );
                                    });
                              } on Exception catch (e) {
                                // print(e.toString());
                                await showDialog<void>(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        title: Text(e.toString()),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            child: Text('Okay'),
                                          ),
                                        ],
                                      );
                                    });
                              }
                              // FirebaseAuth.instance.re
                            },
                            child: Text('Change password'),
                          ),
                          TextButton.icon(
                            onPressed: () =>
                                Provider.of<Auth>(context, listen: false)
                                    .logout(),
                            icon: Icon(Icons.exit_to_app),
                            label: Text('Sign Out'),
                            // style: ElevatedButton.styleFrom(
                            //   onPrimary: Colors.white,
                            // ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    if (widget.isRes) {
      await firestore.addResPhone(_phoneNo!);
      // Provider.of<Restaurant>(context, listen: false).resPhone = _phoneNo!;
    } else {
      await firestore.addCusPhone(_phoneNo!);
      _phoneNo = await firestore.getCusPhone();
    }

    /// using same res model for storting the cus phone
    /// as the res model is only used in res type for other data provided

    Provider.of<Restaurant>(context, listen: false).resPhone = _phoneNo!;
  }

  Widget _buildTextFormField(
    BoxConstraints constraints, {
    String? hintText,
    String? labelText,
    required String? Function(String? val)? validator,
    required void Function(String? val)? onSaved,
    required TextInputType keyboard,
    void Function()? onEditingComplete,
    bool readOnly = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        right: constraints.maxWidth * 0.1,
        left: constraints.maxWidth * 0.1,
        bottom: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              keyboardType: keyboard,
              readOnly: readOnly,
              onEditingComplete: onEditingComplete,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                hintText: hintText,
                labelText: labelText,
              ),
              validator: validator,
              onSaved: onSaved,
            ),
          ),
          if (keyboard == TextInputType.phone && !readOnly)
            IconButton(onPressed: _submit, icon: Icon(Icons.save)),
        ],
      ),
    );
  }
}
