import 'package:flutter/material.dart';
import 'package:gifhope/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double screenHeight;
  bool _isChecked = false;
  String urlRegister = "https://yitengsze.com/a_gifhope/php/signup_user.php";
  TextEditingController _idEditingController = new TextEditingController();
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();
  TextEditingController _contactEditingController = new TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  bool _showPass = false;

  String id;
  String name;
  String selectedGender;
  String email;
  String contact;
  String selectedIdentity;
  String password;

  List<String> listGender = ["Men", "Women"];

  List<String> listIdentity = ["Shopper", "Seller"];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'Material App',
      home: Scaffold(
          resizeToAvoidBottomInset:false,
          //resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.yellow[100],
          body: Stack(
            children: <Widget>[
              // upperHalf(context),
              lowerHalf(context),
              pageTitle(),
            ],
          )),
    );
  }

  // Widget upperHalf(BuildContext context) {
  //   return Container(
  //     height: screenHeight / 2,
  //     child: Image.asset(
  //       'assets/images/register.png',
  //       fit: BoxFit.cover,
  //     ),
  //   );
  // }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: 600,
      margin: EdgeInsets.only(top: screenHeight / 5),
      padding: EdgeInsets.only(left: 0, right: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Form(
                  key: formKey,
                  autovalidate: autoValidate,
                  child: Column(
                    children: <Widget>[

                      TextFormField(
                          controller: _idEditingController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: 'ID',
                              hintText: 'Enter ID',
                              hintMaxLines: 15,
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 45,
                                vertical: 20,
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(20, 10, 15, 10),
                                child: Icon(Icons.tag),
                              ),
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
                          // maxLength: 15,
                          validator: idValidate,
                          onSaved: (String value) {
                            id = value;
                          }),

                      SizedBox(height: 15),

                      TextFormField(
                          controller: _nameEditingController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: 'Name',
                              hintText: 'Enter name',
                              hintMaxLines: 15,
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 45,
                                vertical: 20,
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(20, 10, 15, 10),
                                child: Icon(Icons.person),
                              ),
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
                          // maxLength: 15,
                          validator: nameValidate,
                          onSaved: (String value) {
                            name = value;
                          }),
                      
                      Padding(
                          padding: EdgeInsets.fromLTRB(48, 0, 15, 0),
                          child: Row(
                            children: [
                              Text('Gender: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                  )),
                              SizedBox(width: 25),
                              DropdownButton(
                                  hint: Text('Select gender'),
                                  value: selectedGender,
                                  items: listGender.map((selectedGender) {
                                    return DropdownMenuItem(
                                        child: new Text(
                                          selectedGender,
                                          textAlign: TextAlign.center,
                                        ),
                                        value: selectedGender);
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedGender = newValue;
                                      print(selectedGender);
                                    });
                                  })
                            ],
                          )),

                      SizedBox(height: 5),

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

                      SizedBox(height: 15),

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

                      SizedBox(height: 15),

                      TextFormField(
                        controller: _contactEditingController,
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          labelText: 'Contact',
                          hintText: 'Enter contact number',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 15, 10),
                              child: Icon(Icons.phone,
                              ),
                            ),
                           contentPadding: EdgeInsets.symmetric(
                              horizontal: 45,
                              vertical: 20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                              borderSide: BorderSide(color: Colors.black),
                              gapPadding: 10,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                              borderSide: BorderSide(color: Colors.blue),
                              gapPadding: 10,
                            )
                        ),
                        validator: contactValidate,
                        onSaved: (String value) {
                          contact = value;
                        },
                      ),
                      
                      SizedBox(height: 5),

                      Padding(
                          padding: EdgeInsets.fromLTRB(48, 0, 15, 10),
                          child: Row(
                            children: [
                              Text('Identity: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                  )),
                              SizedBox(width: 25),
                              DropdownButton(
                                  hint: Text('Select identity'),
                                  value: selectedIdentity,
                                  items: listIdentity.map((selectedIdentity) {
                                    return DropdownMenuItem(
                                        child: new Text(
                                          selectedIdentity,
                                          textAlign: TextAlign.center,
                                        ),
                                        value: selectedIdentity);
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedIdentity = newValue;
                                      print(selectedIdentity);
                                    });
                                  })
                            ],
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Checkbox(
                            value: _isChecked,
                            onChanged: (bool value) {
                              _onChange(value);
                            },
                          ),
                          GestureDetector(
                            onTap: _showEULA,
                            child: Text('I Agree to Terms  ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            minWidth: 120,
                            height: 50,
                            child: Text('Sign Up',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                            color: Colors.blue,
                            textColor: Colors.white,
                            elevation: 5,
                            onPressed: _onRegister,
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
                Text("Already sign up? ", style: TextStyle(fontSize: 18)),
                GestureDetector(
                  onTap: _loginScreen,
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget pageTitle() {
    return Container(
      //color: Color.fromRGBO(255, 200, 200, 200),
      margin: EdgeInsets.only(top: 60),
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
            " Sign Up",
            style: TextStyle(
                fontSize: 50,
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontFamily: 'Mogra'),
          )
        ],
      ),
    );
  }

  String idValidate(String value) {
    if (value.isEmpty) {
      return 'ID is required';
    }

    return null;
  }

  String nameValidate(String value) {
    if (value.isEmpty) {
      return 'Name is required';
    }

    return null;
  }

  String emailValidate(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    }

    if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value)) {
      return 'Please enter a valid email ddress';
    }

    return null;
  }

  String passValidate(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 4) {
      return 'Password length must be 5 digits above';
    }
    return null;
  }

  String contactValidate(String value) {
    if (value.isEmpty) {
      return 'Phone is required';
    }

    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }

    return null;
  }

  _onRegister() {
    String id = _idEditingController.text;
    String name = _nameEditingController.text;
    String gender = selectedGender;
    String identity = selectedIdentity;
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    String contact = _contactEditingController.text;
    final form = formKey.currentState;

    if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (form.validate()) {
      form.save();
      http.post(urlRegister, body: {
        "id": id,
        "name": name,
        "gender": gender,
        "email": email,
        "password": password,
        "identity": identity,
        "contact": contact,
      }).then((res) {
        print(res.body);
        if (res.body.contains("success")) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()));
          Toast.show("Success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } else {
          Toast.show("Failed, ID has been registered", context,
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

  void _loginScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  void _showEULA() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Terms & Conditons"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and yitengsze website. This EULA agreement governs your acquisition and use of our Gifhope mobile application (Software) directly from yitengsze or indirectly through a yitengsze authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the Gifhope software. It provides a license to use the Gifhope software and contains warranty information and liability disclaimers. If you register for a free trial of the Gifhope software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the Gifhope software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by yitengsze here with regardless of whether other software is referred to or described herein. The terms also apply to any yitengsze updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for carVroom. carVroom shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of yitengsze. yitengsze reserves the right to grant licences to use the Software to third parties")),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
