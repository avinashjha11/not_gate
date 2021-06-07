import 'package:flutter/material.dart';
import 'package:gradient_input_border/gradient_input_border.dart';
import 'package:not_gatew/authenticate/authentication.dart';
import '../colours.dart';
import '../error_handler.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = new GlobalKey<FormState>();

  String email, password;

  //To check fields during submit
  checkFields() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(child: Form(key: formKey, child: _buildSignupForm())));
  }

  _buildSignupForm() {
    var textStyle = TextStyle(fontSize: 18.0);
    var linearGradient =
        LinearGradient(colors: [Constants.oorange, Constants.orange]);
    var gradientOutlineInputBorder = GradientOutlineInputBorder(
        borderRadius: BorderRadius.circular(18.0),
        focusedGradient: linearGradient,
        unfocusedGradient:
            LinearGradient(colors: [Constants.black_s3, Constants.black_s3]));
    var textStyle2 = TextStyle(color: Colors.white, fontSize: 18);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.black_s1,
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 55,
                ),
                Text(
                  "SignUp",
                  style: TextStyle(fontSize: 75.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Email',
                  style: textStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: textStyle2,
                  decoration: InputDecoration(
                      hintText: 'Enter your email',
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 16.0),
                      fillColor: Constants.black_s2,
                      border: gradientOutlineInputBorder),
                  onChanged: (value) {
                    this.email = value;
                  },
                  validator: (value) => value.isEmpty
                      ? 'Email is required'
                      : validateEmail(value),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Password',
                  style: textStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    obscureText: true,
                    style: textStyle2,
                    decoration: InputDecoration(
                        hintText: 'Pick a strong password',
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 16.0),
                        fillColor: Constants.black_s2,
                        border: gradientOutlineInputBorder),
                    onChanged: (value) {
                      this.password = value;
                    },
                    validator: (value) =>
                        value.isEmpty ? 'Password is required' : null),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    if (checkFields())
                      AuthService().signUp(email, password).then((userCreds) {
                        Navigator.of(context).pop();
                      }).catchError((e) {
                        ErrorHandler().errorDialog(context, e);
                      });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
                        gradient: linearGradient),
                    child: Text(
                      'Create Account',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.white54, fontSize: 16.0),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Log in',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
