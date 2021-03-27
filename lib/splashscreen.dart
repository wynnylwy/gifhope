import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'mainscreen.dart';
import 'user.dart';
import 'package:toast/toast.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double screenHeight;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gifhope',
      home: Scaffold(
          body: Center(
        child: TweenAnimationBuilder(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(seconds: 3),
            builder: (context, value, child) {
              return Center(
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      ShaderMask(
                        shaderCallback: (rect) {
                          return SweepGradient(
                                  startAngle: 0.0,
                                  endAngle: 3.14 * 2,
                                  stops: [value, value],  //start & end stop value
                                  center: Alignment.center,
                                  colors: [Colors.red[400], Colors.grey]) //loading & base color
                              .createShader(rect);
                        },
                        child: Center(
                           child: Container(
                              width: 330,
                              height: 330,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image: AssetImage('assets/images/loading.png'),
                                      ))
                                   ),
                        ),
                      ),

                      Center(
                        child: Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage('assets/images/hand.png')
                            ),
                          ),
                         child: ProgressIndicator()
                        ),
                         
                      ),
                    ],
                  ),
                ),
              );
            }),
      )),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          //updating states
          if (animation.value > 0.99) {
            controller.stop();
            loadpref(this.context);
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
          width: 300,
          ),
    );
  }

  void loadpref(BuildContext ctx) async {
    print('Inside loadpred()');

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String email = (preferences.getString('email') ?? '');
    String pass = (preferences.getString('pass') ?? '');
    print("Splash-> Preference: " + email + "/" + pass);

    if (email.length > 5) {
      loginUser(email, pass, ctx);
    } else {
      loginUser("unregistered", "123456789", ctx);
    }
  }

  Future<void> loginUser(String email, String pass, BuildContext ctx) async {
    await http
        .post("https://yitengsze.com/a_gifhope/php/login_user.php", body: {
      "email": email,
      "password": pass,
    }).then((res) {
      print(res.body);

      var string = res.body;
      List userdata = string.split(","); //split data by using ','
      if (userdata[0].contains("success")) {
        User _user = new User(
            //follow login_user.php arrange de
            name: userdata[1],
            email: email,
            password: pass, //pass 'pass' to user.password
            phone: userdata[3],
            credit: userdata[4],
            datereg: userdata[5],
            quantity: userdata[6]);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(user: _user)));
      } else {
        Toast.show("Failed. Login as unregistered user ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        loginUser("unregistered@carvroom.com", "123456789", ctx);
      }
    }).catchError((err) {
      print(err);
    });
  }
}
