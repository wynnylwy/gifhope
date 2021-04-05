import 'package:flutter/material.dart';
import 'package:gifhope/resetpasswordscreen.dart';

class ForgetpasswordScreen extends StatefulWidget {
  @override
  _ForgetpasswordScreenState createState() => _ForgetpasswordScreenState();
}

class _ForgetpasswordScreenState extends State<ForgetpasswordScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController emailForgotController = new TextEditingController();
  TextEditingController passResetController = new TextEditingController();
  bool _passwordShow = false;
  // bool _showPass = false;
  String password;
  String email;
  final formKeyForResetEmail = GlobalKey<FormState>();
  final formKeyForResetPassword = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
      //resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.yellow[100],
      body: Stack(children: <Widget>[
        pageTitle(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Please insert:",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: 15,
            ),
            Form(
              key: formKeyForResetEmail,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 15, 10),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'xxxxxx@xxxx.com',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 15, 10),
                        child: Icon(
                          Icons.email,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 45, vertical: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide(color: Colors.black),
                        gapPadding: 10,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide(color: Colors.blue),
                        gapPadding: 10,
                      )),
                  validator: emailValidate,
                  onSaved: (String value) {
                    email = value;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                minWidth: 280,
                height: 50,
                child: Text('Confirm',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                color: Colors.blue[500],
                textColor: Colors.black,
                elevation: 20,
                onPressed: () {
                  if (formKeyForResetEmail.currentState.validate()) {
                    _passwordShow = false;
                    emailForgotController.text = emailController.text;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ResetPasswordScreen(
                                  email: emailForgotController.text,
                                )));
                  }
                }),
          ],
        ),
      ]),
    );
  }

  Widget pageTitle() {
    return Container(
      margin: EdgeInsets.only(top: 80),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.volunteer_activism,
            size: 50,
            color: Colors.black,
          ),
          Text(
            " Reset Password",
            style: TextStyle(
                fontSize: 40,
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontFamily: 'Mogra'),
          )
        ],
      ),
    );
  }

  String emailValidate(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    }

    if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }
}
