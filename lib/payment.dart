import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'user.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final String orderid, val;
  PaymentScreen({this.user, this.orderid, this.val, });

  @override
  _PaymentScreen createState() => _PaymentScreen();
}

class _PaymentScreen extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  User user;
  String orderid, val;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    orderid = widget.orderid;
    val = widget.val;
  }
 
  @override
  Widget build(BuildContext context) {
   
        return Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      const Color(0xFFFF8A65),
                      const Color(0xFFFFCA28),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            title: Text('Payment',
                style: TextStyle(
                    fontFamily: 'Sofia',
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Colors.white)),
          ),
          body: Center(
            //be center
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: WebView(
                      initialUrl:
                          'http://yitengsze.com/a_gifhope/php/payment.php?email=' + widget.user.email +
                              '&mobile=' + widget.user.phone +
                              '&name=' + widget.user.name +
                              '&amount=' + widget.val +
                              '&orderid=' + widget.orderid,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller.complete(webViewController);
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    minWidth: 150,
                    height: 50,
                    child: Column(
                      children: <Widget>[
                        Icon(MdiIcons.share),

                        Text('Share Receipt',
                          style: TextStyle(
                            fontSize: 20.0,
                          )),

                      ],
                    ),
                    color: Colors.blue[500],
                    textColor: Colors.white,
                    elevation: 10,
                    onPressed: () => {
                      share (context, user, orderid, val),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future <void> share (BuildContext context, User user, String orderid, String val) async
  {
    final RenderBox box = context.findRenderObject();
    final String text1 = " You've done your payment successfully!";
    final String text2 = " Here's your receipt \n Name: ${widget.user.name} \n Contact: ${widget.user.phone} \n Email: ${widget.user.email} \n Order id: ${widget.orderid} \n Amount: RM ${widget.val} \n THANK YOU! ";
    
    await Share.share (
      text2, 
      subject: text1,
      sharePositionOrigin: box.localToGlobal (Offset.zero) & box.size,
    );
  }
}
