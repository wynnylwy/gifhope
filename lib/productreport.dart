import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'user.dart';

class ProductReport extends StatefulWidget {
  final User user;
  final String bookid, val;
  ProductReport({
    this.user,
    this.bookid,
    this.val,
  });

  @override
  _ProductReport createState() => _ProductReport();
}

class _ProductReport extends State<ProductReport> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List carsdata;
  double screenHeight, screenWidth;
  String titlecenter = "Cars record is not found";
  var user;
  int rowLength = 0;

  @override
  void initState() {
    super.initState();

    _loadReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    const Color(0xFF3366FF),
                    const Color(0xFF00CCFF),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          title: Text('Cars Report ',
              style: TextStyle(
                  fontFamily: 'Sofia',
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.white)),
        ),
        backgroundColor: Colors.blue[100],
        resizeToAvoidBottomInset: true,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                    padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                    child: Table(
                      defaultColumnWidth: FlexColumnWidth(1.0),
                      columnWidths: {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(8),
                        2: FlexColumnWidth(4),
                      },
                      border: TableBorder.all(color: Colors.black),
                      children: [
                        TableRow(children: [
                          Column(children: [
                            Icon(MdiIcons.car, size: 30),
                            Container(
                                alignment: Alignment.center,
                                height: 30,
                                child: Text("ID: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black))),
                          ]),
                          Column(children: [
                            Icon(MdiIcons.tag, size: 30),
                            Container(
                                alignment: Alignment.center,
                                height: 30,
                                child: Text("Name: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black))),
                          ]),
                          Column(children: [
                            Icon(MdiIcons.walletGiftcard, size: 30),
                            Container(
                                alignment: Alignment.center,
                                height: 30,
                                child: Text("Sold: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black))),
                          ]),
                        ]),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ));
  }

  void _loadReport() async {
    int i;
    String urlLoadJobs = "https://yitengsze.com/carVroom/php/report.php";

    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Loading...");
      pr.show();

      http.post(urlLoadJobs, body: {}).then((res) {
        print(res.body);
        if (res.body.contains("nodata")) {
          Toast.show("Report failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } 
        else {
          
          List list = res.body.split(",");
          var product= list;
          var count = product.where((c) => c.id == product.length).toList().length;

          for (i = 0; i < count; i++) { 
            Container(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: Table(
                  defaultColumnWidth: FlexColumnWidth(1.0),
                  columnWidths: {
                    0: FlexColumnWidth(4),
                    1: FlexColumnWidth(8),
                    2: FlexColumnWidth(4),
                  },
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(children: [
                      Column(children: [
                        Container(
                            alignment: Alignment.center,
                            height: 30,
                            child: Text(" " + list[i]["id"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black))),
                      ]),
                      Column(children: [
                        Container(
                            alignment: Alignment.center,
                            height: 30,
                            child: Text(" " + list[i]["name"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black))),
                      ]),
                      Column(children: [
                        Container(
                            alignment: Alignment.center,
                            height: 30,
                            child: Text(" " + list[i]["sold"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black))),
                      ]),
                    ]),
                  ],
                ));
          }
          Toast.show("Report success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
        pr.hide();
      }).catchError((err) {
        print(err);
        pr.hide();
      });

      pr.hide();
    } catch (e) {
      Toast.show("Report Failed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<void> share(
      BuildContext context, User user, String bookid, String val) async {
    final RenderBox box = context.findRenderObject();
    final String text1 = " You've done your payment successfully!";
    final String text2 =
        " Here's your receipt \n Name: ${widget.user.name} \n Phone: ${widget.user.phone} \n Email: ${widget.user.email} \n Book id: ${widget.bookid} \n Amount: RM ${widget.val} \n THANK YOU! ";

    await Share.share(
      text2,
      subject: text1,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }
}
