import 'package:flutter/material.dart';
import 'package:gifhope/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';


class ResetPasswordScreen extends StatefulWidget {
  final String email;

  ResetPasswordScreen({Key key, this.email}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
 // TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
 // TextEditingController emailForgotController = new TextEditingController();
  TextEditingController passResetController = new TextEditingController();

  bool _showPass = false;
  String password;
  String email;
  bool _passwordShow = false;
  bool autoValidate = false;
  final formKeyForResetEmail = GlobalKey<FormState>();
  final formKeyForResetPassword = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
      //resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.yellow[100],
      body: Stack(
              children: <Widget>
              [
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
              key: formKeyForResetPassword,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 15, 10),
                child: TextFormField(
                    controller: passController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      hintText: 'Enter new password',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 45,
                        vertical: 20,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPass = !_showPass;
                          });
                        },
                        child: Icon(
                            _showPass ? Icons.visibility : Icons.visibility_off),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide(color: Colors.black),
                        gapPadding: 10,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide(color: Colors.blue),
                        gapPadding: 10,
                      ),
                    ),
                    obscureText: !_showPass,
                    validator: passValidate,
                    onSaved: (String value) {
                      password = value;
                    }),
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
                child: Text('Reset',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    )),
                color: Colors.blue[500],
                textColor: Colors.black,
                elevation: 20,
                onPressed: () {
                  if (formKeyForResetPassword.currentState.validate()) {
                    passResetController.text = passController.text;
                    _resetPass();
                    
                  }
                }
                
                ),

                
          ],
        ),

              ]
               
      ),
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

  String passValidate(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 5) {
      return 'Password length must be 5 digits or above';
    }
    return null;
  }

  _resetPass() {
    String email = widget.email;
    String password = passResetController.text;

    final form = formKeyForResetPassword.currentState;

    if (form.validate()) {
      form.save();
      http.post("https://yitengsze.com/a_gifhope/php/reset_password.php", body: {
        "email": email,
        "password": password,
      }).then((res) {
        print(res.body);
        if (res.body.contains("success")) {
          Navigator.of(context).pop();
          Toast.show("Reset password success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

          Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        LoginScreen()));
        } else {
          Toast.show("Reset password failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }
}
