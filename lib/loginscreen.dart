import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gifhope/cadminMainScreen.dart';
import 'package:gifhope/forgetpasswordscreen.dart';
import 'package:gifhope/registerscreen.dart';
import 'package:gifhope/mainscreen.dart';
import 'package:gifhope/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(LoginScreen());
bool rememberMe = false;
String password, email;
var string;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenHeight;
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();
  TextEditingController emailForgotController = new TextEditingController();
  TextEditingController passResetController = new TextEditingController();
  String urlLogin = "https://yitengsze.com/a_gifhope/php/login_user.php";
  final formKey = GlobalKey<FormState>();
  final formKeyForResetEmail = GlobalKey<FormState>();
  final formKeyForResetPassword = GlobalKey<FormState>();
  bool autoValidate = false;
  bool _showPass = false;
  bool _passwordShow = false;

  @override
  void initState() {
    super.initState();
    print("Hello i'm in INITSTATE");
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          resizeToAvoidBottomInset:false,
         // resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.yellow[100],
          body: Stack(
            children: <Widget>[
              upperHalf(context),
              lowerHalf(context),
              pageTitle(),
            ],
          )),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      child: Image.asset(
        'assets/images/hand.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: screenHeight / 1.3,
      margin: EdgeInsets.only(top: screenHeight / 2.5),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      controller: _emailEditingController,
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
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 45, vertical: 20),
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
                    SizedBox(height: 15.0),
                    TextFormField(
                        controller: _passEditingController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter password',
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
                            child: Icon(_showPass
                                ? Icons.visibility
                                : Icons.visibility_off),
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
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Checkbox(
                          value: rememberMe,
                          onChanged: (bool value) {
                            _onRememberMeChanged(value);
                          },
                        ),
                        Text('Remember Me ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          minWidth: 100,
                          height: 50,
                          child: Text('Login',
                              style: TextStyle(
                                fontSize: 20,
                              )),
                          color: Colors.yellow[300],
                          textColor: Colors.black,
                          elevation: 20,
                          onPressed: _userLogin,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Don't have an account? ", style: TextStyle(fontSize: 16.0)),
              GestureDetector(
                onTap: _registerUser,
                child: Text(
                  "Create Account",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Forgot your password? ", style: TextStyle(fontSize: 16.0)),
              GestureDetector(
                  child: Text(
                    "Reset Password",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ForgetpasswordScreen()));
                  }),
            ],
          )
        ],
      ),
    );
  }

  Widget pageTitle() {
    return Container(
      margin: EdgeInsets.only(top: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Welcome To Givehope",
            style: TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontFamily: 'Mogra',
            ),
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

  String passValidate(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 5) {
      return 'Password length must be 5 digits above';
    }
    return null;
  }

  void _userLogin() async {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Log in...");
      pr.show();

      String email = _emailEditingController.text;
      String password = _passEditingController.text;
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();
        http.post(urlLogin, body: {
          "email": email,
          "password": password,
        }).then((res) {
          print(res.body);
          string = res.body;
          List userdata = string.split(",");

          if (userdata[0].contains("success")) {
            User _user = new User(
                name: userdata[1],
                email: email,
                password: password,
                phone: userdata[3],
                credit: userdata[4],
                datereg: userdata[5],
                quantity: userdata[6],
                donation: userdata[7]);
            pr.hide();

            Toast.show("Login success", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

            if (userdata[2].contains("charityadmin@gifhope.com")) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          CharityAdminMainScreen(user: _user)));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          MainScreen(user: _user)));
            }
          } else {
            pr.hide();
            Toast.show("Login failed", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        }).catchError((err) {
          print(err);
          pr.hide();
        });
      }
    } //try

    on Exception catch (_) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<bool> _registerUser() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
              title: Row(children: [
                Image.network(
                  'https://www.nicepng.com/png/full/504-5044454_login-add-user-button-profile-en-png.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
                Text('  Register Confirmation'),
              ]),
              content: new Text('Would you like to create a new account?'),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                RegisterScreen()));
                  },
                ),
                MaterialButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ]),
        ) ??
        false;
  }

  _forgotPassword() {
    TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Forgot Password?"),
          content: new Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter your email: ",
                  ),
                ),
                Form(
                    key: formKeyForResetEmail,
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email)),
                      validator: emailValidate,
                      onSaved: (String value) {
                        email = value;
                      },
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  if (formKeyForResetEmail.currentState.validate()) {
                    _passwordShow = false;
                    emailForgotController.text = emailController.text;
                    _enterResetPass();
                  }
                }),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  _enterResetPass() {
    TextEditingController passController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Text("New password"),
              content: new Container(
                height: 100,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Enter your new password:",
                      ),
                    ),
                    Form(
                        key: formKeyForResetPassword,
                        child: TextFormField(
                            controller: passController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              icon: Icon(Icons.lock),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _passwordShow = !_passwordShow;
                                  });
                                },
                                child: Icon(_passwordShow
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                            obscureText: !_passwordShow,
                            validator: passValidate,
                            onSaved: (String value) {
                              password = value;
                            }))
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                    child: new Text("Yes"),
                    onPressed: () {
                      if (formKeyForResetPassword.currentState.validate()) {
                        passResetController.text = passController.text;
                        _resetPass();
                      }
                    }),
                new FlatButton(
                  child: new Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  _resetPass() {
    String email = emailForgotController.text;
    String password = passResetController.text;

    final form = formKeyForResetPassword.currentState;

    if (form.validate()) {
      form.save();
      http.post("https://yitengsze.com/carVroom/php/reset_password.php", body: {
        "email": email,
        "password": password,
      }).then((res) {
        print(res.body);
        if (res.body.contains("success")) {
          Navigator.of(context).pop();
          Toast.show("Reset password success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        print(rememberMe);
        if (rememberMe) {
          savepref(true);
        } else {
          savepref(false);
        }
      });

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text("Exit")),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Cancel")),
            ],
          ),
        ) ??
        false;
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
        rememberMe = true;
      });
    }
  }

  void savepref(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Toast.show("Preferences have been saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
