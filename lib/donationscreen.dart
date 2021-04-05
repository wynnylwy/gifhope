import 'dart:async';
import 'dart:convert';
import 'package:gifhope/charityscreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gifhope/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'charity.dart';
import 'order.dart';
import 'payment.dart';
import 'mainscreen.dart';
import 'paymentdonate.dart';

class DonationScreen extends StatefulWidget {
  final User user;
  // final Order book;
  // final String id;

  const DonationScreen({Key key, this.user}) : super(key: key);

  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  List donationData;
  double screenHeight, screenWidth;
  double _totalAmount = 0.0, _totalPayment = 0.0;

  double amountpayable;

  String label;

  @override
  void initState() {
    super.initState();
    // _getLocation(); //get current location
    _loadDonation();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    const Color(0xFFFDD835),
                    const Color(0xFFFBC02D),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          title: Text('Donate',
              style: TextStyle(
                  fontFamily: 'Sofia',
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.black)),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CharityScreen(
                              user: widget.user,
                            )));
              }),
          actions: <Widget>[
            IconButton(
                icon: Icon(MdiIcons.deleteEmpty),
                color: Colors.black,
                onPressed: () {
                  deleleAll();
                }),
          ],
        ),
        body: Container(
            color: Colors.amber[100],
            child: Center(
              child: Column(
                children: <Widget>[
                  Text("Here's Your Donation",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      )),
                  donationData == null
                      ? Flexible(
                          child: Container(
                              color: Colors.amber[100],
                              child: Center(
                                child: Shimmer.fromColors(
                                    baseColor: Colors.black,
                                    highlightColor: Colors.white,
                                    child: Text(
                                      "Loading Your Donation...",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Mogra',
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )),
                              )))
                      : Expanded(
                          child: ListView.builder(
                              itemCount: donationData == null
                                  ? 1
                                  : donationData.length + 1,
                              itemBuilder: (context, index) {
                                if (index == donationData.length) {
                                  return Container(
                                    height: screenHeight / 3.2,
                                    child: Card(
                                      elevation: 5,
                                      margin:
                                          EdgeInsets.fromLTRB(10, 10, 10, 8),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text("Summary of Payment",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 60),
                                          Text(
                                              "TOTAL AMOUNT RM: " +
                                                      _totalPayment
                                                          .toStringAsFixed(2) ??
                                                  "0.0",
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              )),
                                          SizedBox(
                                            height: 35,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                minWidth: 100,
                                                height: 50,
                                                child: Text('Make Payment',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                    )),
                                                color: Colors.yellow[300],
                                                textColor: Colors.black,
                                                elevation: 10,
                                                onPressed: makePayment,
                                              ),
                                              MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                minWidth: 140,
                                                height: 50,
                                                child: Text('Cancel',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                    )),
                                                color: Colors.yellow[300],
                                                textColor: Colors.black,
                                                elevation: 10,
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                index -= 0;

                                return Card(
                                    elevation: 10,
                                    margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Row(children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                  height: screenWidth / 4.3,
                                                  width: screenWidth / 4.5,
                                                  child: ClipRect(
                                                      child: CachedNetworkImage(
                                                    fit: BoxFit.scaleDown,
                                                    imageUrl:
                                                        "http://yitengsze.com/a_gifhope/charityimages/${donationData[index]['id']}.jpg",
                                                    placeholder: (context,
                                                            url) =>
                                                        new CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        new Icon(Icons.error),
                                                  ))),
                                              SizedBox(height: 10),
                                              Text(donationData[index]['genre'],
                                                  style: TextStyle(
                                                      fontSize: 17.0)),
                                            ],
                                          ),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  5, 1, 10, 1),
                                              child: SizedBox(
                                                  width: 3,
                                                  child: Container(
                                                    height: screenWidth /
                                                        2.3, //charity card's height
                                                    color: Colors.grey,
                                                  ))),
                                          Container(
                                              width: screenWidth / 1.5,
                                              child: Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(
                                                          donationData[index]
                                                              ['name'],
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 17.0),
                                                          maxLines: 3,
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Text(
                                                            "RM " +
                                                                donationData[
                                                                        index]
                                                                    ['amount'],
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17.0,
                                                                color:
                                                                    Colors.red),
                                                            maxLines: 3,
                                                          ),
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                  "Donor: " +
                                                                      donationData[
                                                                              index]
                                                                          [
                                                                          'donor'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14.0)),
                                                            ]),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                  "Email: " +
                                                                      donationData[
                                                                              index]
                                                                          [
                                                                          'email'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14.0)),
                                                            ]),
                                                        SizedBox(height: 15),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              TextButton(
                                                                onPressed: () =>
                                                                    {
                                                                  _deleteDonation(
                                                                      index)
                                                                },
                                                                child: Icon(
                                                                  MdiIcons
                                                                      .delete,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ]),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ])));
                              }),
                        ),
                ],
              ),
            )));
  }

  void _loadDonation() {
    _totalAmount = 0;
    _totalPayment =0;

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Donation updating...");
    pr.show();
    String urlLoadJobs =
        "https://yitengsze.com/a_gifhope/php/load_donation.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      pr.hide();

      if (res.body.contains("Donation Empty")) {
        widget.user.donation = "0"; //let the donate num =0
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CharityScreen(
                      user: widget.user,
                    )));
      }

      setState(() {
        var extractdata = json.decode(res.body);
        donationData = extractdata["donation"];
        for (int i = 0; i < donationData.length; i++) {
         
          _totalAmount = double.parse(donationData[i]['amount']) + _totalAmount;
        }

        _totalPayment = _totalAmount;

        print(_totalAmount);
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    pr.hide();
  }

  _deleteDonation(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Delete donation?',
            style: TextStyle(
              fontFamily: 'Bellota',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        actions: <Widget>[
          MaterialButton(
              child: Text("Yes",
                  style: TextStyle(
                    fontSize: 15.0,
                  )),
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(
                    "https://yitengsze.com/a_gifhope/php/delete_donation.php",
                    body: {
                      "email": widget.user.email,
                      "eventid": donationData[index]['id'],
                    }).then((res) {
                  print(res.body);
                  if (res.body.contains("success")) {
                    _loadDonation();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              }),
          MaterialButton(
              child: Text("Cancel",
                  style: TextStyle(
                    fontSize: 15.0,
                  )),
              onPressed: () {
                Navigator.of(context).pop(false);
              }),
        ],
      ),
    );
  }

  Future<void> makePayment() async {
    await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Make Payment? ',
          style: TextStyle(
            fontFamily: 'Bellota',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text("Yes",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                )),
            onPressed: () {
              var now = new DateTime.now(); //current time
              var dateFormat = new DateFormat('MMM d, yyyy hh:mm a');
              String donationid = widget.user.email.substring(0, 5) +
                  "-" +
                  dateFormat.format(now) +
                  randomAlphaNumeric(6);

              print(donationid);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PaymentDonateScreen(
                            user: widget.user,
                            val: _totalPayment.toStringAsFixed(2),
                            donateid: donationid, ////check!
                          ))).then((result) {
                Navigator.of(context).pop();
              });
            },
          ),
          MaterialButton(
            child: Text("Cancel",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                )),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );

    _loadDonation();

  
  }

  void deleleAll() {
    showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: new Text('Delete all products?',
                  style: TextStyle(
                    fontFamily: 'Bellota',
                    fontWeight: FontWeight.bold,
                  )),
              actions: <Widget>[
                MaterialButton(
                    child: Text('Yes',
                        style: TextStyle(
                          fontSize: 16.0,
                        )),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      http.post(
                          "https://yitengsze.com/a_gifhope/php/delete_donation.php",
                          body: {
                            "email": widget.user.email,
                          }).then((res) {
                        print(res.body);

                        if (res.body.contains("success")) {
                          _loadDonation();
                        } else {
                          Toast.show("Failed", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        }
                      }).catchError((err) {
                        print(err);
                      });
                    }),
                MaterialButton(
                    child: Text('No',
                        style: TextStyle(
                          fontSize: 16.0,
                        )),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    }),
              ],
            ));
  }
}
