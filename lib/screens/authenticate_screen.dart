import 'package:flex/models/auth_exception.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

import '../providers/auth.dart' as Auth;
import '../widgets/buttons.dart';
import '../utitlities/constants.dart';

class AuthenticateScreen extends StatefulWidget {
  final authType;
  const AuthenticateScreen(this.authType, {Key? key}) : super(key: key);

  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  late AuthMode _authMode;
  String _email = '';
  String _password = '';
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey(debugLabel: 'authform-key');
  UserMode userType = UserMode.Restaurant;

  @override
  void initState() {
    super.initState();
    _authMode = widget.authType;
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
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
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
        ),
        body: LayoutBuilder(
          builder: (ctx, constraints) => Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Text(
                    _authMode == AuthMode.Login
                        ? 'Welcome Back!'
                        : 'Create an account',
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  // Expanded(
                  //   flex: 3,
                  // child: SingleChildScrollView(
                  // child:
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.1,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            hintText: 'Phone/Email',
                          ),
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Invalid email!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.1,
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _authMode == AuthMode.Login,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            hintText: 'Password',
                          ),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 5) {
                              return 'Password length must be 6!';
                            }
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      if (_authMode == AuthMode.Signup)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.1,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade300,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              hintText: 'Confirm Password',
                            ),
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                            },
                            onSaved: (value) {
                              _password = value!;
                            },
                          ),
                        ),
                      _userTypeSelector(),
                    ],
                  ),
                  //   ),
                  // ),
                  Spacer(),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    buildYellowButton(
                      handler: () {
                        _submit();
                      },
                      child: Text(
                        _authMode == AuthMode.Signup ? 'SIGN UP' : 'LOG IN',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
                      h: constraints.maxHeight * 0.1,
                      w: constraints.maxWidth * 0.8,
                      radius: 30.0,
                    ),
                  if (_authMode == AuthMode.Login)
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Auth.login(
          _email,
          _password,
          userType == UserMode.Restaurant ? 'restaurant' : 'customer',
        );
      } else {
        // Sign user up
        await Auth.signup(
          _email,
          _password,
          userType == UserMode.Restaurant ? 'restaurant' : 'customer',
        );
      }
      Navigator.pop(context);
    } on AuthException catch (error) {
      final errorMessage = error.toString();
      await _showErrorDialog(errorMessage);
    } catch (error) {
      final errorMessage = error.toString();
      await _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });

    // Navigator.pushNamedAndRemoveUntil(
    //     context, '/', (Route<dynamic> route) => false);
  }

  Future<void> _showErrorDialog(String message) {
    print(message);
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error Occured'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  Row _userTypeSelector() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          // disabledColor: Colors.white,
          backgroundColor:
              userType != UserMode.Restaurant ? Colors.white : null,
          side: userType != UserMode.Restaurant
              ? BorderSide(width: 1.0, color: Colors.grey)
              : null,
          label: Text('Restaurant'),
          selected: userType == UserMode.Restaurant,
          onSelected: (selected) {
            setState(() {
              userType = selected ? UserMode.Restaurant : UserMode.Customer;
            });
          },
        ),
        SizedBox(width: 10),
        ChoiceChip(
          // disabledColor: Colors.white,
          backgroundColor: userType != UserMode.Customer ? Colors.white : null,
          side: userType != UserMode.Customer
              ? BorderSide(width: 1.0, color: Colors.grey)
              : null,
          label: Text('Customer'),
          selected: userType == UserMode.Customer,
          onSelected: (selected) {
            setState(() {
              userType = selected ? UserMode.Customer : UserMode.Restaurant;
            });
          },
        ),
      ],
    );
  }
}
