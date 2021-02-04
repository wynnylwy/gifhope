import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'user.dart';
import 'order.dart';
import 'package:gifhope/bookdetailscreen.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final User user;

  const PaymentHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List paymentdata;
  List bookdetails;

  String titlecenter = "Loading purchase history...";
  final dateFormat = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;

  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
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
        title: Text('Purchase History',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white)),
      ),
      body: Center(
        child: Container(
          color: Colors.orange[100],
          child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10)
            ),
            paymentdata == null
                ? Flexible(
                    child: Container(
                        child: Center(
                    child: Shimmer.fromColors(
                                  baseColor: Colors.black,
                                  highlightColor: Colors.grey,
                                  child: Text(
                                    titlecenter,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Mogra',
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold),
                                  )),
                  )))
                : Expanded(
                    child: ListView.builder(
                        itemCount: paymentdata == null ? 0 : paymentdata.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
                              child: InkResponse( 
                                focusColor: Colors.blue[300],
                                hoverColor: Colors.blue[300],
                                highlightColor: Colors.blue[300],
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: () => setState(() {

                                  loadBookDetails(index);
                                }),
                                child: Card(
                                  elevation: 10,
                                  child: Row( 
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child:
                                            Text((index + 1).toString() + ".",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                )),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Order ID: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            Text(paymentdata[index]['orderid']),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "RM " +
                                                  paymentdata[index]['total'],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text("Bill ID: ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                Text(paymentdata[index]
                                                    ['billid']),
                                              ],
                                            ),
                                            Text(dateFormat
                                                .format(DateTime.parse(
                                              paymentdata[index]['date'],
                                            ))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        }),
                  ),
          ],
        ),

        ),
        
      ),
    );
  }

  // check got previous pymt record or not
  Future<void> _loadPaymentHistory() async {
    String urlLoadJobs =
        "https://yitengsze.com/a_gifhope/php/load_paymentHistory.php";

    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body.contains("nodata")) {
        setState(() {
          paymentdata = null;
          titlecenter = "No Payment Record";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          paymentdata = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadBookDetails(int index) {
    Order pay = new Order(
      billid: paymentdata[index]['billid'],
      orderid: paymentdata[index]['orderid'],
      total: paymentdata[index]['total'],
      datebook: paymentdata[index]['date'],
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => BookDetailScreen(
                  user: widget.user,
                  book: pay,
                )));
  }
}
